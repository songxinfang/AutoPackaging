//
//  HttpTools.h
//  XYWYComponents
//
//  Created by 王辉 on 16/4/26.
//  Copyright © 2016年 xywy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTools : NSObject 
/**
 *  根据字典, 生成url
 *
 *  @param getParams 传入字典
 *
 *  @return 返回url
 */
+ (NSString *)generateURLPathWithGetParameters:(NSDictionary *)getParams;

/**
 *  通过字典生成sig
 *
 *  @param getParams  get参数
 *  @param postParams post参数
 *
 *  @return sig
 */
+ (NSString *)signWithGetParameters:(NSDictionary *)getParams
                     postParameters:(NSDictionary *)postParams
                                key:(NSString *)key;

/**
 *  检测网络连接状态
 *
 *  @return status
 */
+ (BOOL)netStatus;

/**
 *  URL编码
 *
 *  @return 编码结果
 */
+ (NSString *)URLEncodeString:(NSString *)str;

/**
 *  MD5加密
 *
 *  @return 加密结果
 */
+ (NSString *)MD5Hash:(NSString *)str;

@end
