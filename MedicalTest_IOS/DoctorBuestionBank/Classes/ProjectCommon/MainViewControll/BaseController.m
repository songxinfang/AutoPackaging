//
//  BaseController.m
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/4.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import "BaseController.h"
#import "UIBarButtonItem+XYWY.h"
#import "LodingAnimationView.h"
#import "NoDataView.h"

@interface BaseController ()

{
    UIBarButtonItem *_reloadItem;
    UIButton *_reloadBtn;
    BOOL isLoading;
}

// 刷新按钮
@property(nonatomic , strong) NSString * freshNormal;
@property(nonatomic , strong) NSString * freshLoading;

@property(nonatomic , strong) NoDataView *noDataView;


@end

@implementation BaseController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.view.exclusiveTouch = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        self.automaticallyAdjustsScrollViewInsets = NO;

    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    
    //创建loadingView
    LodingAnimationView *loadingView = [LodingAnimationView AnimationView];
    
    loadingView.hidden = YES;
    self.loadingAnimation = loadingView;
    [self.view addSubview:loadingView];
    
    
}


//设置navigation背景图片
- (void)setNavigationBarBackGroundImage
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark --返回按钮--
- (void)setUpNavigationBarLeftBackWithImage:(NSString *) imageName  HighImageName:(NSString *) HighimageName
{
    UIBarButtonItem *leftButtonItem = [UIBarButtonItem itemWithIcon:imageName highIcon:HighimageName  target:self action:@selector(leftbarbuttonAction)];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,leftButtonItem];
}


#pragma mark -- 刷新按钮 --
- (void)setUpNavigationBarRighRefreshWithFreshNormal:(NSString *) freshNormal  FreshLoading:(NSString *) freshLoading
{
    
  
    _freshNormal = freshNormal;
    _freshLoading = freshLoading;
    
    
    _reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reloadBtn.frame = CGRectMake(0, 0, 40, 40);
   
    if([freshNormal isEqualToString:@""]){
        [_reloadBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [_reloadBtn setImage:[UIImage imageNamed:freshNormal ] forState:UIControlStateNormal];
    }
    
  
    [_reloadBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _reloadItem = [[UIBarButtonItem alloc]initWithCustomView:_reloadBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,_reloadItem];
    
    
}



//点击刷新按钮
- (void)rightBtnAction
{
    if (isLoading == YES) {
        return;
    }
    
    isLoading = YES;
    
    [self refreshAnimation];
}



//刷新动画
- (void)refreshAnimation
{
    [_reloadBtn setImage:[UIImage imageNamed:self.freshLoading] forState:UIControlStateNormal];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = 100000;
    [_reloadBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



//停止刷新动画
- (void)stopAnimation
{
    isLoading = NO;
    
    [_reloadBtn.layer removeAllAnimations];
    [_reloadBtn setImage:[UIImage imageNamed:self.freshNormal] forState:UIControlStateNormal];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void)setupNavigationBar:(UINavigationController *)naviController {
    

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void) cleanNavigationBar:(UINavigationController *)naviController
{
    
    [naviController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [naviController.navigationBar setBackgroundColor:[UIColor clearColor]];
    

}


-(void) setUpNavigationBackColourWithColour:(UIColor *)colour navigationVC:(UINavigationController *) naVC
{
    [self cleanNavigationBar:naVC];
    
    
    [self.navigationController.navigationBar setBackgroundColor:colour ];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:colour]forBarMetrics:UIBarMetricsDefault];

    
}

- (void)leftbarbuttonAction
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 无数据提示

- (void)showNoDataWithTip:(NSString *)tip
{
    if (self.noDataView == nil) {
        self.noDataView = [[NoDataView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.noDataView];
    }
    
    [self.view bringSubviewToFront:self.noDataView];
    self.noDataView.noDataLabel.text = tip;
    
    self.noDataView.hidden = NO;
}

- (void)hideNoDataWithTip
{
    if (self.noDataView)
    {
        self.noDataView.hidden = YES;
    }
}

@end
