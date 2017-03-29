//
//  NLog.h
//  NLogDemo
//
//  Created by shen yan ping on 15/9/15.
//  Copyright (c) 2015年 寻医问药. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLog : NSObject
/** 初始化统计框架
 @param appid    当前APP的标识，从网站上获取
 @param channel  当前渠道名称
 @return void
 */
+ (void)startWithAppKey:(NSString *) appid channel:(NSString*)channel;


///---------------------------------------------------------------------------------------
/// @name  事件统计
///---------------------------------------------------------------------------------------

/** 自定义事件,数量统计.
 使用前，请先到App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @param  attributes 当前事件的属性和取值（键值对）.
 @return void.
 */
+ (void)nlogEvent:(NSString *)eventId;

+ (void)nlogEvent:(NSString *)eventId attributes:(NSDictionary *)attributes;

///---------------------------------------------------------------------------------------
/// @name  页面统计
///---------------------------------------------------------------------------------------

/** 自动页面时长统计, 开始记录某个页面展示时长.
 使用方法：必须配对调用nlogBeginLogPageView:和nlogEndLogPageView:两个函数来完成自动统计
 在该页面展示时(viewWillAppear:)调用nlogBeginLogPageView:，当退出该页面时(viewWillDisappear:)调用nlogEndLogPageView:
 @param pageName 统计的页面名称.
 @return void.
 */
+ (void)nlogBeginLogPageView:(NSString *)pageName;
+ (void)nlogEndLogPageView:(NSString *)pageName;

/** 获取app标识.
 @return void.
 */
+ (NSString *)getAppId;

/** 设置用户信息.
 @param userId 用户标识.
 @param userType 用户类型：如 会员
 @return void.
 */

///---------------------------------------------------------------------------------------
/// @name  用户信息
///---------------------------------------------------------------------------------------
+ (void)setUserID:(NSString*)userId userType:(NSString*)userType;

/** 清除用户信息.
 @return void.
 */
+ (void)cleanUserInfo;

/** 是否开启崩溃日志收集.
    为保证正确收集，SDK的初始化应置于其他含崩溃收集的SDK初始化之后.
 @param isEnable 默认YES，为NO时不收集崩溃日志.
 @return void.
 */
+ (void)setCrashReportEnabled:(BOOL)isEnable;

/** 是否开启定位服务,请置于初始化函数startWithAppKey:之前.
 关闭后对设备定位、区域分析将受影响.
 @param isEnable 默认YES，为NO时不弹定位授权提示框.
 @return void.
 */
+ (void)setLocationEnabled:(BOOL)isEnable;
@end
