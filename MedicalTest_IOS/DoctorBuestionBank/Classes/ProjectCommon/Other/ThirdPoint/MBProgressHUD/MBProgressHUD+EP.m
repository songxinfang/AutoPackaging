//
//  MBProgressHUD+EP.m
//  ExpertPlus
//
//  Created by xywy—iOS on 15/4/10.
//  Copyright (c) 2015年 xywy—iOS. All rights reserved.
//

#import "MBProgressHUD+EP.h"
#import "AppDelegate.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息

+ (MBProgressHUD *)showLoading
{
    UIView *view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor clearColor];
    hud.backgroundColor = UIColorFromAlphaRGB(0x000000, 0.5);
    UIActivityIndicatorView *superView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    superView.frame = CGRectMake(0, 0, 70, 70);
    superView.color = [UIColor whiteColor];
    [superView startAnimating];
    
    hud.customView = superView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = YES;
    
    return hud;
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    
    if (view == nil) view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window; ;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.3];
}
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view time:(CGFloat)time
{
    if (view == nil) view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:time];
}

+ (void)showMessage:(NSString *)message time:(CGFloat)time
{
    UIView *view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:time];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:nil view:view];
}
+ (void)showError:(NSString *)error toView:(UIView *)view time:(CGFloat)time
{
    [self show:error icon:nil view:view time:time];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view time:(CGFloat)time
{
    [self show:success icon:@"success.png" view:view time:time];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    
    if (view == nil) view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;;
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)showSuccess:(NSString *)success time:(CGFloat)time
{
    [self showSuccess:success toView:nil time:time];
}

+ (void)showError:(NSString *)error time:(CGFloat)time
{
    [self showError:error toView:nil time:time];
}


+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


@end
