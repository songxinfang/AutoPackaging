//
//  MyViewController.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "MyViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"



@interface MyViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic , strong)NSArray * TongJiToolArr;



@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = XYWYColor(50, 52, 72);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"left_menu_background"];
    [self.view addSubview:imageView];

    self.dataSource = @[@[[MyViewData dataWith:@"myview_icon1" title:@"错题复习" pushVC:@"MyMistakenViewController"]],
                        @[[MyViewData dataWith:@"myview_icon2" title:@"练习记录" pushVC:@"MyPracticeViewController"]],
                        @[[MyViewData dataWith:@"myview_icon8" title:@"测验记录" pushVC:@"MyTestViewController"]],
                        @[[MyViewData dataWith:@"myview_icon3" title:@"考试记录" pushVC:@"MyExamViewController"]],
                        @[[MyViewData dataWith:@"myview_icon4" title:@"我的收藏" pushVC:@"MyCollectViewController"]],
                        @[[MyViewData dataWith:@"myview_icon5" title:@"我的分享" pushVC:@"MyShareViewController"]],
                        @[[MyViewData dataWith:@"myview_icon7" title:@"设置" pushVC:@"SettingViewController"]]];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, LEFT_VIEW_WIDTH, SCREEN_HEIGHT)
                                                    style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 80)];
    header.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = header;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, header.height - 1, _tableView.width - 32, 0.5)];
    line.backgroundColor = XYWYColorA(75, 77, 98, 0.7);
    [header addSubview:line];
}

#pragma mark - Table Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

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
    return [_dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyViewCell";
 
    MyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyViewCell" owner:self options:nil] lastObject];
    }
    
    
    NSArray *arr = _dataSource[indexPath.section];
    
    [cell setCellData:arr[indexPath.row]];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    [TongJiTool XYWYClickEvent:self.TongJiToolArr[indexPath.item] attributes:nil ];
    

    
    NSArray *arr = _dataSource[indexPath.section];
    MyViewData *data = arr[indexPath.row];
    
    
    if (data.m_PushVC)
    {
        Class vcClass = NSClassFromString(data.m_PushVC);
        UIViewController *vc = [[vcClass alloc] init];
        vc.title = data.m_Title;
        
   
        
        AppDelegate * appDelegate =  [UIApplication sharedApplication].delegate;
        UINavigationController * navigationController = appDelegate.centerNavigationController;
        [navigationController pushViewController:vc animated:NO];

        [self.mm_drawerController setCenterViewController:navigationController withCloseAnimation:YES completion:^(BOOL finished) {
            
            for (UIViewController * vc in navigationController.childViewControllers) {
                
                NSLog(@"%@" , [vc class]);
            }
            
            
        }];
        

    }
}


-(NSArray *) TongJiToolArr
{
    if (!_TongJiToolArr) {
        
        _TongJiToolArr = @[TongJiToolWrongReview , TongJiToolPracticeRecord ,TongJiToolTestRecord , TongJiToolExamRecord , TongJiToolMyCollection , TongJiToolMyShare , TongJiToolClickSeting];
    }
    
    return _TongJiToolArr;
    

}

@end
