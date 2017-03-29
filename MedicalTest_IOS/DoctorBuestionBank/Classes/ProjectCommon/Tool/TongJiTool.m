//
//  TongJiTool.m
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/16.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import "TongJiTool.h"
#import "UMMobClick/MobClick.h"
//#import "Zhuge.h"
#import "NLog.h"

#define Caches [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]


@interface TongJiTool ()

@property (nonatomic, strong) NSDictionary *dicData;

@end

@implementation TongJiTool

+ (UIViewController *)findNearsetViewController:(UIView *)view {
    UIViewController *viewController = nil;
    for (UIView *next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)nextResponder;
            break;
        }
    }
    return viewController;
}

+ (void)initTongJi
{
    //初始化友盟统计模块
    UMConfigInstance.appKey = UMAnailyticsKey;
    UMConfigInstance.channelId = @"App Store";
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //  版本号
    NSString *version = UMengVersion;
    [MobClick setAppVersion:version];
   
    //公司统计 暂缺，申请成功后，设置key即可
//    [NLog startWithAppKey:XYWYKey channel:@"appStore"];
}

+ (void)XYWYBeginLogPageView:(NSString *)eventId
{
    [MobClick beginLogPageView:eventId];
    [NLog nlogBeginLogPageView:eventId];
}

+ (void)XYWYEndLogPageView:(NSString *)eventId
{
    [MobClick endLogPageView:eventId];
    [NLog nlogEndLogPageView:eventId];
}

+ (void)XYWYClickEvent:(NSString *)eventName attributes:(NSDictionary *)attributes
{
    if (attributes == nil) {
        [MobClick event:eventName];
        [NLog nlogEvent:eventName];
        
    }else{
        [MobClick event:eventName attributes:attributes];
        [NLog nlogEvent:eventName attributes:attributes];
    }

    /*
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Tongji" ofType:@"plist"];
    dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *stirng = [dic objectForKey:eventName];
    [[Zhuge sharedInstance] track:[dic objectForKey:eventName] properties: attributes];
    */
     
}

- (NSDictionary *)dicData
{
    if (!_dicData) {
        _dicData = [[NSMutableDictionary alloc]init];
        NSString *filePath = [Caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", @"Tongji"]];
        _dicData = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return _dicData;
}

@end
