//
//  HTTPRequestErrorHandler.m
//  WKDoctor
//  统一网络错误处理和解析
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import "HTTPRequestErrorHandler.h"
#import "HTTPRequestManager.h"

@implementation HTTPRequestErrorHandler
+ (instancetype)erroHandler
{
    return [[self alloc] init];
}

//返回yes, 则是已经处理问题, 不需要再通知调用者
- (BOOL)handleError:(NSError *)error request:(HTTPRequest *)request
{
    switch (error.code)
    {
        case ERR_CODE_FATAL_TIMEOUT:
        {
            BOOL ret = [[HTTPRequestManager sharedManager] resendRequest:request];
            return ret;
        }
        break;
    }
    
    return NO;
}

+ (NSString *)descriptionWithCode:(NSInteger)errorCode
{
    switch (errorCode)
    {
        case ERR_CODE_SUCCESS:return @"成功";
        case ERR_CODE_FATAL_SYSTEM:return @"网络不给力,请稍后重试";
        case ERR_CODE_FATAL_TIMEOUT:return @"连接超时，请重试";

    }
    return nil;
}

+ (NSString *)descriptionWithCodeCode:(NSInteger)errorCode
{
    switch (errorCode)
    {
        case ERR_CODE_SUCCESS:return @"成功";
        case ERR_CODE_FATAL_SYSTEM:return @"网络不给力,请稍后重试";
        case ERR_CODE_FATAL_TIMEOUT:return @"连接超时，请重试";
        case ERR_CODE_FATAL_UNKNOWN:return @"请稍后重试";
        case ERR_CODE_FATAL_UNKNOWN_ACTION:return @"请稍后重试";
        case ERR_CODE_FATAL_FIELD_EMPTY:return @"请稍后重试";
        case ERR_CODE_FATAL_PHONENUMBER_ERROR:return @"手机号码不正确";
        case ERR_CODE_FATAL_EXCEEDMAX:return @"该手机当天发送量超过最大数量";
        case ERR_CODE_FATAL_REPEATED:return @"禁止重复发送(n秒内)";
        case ERR_CODE_FATAL_OTHER:return @"其他原因导致发送失败";
        case ERR_CODE_FATAL_VALIDATION_FAILURE:return @"验证不通过";
        case ERR_CODE_FATAL_Format:return @"后台数据格式错误";

    }
    return nil;
}

+ (BOOL)isError:(NSInteger)errorCode
{
    switch (errorCode)
    {
        case ERR_CODE_SUCCESS:
        {
            return NO;
        }
        case ERR_CODE_FATAL_SYSTEM:
        case ERR_CODE_FATAL_TIMEOUT:
        case ERR_CODE_FATAL_UNKNOWN:
        case ERR_CODE_FATAL_UNKNOWN_ACTION:
        case ERR_CODE_FATAL_FIELD_EMPTY:
        case ERR_CODE_FATAL_PHONENUMBER_ERROR:
        case ERR_CODE_FATAL_EXCEEDMAX:
        case ERR_CODE_FATAL_REPEATED:
        case ERR_CODE_FATAL_OTHER:
        case ERR_CODE_FATAL_VALIDATION_FAILURE:
        {
            return YES;
        }
    }
    return NO;
}
@end