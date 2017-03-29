//
//  HomeContentViewCell.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeContentViewCell.h"
#import "HomeTableViewCell.h"
#import "HomeContentHeaderView.h"
#import "QuestionSingletonTool.h"





@interface HomeContentViewCell ()<UITableViewDelegate , UITableViewDataSource , HomeContentHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic , strong) HomeContentHeaderView* HeaderView;


//@property(nonatomic , assign) BOOL isSelectAll;





@end

@implementation HomeContentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
}




-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QuestionTopicModel * model = self.modelArr[indexPath.item];
    HomeTableViewCell * cell = [HomeTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;

}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HomeContentHeaderView * view = [HomeContentHeaderView ContentHeaderView];
    view.ChapterNum = self.ChapterNum;
    BOOL status =   [[QuestionSingletonTool SingletonTool] isSelectAllWithOrder:self.ChapterNum];

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"ChapterNum"] = [NSString stringWithFormat:@"%ld" , self.ChapterNum    ];
    
    NSString * tongjiStr = nil;
    if (status) {
        view.title = @"取消";
        tongjiStr = TongJiToolCancelChooseAll;
        
    }else{
        view.title = @"全选";
        tongjiStr = TongJiToolChooseAll;


    }
    
    [TongJiTool XYWYClickEvent:tongjiStr attributes:dic ];

    view.delegate = self;
    
    
    
    return view;

}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 42;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    QuestionTopicModel * model = self.modelArr[indexPath.item];
    model.isSelect = !model.isSelect;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}


-(void) didClickSelectAllBtn
{
    
    BOOL status =   [[QuestionSingletonTool SingletonTool] isSelectAllWithOrder:self.ChapterNum];
    status = !status;
    [[QuestionSingletonTool SingletonTool] setSelectAllWithOrder:self.ChapterNum withStatus:status];

    
    
    for (QuestionTopicModel * model in self.modelArr) {
        
        model.isSelect = status;

    }
    
    
    [self.tableView reloadData];

    
    
    
}



-(void) setModelArr:(NSArray<QuestionTopicModel *> *)modelArr
{
    _modelArr = modelArr;
    
    [self.tableView reloadData];

}


@end
