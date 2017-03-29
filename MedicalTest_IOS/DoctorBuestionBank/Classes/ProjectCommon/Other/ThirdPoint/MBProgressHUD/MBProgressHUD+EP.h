//
//  MBProgressHUD+EP.h
//  ExpertPlus
//
//  Created by xywy—iOS on 15/4/10.
//  Copyright (c) 2015年 xywy—iOS. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)

+ (MBProgressHUD *)showLoading;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showMessage:(NSString *)message time:(CGFloat)time;

+ (void)showSuccess:(NSString *)success;
//+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

+ (void)showError:(NSString *)error toView:(UIView *)view time:(CGFloat)time;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view time:(CGFloat)time;

+ (void)showSuccess:(NSString *)success time:(CGFloat)time;

+ (void)showError:(NSString *)error time:(CGFloat)time;
+ (void)showError:(NSString *)error;
@end
