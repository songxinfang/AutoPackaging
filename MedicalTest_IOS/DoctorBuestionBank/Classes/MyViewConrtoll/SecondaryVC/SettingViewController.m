//
//  MySettingViewController.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+HUD.h"
#import "SettingViewCell.h"
#import "AccessAuthority.h"
#import "SDImageCache.h"

#import "CustomAlertView.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

/**
 *  修改为你自己的appkey。
 *  同时，也需要替换yw_1222.jpg这个安全图片。
 */
static NSString * const kAppKey = @"23513260";



@interface SettingViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarBackGroundImage];

    self.view.backgroundColor = XYWYColor(250, 250, 250);
    
    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];
    
    self.dataSource = @[[MyViewData dataWith:@"setting_cache" title:@"清除缓存" action:0],
                    [MyViewData dataWith:@"setting_feedback" title:@"意见反馈" action:1],
                    [MyViewData dataWith:@"setting_agreement" title:@"用户协议" pushVC:@"AgreementViewController"],
                    [MyViewData dataWith:@"setting_about" title:@"关于我们" pushVC:@"AboutUsViewController"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH)
                                                    style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 8)];
    header.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = header;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - 1, _tableView.width, 0.5)];
    line.backgroundColor = XYWYColor(234, 234, 234);
    [header addSubview:line];
}

#pragma mark - Table Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SettingViewCell";
    
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil] lastObject];
        cell.m_DetailLabel.hidden = YES;
    }
    
    [cell setCellData:self.dataSource[indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MyViewData *data = self.dataSource[indexPath.row];
    
    if (data.m_PushVC)
    {
        Class vcClass = NSClassFromString(data.m_PushVC);
        UIViewController *vc = [[vcClass alloc] init];
        vc.title = data.m_Title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (data.m_ActionIndex == 0)
    {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] cleanDisk];

        [CustomAlertView showAlertWithTitle:@"清除缓存成功"];
    }
    else if (data.m_ActionIndex == 1)
    {
        /** 设置App自定义扩展反馈数据 */
        self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                     @"visitPath":@"设置->反馈"};
        
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
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    }
    return _feedbackKit;
}

@end
