//
//  MyMistakenViewController.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyMistakenViewController.h"
#import "MyQuestionViewController.h"
#import "MyMistakenCell.h"
#import "QuestionsApi.h"
#import "ExaminationViewConrtoller.h"
#import "QuestionDataHandleTool.h"



@interface MyMistakenViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) NSArray *dataSource;

@end


@implementation MyMistakenViewController


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
    
    [self setHeaderView];
    [self setFooterView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 用户可能已经答题正确，刷新
    [self analyzeData];
}

- (void)analyzeData
{
    int subCount = 0;
    NSMutableArray *mutableArr = [NSMutableArray array];
    NSDictionary *dic = [[QuestionsApi share] MyWrongQuestion];
    
    NSArray *keys = [dic allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        QuestionLevelModel *levelModel1 = obj1;
        QuestionLevelModel *levelModel2 = obj2;

        NSComparisonResult result = [[NSNumber numberWithInteger:levelModel1.order] compare:[NSNumber numberWithInteger:levelModel2.order]];
        
        return result == NSOrderedDescending; // 升序
    }];

    for (QuestionLevelModel *levelModel in sortedKeys)
    {
        int count = 0;
        NSArray *arr = [dic objectForKey:levelModel];
        for (QuestionTopicModel *topicModel in arr)
        {
            count += topicModel.CompleteCount;
        }
        
        if (count )
        {
            levelModel.CompleteCount = count;
            [mutableArr addObject:levelModel];
            
            subCount += count;
        }
    }
    
    self.dataSource = [NSArray arrayWithArray:mutableArr];
    
    
    [_tableView reloadData];
    
    self.footerView.hidden = subCount>0? NO:YES;
    self.tableView.hidden = subCount>0? NO:YES;
    
    if (subCount)
    {
        [self hideNoDataWithTip];
    }
    else
    {
        [self showNoDataWithTip:@"暂无错题~"];
        return;
    }

    
    NSString *leftStr = @"共有错题 ";
    NSString *rightStr = [NSString stringWithFormat:@"%d",subCount];
    NSString *content = [NSString stringWithFormat:@"%@%@",leftStr,rightStr];
    NSRange range = [content rangeOfString:rightStr];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithHex:0x6F80C8]
                             range:range];
    [self.headerLabel setAttributedText:attributedString];
}

- (void)setHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 50+24+30)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, header.width , 24)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [header addSubview:titleLabel];
    self.headerLabel = titleLabel;
    
    _tableView.tableHeaderView = header;
}

- (void)setFooterView
{
    UIImageView *foot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16*2+44)];
    foot.userInteractionEnabled = YES;
    foot.image = [UIImage imageNamed:@"navBackground"];
    foot.y = SCREEN_HEIGHT - NAVIGATION_HEIGH - foot.height;
    [self.view addSubview:foot];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 44)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"开始练习" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:[UIColor colorWithHex:0xF6B241] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startPractice) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:5.0];
    [foot addSubview:btn];
    
    self.footerView = foot;
    
    self.tableView.height -= foot.height;
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
    static NSString *cellIdentifier = @"MyMistakenCell";
    
    MyMistakenCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMistakenCell" owner:self options:nil] lastObject];
    }
    
    QuestionLevelModel *levelModel = self.dataSource[indexPath.row];
    cell.m_NameLable.text = levelModel.LevelName;
    cell.m_CountLable.text = [NSString stringWithFormat:@"%d",(int)levelModel.CompleteCount];
    
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
    return 30;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger index = 0;
    for (int i = 0; i<indexPath.row; i++)
    {
        QuestionLevelModel *levelModel = self.dataSource[i];
        index += levelModel.CompleteCount;
    }
    
    [self startPracticeWithIndex:index];
}

- (void)startPractice
{
    [self startPracticeWithIndex:0];

}

- (void)startPracticeWithIndex:(NSInteger)index
{
    ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:MyPracticeWrongOrRecord];
    NSArray * arr =[[QuestionsApi share] QuestionsWithType:QuestionShowWrong];
    
    vc.dataSource = [QuestionDataHandleTool separateTopic:arr];
    vc.loadingAnimate = false;
    vc.scrollToIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
