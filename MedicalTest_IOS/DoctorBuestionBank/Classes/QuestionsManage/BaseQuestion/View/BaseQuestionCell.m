//
//  BaseQuestionCell.m
//  DoctorBuestionBank
//
//  Created by lc on 16/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionCell.h"
#import "AnswerBreakDownCell.h"
#import "OptionsTableViewCell.h"
#import "QuestionsApi.h"
#import "CorrectAnswerSectionView.h"
#import "QuestionTitleView.h"
#import "CorrectAnswerFooterView.h"


@interface BaseQuestionCell ()<CorrectAnswerSectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic , strong) NSMutableArray * tableViewArr;
@property(nonatomic , strong) QuestionTitleView * TitleView;
@property(nonatomic , assign) NSInteger ScrollCount;



@end

@implementation BaseQuestionCell





- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
    

    
}

+(instancetype)QuestionCell
{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void)reloadData
{
    
    [self customReloadData];

}


- (void)setModel:(QuestionInfo *)model
{
    _model = model;
    
    

    // 添加tableView
    
    while (self.tableViewArr.count > model.QuestionArr.count) {
        
        [self.tableViewArr removeLastObject];
    }
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;

    for (NSUInteger i = self.tableViewArr.count ; i < model.QuestionArr.count; i++) {
        
        CGRect frame = CGRectMake(i*w, 0, w, self.frame.size.height);
        UITableView * tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.tag = i;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
        
        [self.tableViewArr addObject:tableView];
        [self.scrollView addSubview:tableView];

    }
    
    [self customReloadData];
    
}

-(void) customReloadData
{

    for (int i = 0; i < self.tableViewArr.count; i++) {
        UITableView * tableView = self.tableViewArr[i];
        [tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    Question * answerModel =self.model.QuestionArr[tableView.tag];

    if (answerModel.isMakeSure){ // 确定后 练习的时候需要显示答案详情
        return 3;
    }
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    Question * answerModel =self.model.QuestionArr[tableView.tag];

    if (section==1)
    {
        
        NSArray * answerArray = [answerModel.AnswerStr componentsSeparatedByString:@"|"];
        if (answerModel.isMakeSure) {
            
            if (!answerModel.isShowDetal) {
                return 0;
            }else{
                return answerArray.count;
            }

        }else{
            return answerArray.count;

        }
    }else if(section == 2)
    {
        if (!answerModel.isShowDetal) {
            return 1;
        }else{
            return 0;
        }
    
    }else{
    
        return 0;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Question * answerModel =self.model.QuestionArr[tableView.tag];
    if (indexPath.section==1){ // 选项
        
        OptionsTableViewCell *cell = [OptionsTableViewCell cellWithTableView:tableView];
        cell.index = tableView.tag;
        cell.indexPath = indexPath;
        cell.model = _model;
        return cell;
        
    }
    else{ // 答案详情
        AnswerBreakDownCell *cell =  [AnswerBreakDownCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.model = answerModel;

        return cell;
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    if (section  == 0) { // 题干
        QuestionTitleView *TitleView = [QuestionTitleView TitleView];
        TitleView.title  = [self questionTitleWithtableView:tableView heightForHeaderInSection:section];

        return TitleView;
        
    }else  if(section == 2){ // 答案详解
        
        CorrectAnswerSectionView * view = [CorrectAnswerSectionView AnswerSectionView];
        view.delegate = self;
        view.tag = tableView.tag;
        Question * answerModel =self.model.QuestionArr[tableView.tag];
        view.isUnfold = answerModel.isShowDetal;
        return view;
        
        
    }else{ // 间距
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
        return view;
        
    
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        Question * answerModel =self.model.QuestionArr[tableView.tag];

        if (answerModel.isMakeSure && !answerModel.isShowDetal) {
            CorrectAnswerFooterView * view = [CorrectAnswerFooterView AnswerFooterView ];
            
            view.SelectStatus = answerModel.User_SelectStatus;
            
            return view;
            
        }
    
    }
   
    
    return nil;

}






-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        
        Question * answerModel =self.model.QuestionArr[tableView.tag];

        QuestionTitleView *TitleView = [QuestionTitleView TitleView];
        

        TitleView.title =[self questionTitleWithtableView:tableView heightForHeaderInSection:section];
        answerModel.titleHeight =TitleView.viewHeight;
        
        return TitleView.viewHeight;
        
    }else if(section == 1){
        
        Question * answerModel =self.model.QuestionArr[tableView.tag];

        if (answerModel.isMakeSure && !answerModel.isShowDetal) {
            return 0;
        }

        return 8;
    
    }else
    {
        return 44;
        
    }

}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        Question * answerModel =self.model.QuestionArr[tableView.tag];
        if (answerModel.isMakeSure && !answerModel.isShowDetal) {
            
            return 50;
        }

    }
//    else if(section == 1){
//        return 0;
//
//    }
    
    return 0;
    
}




-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question * answerModel =self.model.QuestionArr[tableView.tag];
    

    if (indexPath.section==1)
    {
        NSString * cellHeightKey = [NSString stringWithFormat:@"%ld" , indexPath.item];
        
        CGFloat f = [answerModel.cellHeightDic[cellHeightKey] floatValue  ];
        if (f < 5) {
            OptionsTableViewCell *cell = [OptionsTableViewCell cellWithTableView:tableView];
            cell.index = tableView.tag;
            cell.indexPath = indexPath;
            cell.model = _model;
            f =[answerModel.cellHeightDic[cellHeightKey] floatValue  ];
            

        }
        
        return f;
        
        
    }else if(indexPath.section == 2){
    
        NSString * cellHeightKey = [NSString stringWithFormat:@"%ld" , indexPath.item];

        CGFloat f =[answerModel.cellHeightDic[cellHeightKey] floatValue  ];

        if (f < 5) {
            AnswerBreakDownCell *cell =  [AnswerBreakDownCell cellWithTableView:tableView];
            cell.indexPath = indexPath;
            cell.model = answerModel;
            f =[answerModel.cellHeightDic[cellHeightKey] floatValue  ];

            
        }

        
        return  f;
    }
    return 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question * answerModel =self.model.QuestionArr[tableView.tag];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1)
    {
        
        if (answerModel.isMakeSure) { // 已经确定 不能修改了
            return;
        }
        
        NSString * selectStr = [self changeToString:(int)indexPath.row];
        if (answerModel.CorrectSet.count == 1) { // 根据正确答案的个数判断是单选还是多选
            [answerModel.User_SelectSet removeAllObjects];
        }
        
        [answerModel.User_SelectSet addObject:selectStr];
        self.model.needSync = YES;
        [tableView reloadData];
        
        if ([self.delegate respondsToSelector:@selector(BaseQuestionCellDidSelect)]) {
            [self.delegate BaseQuestionCellDidSelect];

        }
        
    }
}





- (NSString *)changeToString:(int )num{
    
    Byte B=(Byte)(0XFF & (num+65));
    
    NSString *newStr = [NSString stringWithFormat:@"%c",B];
    
    return newStr;
}


-(NSMutableArray *) tableViewArr
{
    if (!_tableViewArr) {
        _tableViewArr = [NSMutableArray array];
    }
    
    return _tableViewArr;

}


-(QuestionTitleView *) TitleView
{

    if (!_TitleView) {
        
        _TitleView = [QuestionTitleView TitleView];
    }
    
    return _TitleView;
    
}




-(void) CorrectAnswerSectionView:(CorrectAnswerSectionView *) SectionView DidClickWithTag:(NSInteger) tag
{
    
    
    Question * answerModel =self.model.QuestionArr[tag];
    
    NSString * tongjiStr = nil;
    if (answerModel.isShowDetal) {
        tongjiStr = TongJiToolshowAnswer;
        
    }else{
        tongjiStr = TongJiToolcloseAnswer;

        
    }
    
    [TongJiTool XYWYClickEvent:tongjiStr attributes:nil ];

    answerModel.isShowDetal = !answerModel.isShowDetal;

    [self customReloadData];
    

    return;
    
}


-(NSString * ) questionTitleWithtableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    Question * answerModel =self.model.QuestionArr[tableView.tag];
    
    
    NSString * title = nil;
    if (self.model.QuestionArr.count >1 ) { // 共用题干的显示
        title =[NSString stringWithFormat:@"%ld(%ld)、%@ (%ld分)",      self.model.order ,tableView.tag+1,answerModel.Question ,(long)answerModel.score];
    }else{
        title =[NSString stringWithFormat:@"%ld、%@ (%ld分)",     self.model.order , answerModel.Question ,(long)answerModel.score];
    }
    

    
    return title;
    
    
}




@end
