//
//  MyPracticeViewController.m
//  DoctorBuestionBank
//
//  Created by  on 2016/10/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyPracticeViewController.h"
#import "MyQuestionViewController.h"
#import "MyListViewCell.h"
#import "QuestionsApi.h"
#import "ExaminationViewConrtoller.h"
#import "QuestionDataHandleTool.h"
#import "QuestionResultVC.h"


@interface MyPracticeViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MyPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarBackGroundImage];
    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];

    self.view.backgroundColor = XYWYColor(250, 250, 250);
    
    [self getDataSource];
    
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

- (void)getDataSource
{
    self.dataSource = [[QuestionsApi share] MyPracticeRecord];
    
    if (self.dataSource.count)
    {
        [self hideNoDataWithTip];
    }
    else
    {
        [self showNoDataWithTip:[NSString stringWithFormat:@"暂无%@~",self.title]];
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyListViewCell";
    
    MyListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyListViewCell" owner:self options:nil] lastObject];
        cell.m_IconImageView.hidden = YES;
    }
    
    QuestionLevelModel *model = _dataSource[indexPath.row];
    [cell.m_TitleLabel setText:model.LevelName];
    cell.m_CountLabel.text = [NSString stringWithFormat: @"%ld", model.CompleteCount];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QuestionLevelModel *model = _dataSource[indexPath.row];
    NSArray * arr = [[QuestionsApi share]QuestionsCompleteWithLevelId:model.LevelId ];

    // 全部练习过，进入练习完成页面
    if (model.CompleteCount == model.AllCount)
    {
        QuestionResultVC * vc = [[QuestionResultVC alloc] initWithType:QuestionResultPractice];
        vc.dataSource = [QuestionDataHandleTool separateTopic:arr];
        [self.navigationController  pushViewController:vc animated:YES];
    }
    else
    {
        ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:MyPracticeWrongOrRecord];
        vc.loadingAnimate = false;
        vc.dataSource = [QuestionDataHandleTool separateTopic:arr];
        vc.currentIndex = indexPath;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
