//
//  TongJiTool.h
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/16.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TongJiTool : NSObject
+ (UIViewController *)findNearsetViewController:(UIView *)view;
/**
 *
 *  初始化统计相关数据
 *
 */
+ (void)initTongJi;

/**
 *  页面的统计: 写在viewWillAppear:中
 *
 *  @param eventId 事件ID
 *
 */
+ (void)XYWYBeginLogPageView:(NSString *)eventId;

/**
 *  页面的统计: 写在viewWillDisappear:中
 *
 *  @param eventId 事件ID
 *
 */
+ (void)XYWYEndLogPageView:(NSString *)eventId;

/**
 *  点击事件的统计(埋点后需要更新Tongji.plist文件用于诸葛统计中通过key取出中文名称并上传)
 *
 *  @param eventName 事件ID或名称
 *
 *  @param attributes 属性
 *
 */
+ (void)XYWYClickEvent:(NSString *)eventName attributes:(NSDictionary *)attributes;

@end
