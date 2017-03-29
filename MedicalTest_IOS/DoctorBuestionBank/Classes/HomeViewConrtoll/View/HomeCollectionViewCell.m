//
//  HomeCollectionViewCell.m
//  DoctorBuestionBank
//
//  Created by lc on 16/10/10.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "HomeTableViewCell.h"
#import "QuestionModel.h"

@interface HomeCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

-(void) setArr:(NSArray<QuestionTopicModel *> *)arr
{
    _arr = arr;
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTableViewCell * cell = [HomeTableViewCell cellWithTableView:tableView];
    
    QuestionTopicModel * model = self.arr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuestionTopicModel * model = self.arr[indexPath.row];
    model.isSelect = !model.isSelect;

    [_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, SCREEN_WIDTH-100, 22)];
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:12];
    NSString *title = [NSString stringWithFormat:@"章节(共%lu章)",(unsigned long)self.arr.count];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(2,title.length-2)];
    label.attributedText = str;
    [view addSubview:label];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41.5, SCREEN_WIDTH, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0xeaeaea);
    [view addSubview:lineLabel];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(SCREEN_WIDTH-41, 10, 25, 22);
    [btn setTitle:@"全选" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(allChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}
- (void)allChooseBtnClick:(UIButton *)sender
{
   

    for (QuestionTopicModel *model in self.arr)
    {
        model.isSelect = YES;
    }
    [_tableView reloadData];
}


@end
