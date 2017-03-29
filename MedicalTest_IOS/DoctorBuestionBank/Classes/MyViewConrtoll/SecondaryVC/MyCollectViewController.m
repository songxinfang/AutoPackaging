//
//  MyCollectViewController.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyQuestionViewController.h"
#import "MyListViewCell.h"
#import "QuestionsApi.h"
#import "ExaminationViewConrtoller.h"


@interface MyCollectViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MyCollectViewController

static NSString *const identifier = @"testListCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarBackGroundImage];

    [self setUpNavigationBarLeftBackWithImage:@"NavigationNack" HighImageName:nil];

    self.view.backgroundColor = XYWYColor(250, 250, 250);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH)
                                                  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)getDataSource
{
    self.dataSource = [[QuestionsApi share] QuestionsWithType:QuestionShowCollection];
    
    if (self.dataSource.count)
    {
        [self hideNoDataWithTip];
    }
    else
    {
        [self showNoDataWithTip:@"暂无收藏~"];
    }
    
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 用户可能已经取消收藏，刷新
    [self getDataSource];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource.count && _tableView.tableHeaderView == nil)
    {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 8)];
        header.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = header;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header.height - 1, _tableView.width, 0.5)];
        line.backgroundColor = XYWYColor(234, 234, 234);
        [header addSubview:line];
    }
    else if (_dataSource.count == 0 && _tableView.tableHeaderView)
    {
        _tableView.tableHeaderView = nil;
    }

    return _dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyListViewCell";
    
    MyListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyListViewCell" owner:self options:nil] lastObject];
        cell.m_CountLabel.hidden = YES;
    }
    
    QuestionInfo *infoModel = _dataSource[indexPath.row];
    Question * model = infoModel.QuestionArr.firstObject;
    
    [cell.m_TitleLabel setText:model.Question];
    
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
    
     ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:MyPracticeWrongOrRecord];
    vc.loadingAnimate = false;
    
    vc.dataSource = @[self.dataSource];
    vc.scrollToIndexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
