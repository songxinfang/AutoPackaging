//
//  AboutUsViewController.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AboutUsViewController.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "CustomAlertView.h"

@interface AboutUsViewController ()
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

/**
 *  修改为你自己的appkey。
 *  同时，也需要替换yw_1222.jpg这个安全图片。
 */
static NSString * const kAppKey = @"23513260";


@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarBackGroundImage];
    self.view.backgroundColor = XYWYColor(250, 250, 250);
    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];

    [self buildMainView];
}

- (void)buildMainView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    [self.view addSubview:scrollView];
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 84)/2, 32, 84, 84)];
    logo.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    logo.image = [UIImage imageNamed:icon];
    [logo.layer setMasksToBounds:YES];
    [logo.layer setCornerRadius:10];
    [scrollView addSubview:logo];
   
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame) + 5, SCREEN_WIDTH , 20)];
    version.backgroundColor = [UIColor clearColor];
    version.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    version.font = [UIFont systemFontOfSize:12.0];
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = [UIColor colorWithHex:0x333333];
    [scrollView addSubview:version];


    UIView *view1 = [self addItemWithFrame:CGRectMake(0, CGRectGetMaxY(version.frame) + 30, SCREEN_WIDTH, 43) title:@"喜欢我吗，给好评支持" des:nil];
    [scrollView addSubview:view1];
    [self addLinesToView:view1 withTop:YES];
    [view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentAction:)]];

    UIView *view2 = [self addItemWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame) + 8, SCREEN_WIDTH, 43) title:@"联系我们" des:nil];
    [scrollView addSubview:view2];
    [self addLinesToView:view2 withTop:YES];
    [view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactAction:)]];
    
    UIView *last = [self companyInfoView];
    CGFloat last_off = (scrollView.height - CGRectGetMaxY(view2.frame) - last.height)/2 > 88 ? 88:(scrollView.height - CGRectGetMaxY(view2.frame) - last.height)/2;
    last.y = CGRectGetMaxY(view2.frame) + last_off;
    [scrollView addSubview:last];
}

- (UIView *)addItemWithFrame:(CGRect)frame title:(NSString *)title des:(NSString *)des
{
    UIView *bg = [[UIView alloc] initWithFrame:frame];
    bg.backgroundColor = [UIColor whiteColor];

    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, SCREEN_WIDTH - 20, frame.size.height - 10)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = title;
    titleLable.font = [UIFont systemFontOfSize:12.0];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = [UIColor colorWithHex:0x333333];
    [bg addSubview:titleLable];
    
    if (des)
    {
        UILabel *desLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, frame.size.width - 160 - 16, frame.size.height - 10)];
        desLable.text = des;
        desLable.font = [UIFont systemFontOfSize:12.0];
        desLable.textAlignment = NSTextAlignmentRight;
        desLable.backgroundColor = [UIColor clearColor];
        desLable.textColor = [UIColor colorWithHex:0x999999];
        [bg addSubview:desLable];
    }
    else
    {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 7 - 16, (frame.size.height - 12)/2, 7, 12)];
        arrow.image = [UIImage imageNamed:@"setting_arrow"];
        [bg addSubview:arrow];
    }
    
    return bg;
}

- (UIView *)companyInfoView
{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*3-14)];
    bg.backgroundColor = [UIColor clearColor];

    CGFloat left = (SCREEN_WIDTH - 150)/2;
    for (int i = 0; i < 3; i++)
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 30*i, SCREEN_WIDTH - left, 16)];
        lable.font = [UIFont systemFontOfSize:12.0];
        lable.textAlignment = NSTextAlignmentLeft;
        lable.backgroundColor = [UIColor clearColor];
        lable.textColor = [UIColor colorWithHex:0x999999];
        [bg addSubview:lable];
        
        if (i == 0)
        {
            lable.text = @"闻康集团股份有限公司";
        }
        else if (i == 1)
        {
            lable.text = @"客服电话：400-8591-200";
        }
        else if (i == 2)
        {
            lable.text = @"客服邮箱：xywy_mobile@163.com";
        }
    }
    
    return bg;
}

- (void)addLinesToView:(UIView *)father withTop:(BOOL)top
{
    if (top)
    {
        UIView *topline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, father.width, 0.5)];
        topline.backgroundColor = XYWYColor(234, 234, 234);
        [father addSubview:topline];
    }
    
    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, father.height - 1, father.width, 0.5)];
    bottomline.backgroundColor = XYWYColor(234, 234, 234);
    [father addSubview:bottomline];
}

#pragma mark - action
- (void)contactAction:(id)sender
{
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"设置->关于->反馈"};
    
    __weak typeof(self) weakSelf = self;
    
    [self.feedbackKit setYWFeedbackViewControllerErrorBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
        [CustomAlertView showAlertWithTitle:title];
    }];
    
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBackground"] forBarMetrics:UIBarMetricsDefault];
            
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    }
    return _feedbackKit;
}


- (void)commentAction:(id)sender
{    
    // 跳转应用 评分
    NSString *url = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppStoreUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
