//
//  HTTPRequestManager.m
//  WKDoctor
//  request生成器，单例
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"
#import "HttpTools.h"
#import "HTTPRequestErrorHandler.h"
#import "HTTPApiBase.h"

@interface HTTPRequestManager ()
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer <AFURLResponseSerialization> * responseSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializerUpload;
@property (nonatomic, strong) NSMutableDictionary *operationList;
@end

@implementation HTTPRequestManager

static HTTPRequestManager *sharedManager = nil;
+ (instancetype)sharedManager
{
    if (!sharedManager) {
        sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [self.requestSerializer setTimeoutInterval:10.0];
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
        self.responseSerializer.removesKeysWithNullValues = YES;
        
        //在上传时选用这个serializer, 设置超时时间是30s
        self.requestSerializerUpload = [AFHTTPRequestSerializer serializer];
        [self.requestSerializerUpload willChangeValueForKey:@"timeoutInterval"];
        [self.requestSerializerUpload setTimeoutInterval:30.0];
        [self.requestSerializerUpload didChangeValueForKey:@"timeoutInterval"];

        
        self.requestErrorHandler = [HTTPRequestErrorHandler erroHandler];
        
        //存储operation列表, 因为我们app会有很多个baseurl
        _operationList = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (AFHTTPRequestOperationManager *)getOperationManagerByBaseUrl:(HTTPRequest *)request
{
    NSString *key = [NSString stringWithFormat:@"%ld", (long)request.requestType];
    AFHTTPRequestOperationManager *operation = [self.operationList objectForKey:key];
    if (!operation)
    {
        operation  = [[AFHTTPRequestOperationManager alloc] init];
        operation.responseSerializer = self.responseSerializer;
        //根据请求类型, 选用不用的Serializer, 因为超时时间不同
        if (request.requestType == HTTP_UPLOAD)
        {
            operation.requestSerializer = self.requestSerializerUpload;
        }
        else
        {
            operation.requestSerializer = self.requestSerializer;
        }
        
        [self.operationList setObject:operation forKey:key];
    }
    return operation;
}


- (HTTPRequest *)GHRequestWithRequest:(NSMutableURLRequest *)request
                             callback:(HTTPRequestCallback)callback
{
    return [[HTTPRequest alloc] initWithRequest:request
                                       callBack:callback];
}

- (void)startRequest:(HTTPRequest *)request
{
    request.myProgress = 0;
    
    NSString *savePath = request.fileSavePath;
    if (!savePath) {
        savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    }
    AFHTTPRequestOperationManager *manager = [self getOperationManagerByBaseUrl:request];
    AFHTTPRequestOperation *operation = nil;
    
    
    operation = [manager HTTPRequestOperationWithRequest:request.urlRequest
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     [request callBackWithResponse:responseObject error:nil];
                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     [request callBackWithResponse:nil error:error];
                 }];
    
    
    
    if (request.requestType == HTTP_UPLOAD)
    {
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            request.myProgress = ((double)totalBytesWritten)/totalBytesExpectedToWrite;
        }];
    }
    else if(request.requestType == HTTP_DOWNLOAD)
    {
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:savePath append:NO];
        
    }
    else
    {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            request.myProgress = ((double)totalBytesRead)/totalBytesExpectedToRead;
        }];
    }
    
    [[manager operationQueue] addOperation:operation];
    [request requestDidStartWithOperation:operation];
}


- (HTTPRequest *)GET:(NSString *)URLString
          parameters:(NSDictionary *)parameters
            callback:(HTTPRequestCallback)callback
{
    return [self requestWithMethod:@""
                            method:@"GET"
                         urlString:URLString
                        parameters:parameters
                          callback:callback];
}

- (HTTPRequest *)POST:(NSString *)URLString
           parameters:(NSDictionary *)parameters
             callback:(HTTPRequestCallback)callback
{
    return [self requestWithMethod:@""
                            method:@"POST"
                         urlString:URLString
                        parameters:parameters
                          callback:callback];
}

- (HTTPRequest *)GETAndPOST:(NSString *)URLString
                   getParam:(NSDictionary *)getParam
                  postParam:(NSDictionary *)postParam

                   callback:(HTTPRequestCallback)callback
{
    NSString *getURL =[HttpTools generateURLPathWithGetParameters:getParam];
   
    NSString *signStr = [HttpTools signWithGetParameters:getParam postParameters:postParam key:SIGN_PRIVATE_KEY];
 
    NSString *postURL = [NSString stringWithFormat:@"%@?%@&sign=%@",URLString,getURL,signStr];
    return [self requestWithMethod:@""
                            method:@"POST"
                         urlString:postURL
                        parameters:postParam
                          callback:callback];
}


- (HTTPRequest *)downLoad:(NSString *)URLString
                 savePath:(NSString *)savePath
                 callback:(HTTPRequestCallback)callback
{
    NSURL *base = [NSURL URLWithString:@""];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString relativeToURL:base]];
    
    HTTPRequest *request = [self GHRequestWithRequest:urlRequest
                                             callback:callback];
    request.requestType = HTTP_DOWNLOAD;
    request.path = URLString;
    request.fileSavePath = savePath;
    request.HTTPMethod = @"GET";
    [self startRequest:request];
    return request;
}

- (HTTPRequest *)POST:(NSString *)URLString
           parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
             progress:(void(^)(HTTPRequest *request,double progress))progressBlock
             callback:(HTTPRequestCallback)callback
{
    NSURL *base = [NSURL URLWithString:@""];
    NSString *postURL = [[NSURL URLWithString:URLString relativeToURL:base] absoluteString];
    
    NSMutableURLRequest *urlRequest = [self.requestSerializerUpload multipartFormRequestWithMethod:@"POST"
                                                                                         URLString:postURL
                                                                                        parameters:parameters
                                                                         constructingBodyWithBlock:block
                                                                                             error:nil];
    
    
    
    HTTPRequest *request = [self GHRequestWithRequest:urlRequest
                                             callback:callback];
    request.path = URLString;
    request.HTTPMethod = @"POST";
    request.parameters = parameters;
    request.requestType = HTTP_UPLOAD;
    request.progressBlock = progressBlock;
    [self startRequest:request];
    return request;
}

- (HTTPRequest *)requestWithMethod:(NSString *)BaseURLString
                            method:(NSString *)method
                         urlString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          callback:(HTTPRequestCallback)callback
{
    NSURL *base = [NSURL URLWithString:BaseURLString];
    NSString *postURL = [[NSURL URLWithString:urlString relativeToURL:base] absoluteString];
    
    NSMutableURLRequest *urlRequest = [self.requestSerializer requestWithMethod:method
                                                                      URLString:postURL
                                                                     parameters:parameters
                                                                          error:nil];
    
    
    NSLog(@"-----getUrl %@" , urlRequest.URL.absoluteString);
    
    
    HTTPRequest *request = [self GHRequestWithRequest:urlRequest
                                             callback:callback];
    request.path = urlString;
    request.requestType = HTTP_DEFAULT;
    request.HTTPMethod = method;
    request.parameters = parameters;
    [self startRequest:request];
    return request;
}

- (BOOL)resendRequest:(HTTPRequest *)request
{
    if (request && request.retryCount > 0)
    {
        request.retryCount--;
        [self startRequest:request];
        return YES;
    }
    return NO;
}
@end

