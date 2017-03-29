//
//  HTTPRequest.m
//  WKDoctor
//  封装网络请求对象，以及请求信息
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import "HTTPRequest.h"
#import "AFHTTPRequestOperation.h"
#import "HTTPRequestManager.h"
#import "HTTPModel.h"
#import "HTTPRequestErrorHandler.h"

@implementation HTTPRequest
{
    NSString *_identifier;
    NSProgress *_nsProgress;
}

- (void)dealloc
{
    if (_nsProgress)
    {
        [_nsProgress removeObserver:self forKeyPath:@"fractionCompleted" context:nil];
    }
}


- (instancetype)initWithRequest:(NSURLRequest *)request
                       callBack:(HTTPRequestCallback)callback
{
    self = [self init];
    if (self)
    {
        self.urlRequest = request;
        self.resultCallback = callback;
        self.retryCount = 0;
    }
    return self;
}

- (void)requestDidStartWithOperation:(AFHTTPRequestOperation *)operation
{
    _requestOperation = operation;
}

- (NSHTTPURLResponse *)urlResponse
{
    if (_requestOperation.response)
    {
        return _requestOperation.response;
    }
    return nil;
}

- (NSString *)identifier
{
    if (!_identifier)
    {
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return _identifier;
}

- (NSString *)HTTPBodyString
{
    return [[NSString alloc] initWithData:self.urlRequest.HTTPBody
                                 encoding:NSUTF8StringEncoding];
}


- (void)callBackWithResponse:(id)response
                       error:(NSError *)error
{
    NSLog(@"---%@---%@", response, error);
    HTTPModel *object = nil;
    if(self.resultObjectClass)
    {
        object = [[self.resultObjectClass alloc] init];
    }
    else
    {
        object = [[HTTPModel alloc] init];
    }
    
    if (error)
    {
        BOOL ret = [[HTTPRequestManager sharedManager].requestErrorHandler handleError:error
                                                                               request:self];
        //如果统一的错误处理已经将错误处理, 那也无需再通知了
        if (ret)
        {
            return;
        }
        object.isSuccess = NO;
        object.code = ERR_CODE_FATAL_SYSTEM;
        object.error = error;
    }
    else
    {
        if ([object respondsToSelector:@selector(parserResponse:)])
        {
            [object parserResponse:response];
        }
    }
    
    
    if (self.resultCallback)
    {
        self.resultCallback(self, object);
    }
}

- (void)setMyProgress:(double)progress
{
    _myProgress = progress;
    if (self.progressBlock)
    {
        self.progressBlock(self, progress);
    }
}

- (void)cancel
{
    [_requestOperation cancel];
    _requestOperation = nil;
}

- (void)suspend
{
    [_requestOperation pause];
}

- (void)resume
{
    [_requestOperation resume];
}

- (NSString *)description
{
    return [self.urlRequest description];
}

- (void)setNSProgress:(NSProgress *)progress
{
    if (_nsProgress)
    {
        [_nsProgress removeObserver:self
                         forKeyPath:@"fractionCompleted"
                            context:nil];
    }
    _nsProgress = progress;
    if (_nsProgress)
    {
        [_nsProgress addObserver:self
                      forKeyPath:@"fractionCompleted"
                         options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _nsProgress)
    {
        self.myProgress = _nsProgress.fractionCompleted;
    }
}

@end
