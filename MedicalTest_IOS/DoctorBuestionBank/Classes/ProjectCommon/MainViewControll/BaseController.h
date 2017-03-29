//
//  BaseController.h
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/4.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllocDeallocViewController.h"
#import "LodingAnimationView.h"



@class LodingAnimationView;



typedef void(^RefreshBlock)();

@interface BaseController : AllocDeallocViewController

@property (nonatomic, strong) RefreshBlock refreshBlock;

@property (nonatomic, strong) LodingAnimationView *loadingAnimation;


//设置navigation背景图片
- (void)setNavigationBarBackGroundImage;

//设置navigation左侧返回按钮
- (void)setUpNavigationBarLeftBackWithImage:(NSString *) imageName  HighImageName:(NSString *) HighimageName;


//navigation右侧刷新按钮
- (void)setUpNavigationBarRighRefreshWithFreshNormal:(NSString *) freshNormal  FreshLoading:(NSString *) freshLoading;




//点击刷新按钮
- (void)rightBtnAction;
//刷新按钮停止动画
- (void)stopAnimation;
//刷新按钮启动动画
- (void)refreshAnimation;


// 清除Navigation的设置
-(void) cleanNavigationBar:(UINavigationController *)naviController;



// 设置导航栏背景色
-(void) setUpNavigationBackColourWithColour:(UIColor *)colour navigationVC:(UINavigationController *) naVC;


//设置navigation默认颜色
- (void)setupNavigationBar:(UINavigationController *)naviController;


#pragma mark - 无数据提示

- (void)showNoDataWithTip:(NSString *)tip;

- (void)hideNoDataWithTip;


@end
