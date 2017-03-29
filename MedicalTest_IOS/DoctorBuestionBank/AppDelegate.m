//
//  AppDelegate.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/9.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "MyViewController.h"
#import "BaseNavigationController.h"
#import <MMDrawerController.h>
#import "QuestionSingletonTool.h"
#import "HomeTipView.h"
#import "UserInfo.h"
#import <UMSocialCore/UMSocialCore.h>

#import "UMMobClick/MobClick.h"

#import "BaiduMobAdSDK/BaiduMobAdSplash.h"


//  友盟分享appkey
#define UMKey @"57e8f2a1e0f55aaeec001fc7"
#define IOKey @"0d3dad1b11014998bff40f37a48c8490"
#define UMUrl @"http://www.umeng.com/social"
//  友盟统计appKey
#define UMAnailyticsKey @"5812fc397666135fcd0000a7"

// 微信分享
#define WX_BASE_URL @"http://mobile.umeng.com/social"
#define IDForWX @"wx4da222ce6ffc1a85"
#define WXSecret @"f0f3cc778b8ad64df9047887c00a1527"

// QQ/Qzone/新浪微博分享
#define IDForQQ     @"100424468"
#define IDForWeibo  @"3921700954"
#define SecretForWeibo @"04b48b094faeb16683c32669824ebdad"
#define URLWeiboUserInfo @"https://api.weibo.com/2/users/show.json"
#define RedirectWeibo @"http://sns.whalecloud.com/sina2/callback"




@interface AppDelegate ()<BaiduMobAdSplashDelegate>

@property (nonatomic, strong) BaiduMobAdSplash *splash;
@property (nonatomic, retain) UIView *customSplashView;

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    //  友盟社交分享初始化
    [self setupUMShare];
    //  友盟统计初始化
    [self setupUMAnalytics];
    //  初始化统计相关，包括友盟统计和寻医问药统计
    [TongJiTool initTongJi];
    
    // 本地数据库处理
     [self copyDatabaseIfNeeded];
    
    
    [self setupDrawer];
    
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
  
    self.window.rootViewController = self.drawerController;

    [self.window makeKeyAndVisible];

    if (0/*播放广告*/)
    {
        //  添加百度开屏广告
        // [self addBaiduMobads];
        
        // 广告播放结束之后展示新手引导图
    }
    else
    {
        // 直接显示新手引导图
        if (![UserInfo getGuideStatus]) {
            [HomeTipView showTipViewWithIconFrame:CGRectMake(SCREEN_WIDTH - 60, 5, 60, 39)];
            [UserInfo setFirstGuideStatus:YES];
        }
    }
    
    return YES;
}


#pragma mark - 百度广告相关
//  百度app开屏广告（启动时弹出）
- (void)addBaiduMobads {
    //    自定义开屏
    //
    BaiduMobAdSplash *splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.AdUnitTag = BaiduMobAdsID;
    splash.canSplashClick = YES;
    self.splash = splash;
    
    //可以在customSplashView上显示包含icon的自定义开屏
    self.customSplashView = [[UIView alloc]initWithFrame:self.window.frame];
    self.customSplashView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.customSplashView];
    
    CGFloat screenWidth = self.window.frame.size.width;
    CGFloat screenHeight = self.window.frame.size.height;
    
    //在baiduSplashContainer用做上展现百度广告的容器，注意尺寸必须大于200*200，并且baiduSplashContainer需要全部在window内，同时开机画面不建议旋转
    UIView * baiduSplashContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.customSplashView addSubview:baiduSplashContainer];
    
    /*
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight - 40, screenWidth, 20)];
    label.text = @"上方为开屏广告位";
    label.textAlignment = NSTextAlignmentCenter;
    [self.customSplashView addSubview:label];
     */
    //
    //在的baiduSplashContainer里展现百度广告
    [splash loadAndDisplayUsingContainerView:baiduSplashContainer];
}

- (NSString *)publisherId {
    return BaiduMobAdsAPPID;
}

- (void)splashDidClicked:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidClicked");
}

- (void)splashDidDismissLp:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissLp");
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashDidDismissScreen");
    [self removeSplash];
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash {
    NSLog(@"splashSuccessPresentScreen");
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason)reason {
    NSLog(@"splashlFailPresentScreen withError %d", reason);
    [self removeSplash];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash {
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.customSplashView removeFromSuperview];
    }
    
    if (![UserInfo getGuideStatus]) {
        [HomeTipView showTipViewWithIconFrame:CGRectMake(SCREEN_WIDTH - 60, 5, 60, 39)];
        [UserInfo setFirstGuideStatus:YES];
    }
}


#pragma mark - 友盟统计相关
//  设置友盟统计
- (void)setupUMAnalytics {
    UMConfigInstance.appKey = UMAnailyticsKey;
    UMConfigInstance.channelId = @"App Store";

    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //  版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

-(void) setupDrawer
{
    UIViewController * leftSideDrawerViewController = [[MyViewController alloc] init];
    
    UIViewController * centerViewController = [[HomeViewController alloc] init];
    

    UINavigationController * centerNavigationController = [[BaseNavigationController alloc] initWithRootViewController:centerViewController];
    
    self.centerNavigationController = centerNavigationController;
    
    [centerNavigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
  
    UINavigationController * leftSideNavController = [[BaseNavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
    [leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:centerNavigationController
                             leftDrawerViewController:leftSideDrawerViewController
                             rightDrawerViewController:nil];
    
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    
    
    CGFloat f = LEFT_VIEW_WIDTH;
    
    [self.drawerController setMaximumRightDrawerWidth:f];
    [self.drawerController setMaximumLeftDrawerWidth:f];
    
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
//    [self.drawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController, drawerSide, percentVisible);
//         }
//     }];


}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
 
    QuestionSingletonTool * tool = [QuestionSingletonTool SingletonTool];
    [tool syncData];
    
    
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 友盟社交分享配置初始化
- (void)setupUMShare {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:IDForWX appSecret:WXSecret redirectURL:UMUrl];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:IDForQQ  appSecret:nil redirectURL:UMUrl];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:IDForWeibo appSecret:SecretForWeibo redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        
//    }
//    return result;
//}



/**
 *  数据库文件处理
 */

- (void)copyDatabaseIfNeeded {
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [documentsPath stringByAppendingPathComponent:@"bmp.db"];
    NSLog(@"%@" , destinationPath);
    
    
    NSString * sqlVersion =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SqlVersion"];
    static NSString * SqlVersionNSUserDefaultsKey = @"SqlVersionNSUserDefaultsKey";
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    
    
    BOOL isNeedCopyFile = false;
    
    
    if( ![fm fileExistsAtPath:destinationPath] ) {
        
        isNeedCopyFile = true;
        
    }else
    {
        NSString * oldSqlVersion = [useD objectForKey:SqlVersionNSUserDefaultsKey];
        if (![oldSqlVersion isEqualToString:sqlVersion]) {// 数据库升级 (目前只是移除)
            
            NSError *Error = nil;
            
            if( [fm removeItemAtPath:destinationPath error:&Error]){
                isNeedCopyFile = true;
                
            }else{
                NSLog(@"%@" , Error);
                
            }
            
            
        }
        
    }
    
    if (isNeedCopyFile) {
        
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"bpm" ofType:@"db"];
        NSLog(@"%@" , sourcePath);
        
        NSAssert1(sourcePath, @"source db does not exist at path %@",sourcePath);
        
        NSError *copyError = nil;
        if( ![fm copyItemAtPath:sourcePath toPath:destinationPath error:&copyError] ) {
            NSLog(@"11111");
            
        }else{
            [useD setObject:sqlVersion forKey:SqlVersionNSUserDefaultsKey];
            [useD synchronize];
            
        }
    }
}



@end
