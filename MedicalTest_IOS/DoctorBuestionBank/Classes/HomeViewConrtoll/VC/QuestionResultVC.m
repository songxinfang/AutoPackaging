//
//  QuestionResultVC.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionResultVC.h"
#import "QuestionNavigationBar.h"
#import "PracticeResults.h"
#import "ExaminationResults.h"
#import "MyMistakenViewController.h"
#import "AppDelegate.h"
#import "ReviewQuestionsVC.h"
#import "ResultsModel.h"
#import "PracticeVC.h"
#import "QuestionSingletonTool.h"






@interface QuestionResultVC ()<QuestionNavigationBarDelegate , ExaminationResultsDelegate , PracticeResultsDelegate>

@property(nonatomic , weak) QuestionNavigationBar * customNavigationBar;
@property(nonatomic , weak) PracticeResults * PracticeResultsView;
@property(nonatomic , weak) ExaminationResults * ExaminationResultsView;

@property(nonatomic , assign) QuestionResultType type;

@property(nonatomic , strong) ResultsModel * rModel;







@end




@implementation QuestionResultVC


-(instancetype) initWithType: (QuestionResultType ) type
{
    self = [super init];
    self.type =type;
    return self;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // 来到这个页面就表明练习或者考试已经完成
    QuestionSingletonTool * tool = [QuestionSingletonTool SingletonTool];
    [tool Complete];
    
    
    
    
    [self setUpNav];
    
    
    if (self.type == QuestionResultPractice) {
        
        self.ExaminationResultsView.frame =CGRectMake(0 ,NAVIGATION_HEIGH,SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_HEIGH);
        self.ExaminationResultsView.model = self.rModel;
    }else{
        self.PracticeResultsView.frame = CGRectMake(0 ,NAVIGATION_HEIGH,SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_HEIGH);
        
        self.PracticeResultsView.model = self.rModel;
        

    }
    
    
}



- (void)setUpNav
{
    
    QuestionNavigationBar * view =  [QuestionNavigationBar NavigationBar];
    view.delegate = self;
    view.isHiddenBack = YES;
    view.isHiddenCollection = YES;
    view.isHiddenTitleImage = YES;
    
    if (self.type == QuestionResultPractice) {
        view.title = @"考试成绩";

    }else if(self.type == QuestionResultExamination){
        view.title = @"练习结果";

    }
    
    
    view.frame = CGRectMake(0, 0,SCREEN_WIDTH , NAVIGATION_HEIGH);
    [self.view addSubview:view];
    self.customNavigationBar = view;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


-(PracticeResults * )PracticeResultsView
{

    if (!_PracticeResultsView) {
        PracticeResults * view = [PracticeResults Results];
    
        view.delegate = self;
        
        [self.view addSubview:view];
        _PracticeResultsView = view;
        
    }
    
    return _PracticeResultsView;
    

}

-(ExaminationResults *)ExaminationResultsView
{
    if (!_ExaminationResultsView) {
        ExaminationResults * view = [ExaminationResults ResultsView];
        [self.view addSubview:view];
        view.delegate = self;
        
        _ExaminationResultsView = view;
    }
    
    return _ExaminationResultsView;
}

-(void) ExaminationResults:(ExaminationResults *) view didClickType:(ExaminationResultsDidClickType )type
{
    if (type == ExaminationResultseGoToHome) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(type == ExaminationResultseGoToWrong){
    
        ReviewQuestionsVC * vc =  [[ReviewQuestionsVC alloc] init];
        
        vc.dataSource = self.dataSource;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    
    }

}

-(void) PracticeResults:(PracticeResults *) view didClickType:(PracticeResultsDidClickType )type
{

    if (type == PracticeResultsGoToHome) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else if(type == PracticeResultsGoToWrong){
        
        
        NSInteger errCount = 0;
        
        NSMutableArray * mArr = [NSMutableArray array];
        
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
            
            PracticeVC * vc = [[PracticeVC alloc]initWithType:ExaminationWrongReview];
            
            vc.dataSource = [mArr copy];
            
            
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [MBProgressHUD showSuccess:@"没有错题"];
            
            
        }
        
 
    }

}

-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{

    _dataSource = dataSource;
    
    for (NSArray * arr in dataSource) {
        
        for (QuestionInfo * infoModel in arr) {
            
            BOOL isAdd = true;
            
            for (Question * model in infoModel.QuestionArr) {
                
                
                if (model.User_SelectStatus != UserSelectCorrect) {
                    isAdd = false;
                    break;
                }
                
            }
            
            self.rModel.TotalNum++;
            if (isAdd) {
                self.rModel.OverNum++;
                
                if (self.type == QuestionResultPractice) {
                    self.rModel.Scores = infoModel.QuestionArr.count + self.rModel.Scores;
                }
                
            }
            
            
        }
        
    }
    
    
    if (self.type ==QuestionResultPractice ) {
        self.rModel.Rank = arc4random()%20 + 1;
    }
    
    
    


}



-(ResultsModel *)rModel
{

    if (!_rModel) {
        _rModel = [[ResultsModel alloc] init];
    }
    
    return _rModel;
    

}


@end
