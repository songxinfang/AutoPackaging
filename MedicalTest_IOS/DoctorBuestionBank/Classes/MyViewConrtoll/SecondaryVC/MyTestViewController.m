//
//  MyTestViewController.m
//  DoctorBuestionBank
//
//  Created by  on 2016/11/15.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyTestViewController.h"
#import "BaseQuestionViewController.h"
#import "MyExamViewCell.h"
#import "QuestionsApi.h"
#import "QuestionResultVC.h"
#import "CustomAlertView.h"
#import "NSDate+Category.h"

@interface MyTestViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
// 7天内、7天前
@property (nonatomic, strong) NSArray *dataSource;

@end


static NSString *const identifier = @"examListCell";


@implementation MyTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarBackGroundImage];
    
    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];
        
    [self analyzeData];
    
    [self setRightNavButton];
    
    self.view.backgroundColor = XYWYColor(250, 250, 250);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH)
                                                  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)analyzeData
{
    self.dataSource = nil;
    NSArray *data = [[QuestionsApi share] existingPracticeExaminationProperty];
    
    if (data.count)
    {
        [self hideNoDataWithTip];
    }
    else
    {
        [self showNoDataWithTip:[NSString stringWithFormat:@"暂无%@~",self.title]];
        return;
    }

    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    self.dataSource = @[arr1,arr2];
    
    for (ExaminationProperty *property in data)
    {
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:property.createTime];
        if (tempDate.isToday)
        {
            [arr1 insertObject:property atIndex:0];
        }
        else
        {
            [arr2 insertObject:property atIndex:0];
        }
    }
}

- (void) setRightNavButton
{
    for (NSArray *arr in _dataSource)
    {
        if (arr.count)
        {
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, UI_NAVIGATION_BAR_HEIGHT)];
            [rightBtn setImage:[UIImage imageNamed:@"exam_cleanBtn"] forState:UIControlStateNormal];
            [rightBtn setTitle:@" 清除 " forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            rightBtn.exclusiveTouch = YES;
            [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchDown];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            
            return;
        }
    }
    
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)rightAction:(id)sender
{
    [CustomAlertView showAlertWithTitle:@"测验记录清除后无法恢复，确认是否要清除？"
                                message:nil
                            cancelTitle:@"取消"
                             otherTitle:@"删除" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                 if (!cancelled) {
                                     // 1 从数据库清除
                                     [[QuestionsApi share] clearPracticeExaminationRecord];
                                     
                                     // 1+、清除记录
                                     [self analyzeData];
                                     
                                     // 2、刷新table
                                     [_tableView reloadData];
                                     
                                     // 3、按钮消失
                                     [self setRightNavButton];
                                 }
                             }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataSource[section];
    return arr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyExamViewCell";
    
    MyExamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyExamViewCell" owner:self options:nil] lastObject];
        
        cell.m_ScoreIcon.x = cell.m_RankIcon.x + 15;
        cell.m_ScoreLabel.x = cell.m_RankLabel.x + 15;
        
        cell.m_RankIcon.hidden = YES;
        cell.m_RankLabel.hidden = YES;
    }
    
    NSArray *arr = _dataSource[indexPath.section];
    ExaminationProperty *property = arr[indexPath.row];
    cell.m_TitleLabel.text = [property getSimplePaperName];
    cell.m_TimeLabel.text = [property getTimeString];
    
    [cell.m_ScoreLabel setAttributedText:[self attributedWithStr:[NSString stringWithFormat:@"%ld",property.Person_score]
                                                            right:@"分"]];

    if (indexPath.section == 0)
    {
        cell.m_TitleLabel.x = 60;
    }
    else
    {
        cell.m_TitleLabel.x = 100;
    }
    
    cell.m_TitleLabel.width = SCREEN_WIDTH - 80 - cell.m_TitleLabel.x;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 38)];
    header.backgroundColor = XYWYColor(250, 250, 250);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - 0.5, _tableView.width, 0.5)];
    line.backgroundColor = XYWYColor(234, 234, 234);
    [header addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH - 32 , 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor colorWithHex:0x333333];
    [header addSubview:label];
    
    [label setText:(section == 0? @"当前":@"更早")];
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = _dataSource[indexPath.section];
    ExaminationProperty *model = arr[indexPath.row];
    QuestionResultVC * vc = [[QuestionResultVC alloc] initWithType:QuestionResultExamination];
    vc.paperModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableAttributedString *)attributedWithStr:(NSString *)str right:(NSString *)rightStr
{
    NSString *content = [NSString stringWithFormat:@"%@%@",str,rightStr];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:content];
    if (rightStr.length) {
        NSRange rightRange = [content rangeOfString:rightStr];
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:8.0]
                                 range:rightRange];
    }
    
    return attributedString;
}


@end
