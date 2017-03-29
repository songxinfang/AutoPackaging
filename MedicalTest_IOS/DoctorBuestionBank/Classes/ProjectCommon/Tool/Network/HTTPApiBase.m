//
//  HTTPApiBase.m
//  LoginModule
//
//  Created by 王辉 on 16/2/6.
//  Copyright © 2016年 xywy. All rights reserved.
//

#import "HTTPApiBase.h"


@implementation HTTPApiBase


+ (NSMutableDictionary *)initBaseParams:(NSString *)api
                                version:(NSString *)version
                                 params:(NSDictionary *)params
{
    NSMutableDictionary *GetParameters = [NSMutableDictionary dictionaryWithDictionary:params];
//    GetParameters[@"version"] = version;
//    GetParameters[@"source"] = RM_SOURCE;
//    GetParameters[@"os"] = RM_OS;
//    GetParameters[@"api"] = api;
//    GetParameters[@"pro"] = RM_PRO;
    return GetParameters;
}

+ (NSMutableDictionary *)initBaseParamsAndTocken:(NSString *)api
                                         version:(NSString *)version
                                          params:(NSDictionary *)params
                                           token:(NSString*)token
{
    NSMutableDictionary *GetParameters = [NSMutableDictionary dictionaryWithDictionary:params];
    GetParameters[@"version"] = version;
//    GetParameters[@"source"] = RM_SOURCE;
//    GetParameters[@"os"] = RM_OS;
//    GetParameters[@"api"] = api;
//    GetParameters[@"pro"] = RM_PRO;
//    GetParameters[@"token"] = token;
    return GetParameters;
}


+(void) basePosttRequestWithUrl:(NSString *) url  getParam :(NSMutableDictionary *) param postParam:(NSMutableDictionary *) postParam block:(void (^)(id result))block
{
    
    NSMutableString * mStr = [NSMutableString string];
    __block NSInteger count = 0;
    
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        count++;
        NSString * str = nil;
        if (count == param.count) {
            str =  [NSString stringWithFormat:@"&%@=%@" , key , obj];
        }else
        {
            str =  [NSString stringWithFormat:@"&%@=%@&" , key , obj];
        }
        
        
        
        [mStr appendString:str];
        
        
        
    }];
    
    url = [NSString stringWithFormat:@"%@?%@" , url , mStr];
    
    HTTPRequestManager *manager = [HTTPRequestManager sharedManager];
    
    
    
    [manager POST:url parameters:postParam callback:^(HTTPRequest *request, HTTPModel *responseObject) {
        
        NSLog(@"responseObject: %@ - error: %@", responseObject, responseObject.error);
        if(responseObject.isSuccess)
        {
            if (responseObject.code == ERR_CODE_SUCCESS) {
                NSArray *msgArray = responseObject.data;
                if (block) {
                    // block(msgArray);
                    block(responseObject.data);
                    
                }
            }
            else {
                NSError *tempError = [NSError errorWithDomain:@"GET_MSG_ERROR"
                                                         code:responseObject.code
                                                     userInfo:@{NSLocalizedFailureReasonErrorKey : responseObject.msg}];
                if (block) {
                    block(tempError);
                }
            }
        }
        else
        {
            if (block) {
                block(responseObject.error);
            }
            return ;
        }
        
    }];
    
    
    
    
    
    
}


@end
