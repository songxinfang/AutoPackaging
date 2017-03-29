//
//  HTTPRequest.h
//  WKDoctor
//  封装网络请求对象，以及请求信息
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequestErrorHandler.h"

@class AFHTTPRequestOperation;
@class HTTPModel;

/**
 *  网络数据回调
 *
 *  @param request        请求对象
 *  @param responseObject 解析后数据
 *  @param error          错误信息
 */
typedef void (^HTTPRequestCallback)(HTTPRequest *request, HTTPModel *responseObject);

/**
 *  上传/下载数据进度
 *
 *  @param request  请求对象
 *  @param progress 进度
 */
typedef void (^HTTPRequestProgressBlock)(HTTPRequest *request, double progress);

/**
 *  请求类型定义
 */
typedef NS_ENUM(NSInteger, HttpRequestType) {
    /**
     *  get请求
     */
    HTTP_DEFAULT = 0,
    /**
     *  上传请求
     */
    HTTP_UPLOAD = 1,
    /**
     *  下载请求
     */
    HTTP_DOWNLOAD = 2   //下载
};


/**
 *  封装网络请求
 */
@interface HTTPRequest : NSObject


@property (nonatomic, retain)           NSURLRequest *urlRequest;
@property (nonatomic, readonly)         NSHTTPURLResponse *urlResponse;

@property (nonatomic, weak, readonly)   AFHTTPRequestOperation *requestOperation;
@property (nonatomic, copy)             HTTPRequestCallback resultCallback;
@property (nonatomic, copy)             HTTPRequestProgressBlock progressBlock;

@property (nonatomic, copy)             NSString *path;
@property (nonatomic, copy)             NSString *HTTPMethod;
@property (nonatomic, copy, readonly)   NSString *HTTPBodyString;
@property (nonatomic, copy)             NSString *fileSavePath;
@property (nonatomic, copy, readonly)   NSString *identifier;
@property (nonatomic, retain)           NSDictionary *parameters;

@property (nonatomic, assign)           Class resultObjectClass;
@property (nonatomic, assign)           double myProgress;

@property (nonatomic, assign)           HttpRequestType requestType;
@property (nonatomic, assign)           NSInteger retryCount;

/**
 *  初始化函数
 *
 *  @param request  请求对象
 *  @param callback 回调
 *
 *  @return 生成的对象
 */
- (instancetype)initWithRequest:(NSURLRequest *)request
                       callBack:(HTTPRequestCallback)callback;

/**
 *  设置operation
 *
 *  @param operation operation对象
 */
- (void)requestDidStartWithOperation:(AFHTTPRequestOperation *)operation;

/**
 *  解析response对象
 *
 *  @param response 网络返回数据
 *  @param error    http错误信息
 */
- (void)callBackWithResponse:(id)response
                       error:(NSError *)error;

/**
 *  取消
 */
- (void)cancel;

/**
 *  暂停
 */
- (void)suspend;

/**
 *  回复
 */
- (void)resume;

/**
 *  设置进度
 *
 *  @param progress 进度
 */
- (void)setNSProgress:(NSProgress *)progress;

@end
