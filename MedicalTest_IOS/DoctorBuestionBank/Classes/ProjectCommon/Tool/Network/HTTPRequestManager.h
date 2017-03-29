//
//  HTTPRequestManager.h
//  WKDoctor
//  request生成器，单例
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import "HTTPRequest.h"

@protocol AFMultipartFormData;
@class HTTPRequestErrorHandler;

@interface HTTPRequestManager : NSObject
@property (nonatomic, strong) HTTPRequestErrorHandler * requestErrorHandler;

/**
 *  构造单例
 *
 *  @return instancetype
 */
+ (instancetype)sharedManager;

/**
 *  发送get请求
 *
 *  @param BaseURLString  请求Baseurl
 *  @param URLString  请求url
 *  @param parameters 参数列表
 *  @param callback   回调
 *
 *  @return <#return value description#>
 */
- (HTTPRequest *)GET:(NSString *)URLString
          parameters:(NSDictionary *)parameters
            callback:(HTTPRequestCallback)callback;

/**
 *  发送post请求
 *
 *  @param BaseURLString  请求Baseurl
 *  @param URLString  请求url
 *  @param parameters 参数列表
 *  @param callback   回调
 *
 *  @return <#return value description#>
 */
- (HTTPRequest *)POST:(NSString *)URLString
           parameters:(NSDictionary *)parameters
             callback:(HTTPRequestCallback)callback;


- (HTTPRequest *)GETAndPOST:(NSString *)URLString
                   getParam:(NSDictionary *)getParam
                  postParam:(NSDictionary *)postParam
                   callback:(HTTPRequestCallback)callback;

/**
 *  发送post请求, 带附件
 *
 *  @param BaseURLString  请求Baseurl
 *  @param URLString  请求url
 *  @param parameters 参数列表
 *  @param constructingBodyWithBlock   上传数据
 *  @param progress   进度
 *  @param callback   回调
 *
 *  @return <#return value description#>
 */
- (HTTPRequest *)POST:(NSString *)URLString
           parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
             progress:(void(^)(HTTPRequest *request,double progress))progressBlock
             callback:(HTTPRequestCallback)callback;

/**
 *  下载请求
 *
 *  @param BaseURLString  请求Baseurl
 *  @param URLString 请求url
 *  @param savePath  保存路径
 *  @param callback  回调
 *
 *  @return <#return value description#>
 */
- (HTTPRequest *)downLoad:(NSString *)URLString
                 savePath:(NSString *)savePath
                 callback:(HTTPRequestCallback)callback;

/**
 *  重新发送一个请求, 将原对象重新发送, 当网络超时, 并且请求设置了重试次数的, 会自动重试
 *
 *  @param request  请求对象
 *
 *  @return bool 标识是否重新发送
 */
- (BOOL)resendRequest:(HTTPRequest *)request;

@end
