//
//  HTTPApiBase.h
//  LoginModule
//  Http请求基本数据
//  Created by 王辉 on 16/2/6.
//  Copyright © 2016年 xywy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPRequest.h"
#import "HTTPRequestManager.h"
#import "HTTPModel.h"

@interface HTTPApiBase : NSObject

/**
 *  initBaseParams
 *
 *  @param api        请求api
 *  @param version    接口版本
 *  @param params     其他get参数
 */
+ (NSMutableDictionary *)initBaseParams:(NSString *)api
                                version:(NSString *)version
                                 params:(NSDictionary *)params;

/**
 *  initBaseParamsAndTocken
 *
 *  @param api        请求api
 *  @param version    接口版本
 *  @param params     其他get参数
 *  @param token      oauth令牌
 */
+ (NSMutableDictionary *)initBaseParamsAndTocken:(NSString *)api
                                         version:(NSString *)version
                                          params:(NSDictionary *)params
                                           token:(NSString*)token;


+(void) basePosttRequestWithUrl:(NSString *) url  getParam :(NSMutableDictionary *) param postParam:(NSMutableDictionary *) postParam block:(void (^)(id result))block;



@end
