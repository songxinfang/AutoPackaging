//
//  ReviewQuestionsVC.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ReviewQuestionsVC.h"
#import "QuestionNavigationBar.h"
#import "AnswerSheetView.h"
#import "BaseQuestionFootMakeSureView.h"
#import "ExaminationViewConrtoller.h"
#import "QuestionDataHandleTool.h"






@interface ReviewQuestionsVC () <QuestionNavigationBarDelegate , AnswerSheetViewDelegate , BaseQuestionFootMakeSureViewDelegate>

@property(nonatomic , weak) QuestionNavigationBar * customNavigationBar;

@property(nonatomic , weak) AnswerSheetView * SheetView;

@property(nonatomic , strong) BaseQuestionFootMakeSureView * FootMakeSureView;

@property (nonatomic,strong)NSArray < NSArray <QuestionInfo *> *> * DataArr;








@end

@implementation ReviewQuestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
    [self setupSheetView];
    [self.view addSubview:self.FootMakeSureView];
    
    [self.view bringSubviewToFront:self.FootMakeSureView];

    
    
}


- (void)setUpNav
{
    
    QuestionNavigationBar * view =  [QuestionNavigationBar NavigationBar];
    view.delegate = self;
    view.isHiddenCollection = YES;
    view.isHiddenTitleImage = YES;
    view.isHiddenShare = YES;
    view.title = @"考题回顾";
    
    
    view.frame = CGRectMake(0, 0,SCREEN_WIDTH , NAVIGATION_HEIGH);
    [self.view addSubview:view];
    self.customNavigationBar = view;
    
}

-(void)setupSheetView
{
    
    AnswerSheetView * view = [[AnswerSheetView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH  , SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_HEIGH - FootViewHeight)];
    
    view.dataSource = self.dataSource;
    view.isShowSectionHeader = false;
    view.SheetViewDelegate = self;
    view.isExamination  = YES;
    view.questionType = QuestionResultExamination;
    
    [self.view addSubview:view];
    self.SheetView = view;


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


-(void) AnswerSheetView:(AnswerSheetView *) view  isSection:(BOOL) isSection   IndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray * mArr = [NSMutableArray array   ];
    
    
    for (NSArray * arr in self.DataArr) {
        
        NSMutableArray * infoArr =[NSMutableArray array];

        for (QuestionInfo * infoModel in arr) {
            
            for (Question *  model in infoModel.QuestionArr) {
                
                if (model.User_SelectSet.count > 0) {
                    
                    model.isMakeSure = YES;
                    model.isShowDetal = false;
                }
            }
            [infoArr addObject:infoModel];
        }
        [mArr addObject:infoArr];
       
    }
    
    ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc]initWithType:ExaminationWrongReview];
    
    vc.dataSource = [mArr copy];
    vc.scrollToIndexPath = indexPath;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    

}

-(void) QuestionNavigationBar:(QuestionNavigationBar *) view ClickType:(QuestionNavigationBarClickType) type
{
    if (type == QuestionNavigationBarClickBack) {
        
        [self.navigationController popViewControllerAnimated:TRUE];
    }

}

-(BaseQuestionFootMakeSureView *)FootMakeSureView
{
    if (!_FootMakeSureView) {
        _FootMakeSureView = [BaseQuestionFootMakeSureView FootMakeSureView    ];
        
        
        _FootMakeSureView.frame  =CGRectMake(0, SCREEN_HEIGHT - FootViewHeight  , SCREEN_WIDTH, FootViewHeight);
        
        _FootMakeSureView.title = @"错题练习";
        _FootMakeSureView.userInteractionEnabled = YES;

        _FootMakeSureView.delegate = self;
        _FootMakeSureView.HiddenPoint = YES;
        
    }
    
    return _FootMakeSureView;
    
    
    
}

#pragma mark 错题练习
-(void)BaseQuestionFootMakeSureViewDidSelect
{
    
    NSInteger errCount = 0;
    
    NSMutableArray * mArr = [NSMutableArray array];
    
    [QuestionDataHandleTool changeQuestionStatusWithData:self.dataSource];
    


    for (NSArray * arr in self.dataSource) {
        
        NSMutableArray * infoArr = [NSMutableArray array];
        
        
        for (QuestionInfo * model in arr) {
           
            BOOL isRight = true;
            for (Question * q in model.QuestionArr) {
                
                if (q.User_SelectStatus != UserSelectCorrect ) {
                    
                    isRight = false;
                    errCount++;
                    
                    break;
                    
                }
            }
            
            if ((!isRight)) { // 回答错误的
                QuestionInfo * newModel = [model copy];
                
                for (Question * q in newModel.QuestionArr) {
                    [q.User_SelectSet removeAllObjects];
                    q.isMakeSure = false;
                    q.User_SelectStatus = UserNoneSelect;
                }

                
                [infoArr addObject:newModel];
                
            }
        }
        
        [mArr addObject:infoArr];

    }
    
    if(errCount > 0){
    
        ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc]initWithType:ExaminationWrongReview];
        
        vc.dataSource = [mArr copy];
        
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        [MBProgressHUD showSuccess:@"没有错题"];

    
    }
    
   

    
    
    
    
}




-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{

    _dataSource = dataSource;
    
    
    NSMutableArray * mArr = [NSMutableArray array   ];
    
    
    for (NSArray * arr in dataSource) {
        
        NSMutableArray * infoArr = [NSMutableArray array];
        
        for (QuestionInfo * infoModel in arr) {
            
            NSLog(@"%@" , [infoModel class]);
            
            
            QuestionInfo * newModel = [infoModel copy];
            
            [infoArr addObject:newModel];
            
        }
        
        [mArr addObject:infoArr];
        
    }
    
    
    self.DataArr = [mArr copy];
    
    

}



@end
