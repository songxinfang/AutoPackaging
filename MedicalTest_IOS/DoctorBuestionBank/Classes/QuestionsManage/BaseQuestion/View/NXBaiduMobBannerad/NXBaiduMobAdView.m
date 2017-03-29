//
//  NXBaiduMobAdView.m
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/11/10.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NXBaiduMobAdView.h"


@implementation NXBaiduMobAdView



static id _instance;


+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
    
}

+ (instancetype)shareNXBaiduMobAdView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


@end
