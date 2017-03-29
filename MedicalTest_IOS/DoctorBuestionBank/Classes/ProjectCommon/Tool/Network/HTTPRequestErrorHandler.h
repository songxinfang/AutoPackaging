//
//  HTTPRequestErrorHandler.h
//  WKDoctor
//  统一网络错误处理和解析
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPRequest;
//错误码定义

typedef NS_ENUM(NSInteger, HttpRequestErrorCode)
{
    ERR_CODE_SUCCESS = 10000,                    //成功
    ERR_CODE_FATAL_SYSTEM = 100100,              //@"网络不给力,请稍后重试"
    ERR_CODE_FATAL_TIMEOUT = -1001,              //超时
    ERR_CODE_FATAL_TOKEN_EXPIRED = -50000,       //token过期
    ERR_CODE_FATAL_UNKNOWN = 30000,              //未知错误
    ERR_CODE_FATAL_UNKNOWN_ACTION = 31001,       //未知行为
    ERR_CODE_FATAL_FIELD_EMPTY = 31002,          //字段不能空
    ERR_CODE_FATAL_PHONENUMBER_ERROR = 31003,      //手机号码不正确
    ERR_CODE_FATAL_EXCEEDMAX = 31004,              //该手机当天发送量超过最大数量
    ERR_CODE_FATAL_REPEATED = 31005,               //禁止重复发送(n秒内)
    ERR_CODE_FATAL_OTHER = 31006,                  //其他原因导致发送失败
    ERR_CODE_FATAL_COOD_EMPTY = 31007,             //验证码为空
    ERR_CODE_FATAL_VALIDATION_FAILURE = 31008,     //验证不通过
    ERR_CODE_FATAL_BINDING_VREPEATED = 31014,      //禁止重复绑定手机号
    ERR_CODE_FATAL_HAS_BINDINGED = 31015,          //该手机号已被其他帐号绑定
    ERR_CODE_FATAL_BINDINGED_FAILURE = 31016,      //绑定失败
    ERR_CODE_FATAL_MAIL_FAILURE = 31017,           //邮箱格式不正确
    ERR_CODE_FATAL_MAIL_BINDING_VREPEATED = 31018, //禁止重复绑定邮箱
    ERR_CODE_FATAL_MAIL_HAS_BINDINGED = 31019,  //该邮箱已被其他帐号绑定
    ERR_CODE_FATAL_USERID_EMPTY = 31020 ,        //用户ID为空
    ERR_CODE_FATAL_Format = 40000         //后台数据格式错误

};

/**
 *  错误处理，解析
 */
@interface HTTPRequestErrorHandler : NSObject
+ (instancetype)erroHandler;

/**
 *  获取错误描述
 *
 *  @param errorCode 错误码
 *
 *  @return 错误描述
 */
+ (NSString *)descriptionWithCode:(NSInteger)errorCode;

/**
 *  获取验证码的错误描述
 *
 *  @param errorCode 错误码
 *
 *  @return 错误描述
 */
+ (NSString *)descriptionWithCodeCode:(NSInteger)errorCode;


/**
 *  判断是否是错误
 *
 *  @param errorCode 错误码
 *
 *  @return 错误描述
 */
+ (BOOL)isError:(NSInteger)errorCode;

/**
 *  错误处理
 *
 *  @param error   错误
 *  @param request 请求
 *
 *  @return 返回是否是错误
 */
- (BOOL)handleError:(NSError *)error request:(HTTPRequest *)request;
@end

