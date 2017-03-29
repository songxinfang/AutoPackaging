        //
//  ExaminationViewConrtoller.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ExaminationViewConrtoller.h"
#import "QuestionModel.h"
#import "QuestionsApi.h"

#import "LodingAnimationView.h"
#import "BaseQuestionFootSelectView.h"
#import "BaseQuestionFootMakeSureView.h"
#import "QuestionResultVC.h"
#import "QuestionDataHandleTool.h"
#import "QuestionSingletonTool.h"






@interface ExaminationViewConrtoller () <UIGestureRecognizerDelegate    , BaseQuestionFootMakeSureViewDelegate  , BaseQuestionFootSelectViewDelegate>

@property(nonatomic , strong ) BaseQuestionFootSelectView* FootSelectView;
@property(nonatomic , strong) BaseQuestionFootMakeSureView * FootMakeSureView;
@property(nonatomic , weak) Question * currModel;
@property(nonatomic , assign) CollectionViewStatus  CollectionStatus;
@property(nonatomic , assign) QuestionResultType questionType;
@property(nonatomic , strong) NSIndexPath * indexPath;
@property(nonatomic , assign) NSInteger order;

@property(nonatomic , strong) NSNotificationCenter * NotificationCenter;





@end

@implementation ExaminationViewConrtoller


-(instancetype) initWithType:(QuestionResultType ) type
{
    self = [super initWithType:type];
    self.questionType = type;
    
    self.loadingAnimate = true;
   
    return self;
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    
    if ((self.questionType == QuestionResultPractice ) && (self.loadingAnimate == true)) {
        
       
        NSMutableArray * questionArr = [NSMutableArray array ];
       
        QuestionTopicModel * model = self.modelArr.firstObject;
        CGFloat duTime = 1.0 + (arc4random()%10)/10.0;


        dispatch_queue_t queue = dispatch_queue_create("ddddddd", NULL);
      //  duTime = 3.0;

    
        dispatch_async(queue, ^{
            
            if (model.TopicType > 0) {
                
                NSArray * arr = [[QuestionsApi share] QuestionsAllWithTomidArr:self.modelArr];
                NSArray * sepArr=   [QuestionDataHandleTool separateTopic:arr];
                [questionArr addObjectsFromArray:sepArr];
                
                
                
            }else{
                
                
                for (QuestionTopicModel * model in self.modelArr) {
                    
                    NSArray * arr  = [[QuestionsApi share] QuestionsFromTopic:model.TopicId type:QuestionShowAll];
                    NSArray * sepArr=   [QuestionDataHandleTool separateTopic:arr];
                    
                    for (NSArray * sArr in sepArr) {
                        NSLog(@"11111111");
                        
                        [questionArr addObject:sArr];
                        
                    }
                    
                    
                }
            }
            
            NSLog(@"33333333");
            
            


            
            
        });
        
        
        
        self.loadingAnimation.allTimer = duTime;
        
        [self.loadingAnimation start];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.loadingAnimation stop];
            self.dataSource = questionArr;

            [self setupFootView];
        });

        
    }else {
    
        [self setupFootView];
        
    }
    
   
}


-(void)setupFootView
{
    
    [self.view addSubview:self.FootSelectView];
    self.FootSelectView.hidden = YES;
    [self.view addSubview:self.FootMakeSureView];
    
    
}


#pragma mark  代理方法

/**
 * 题型介绍的代理方法
 *
 */

-(void) BaseQuestionView :(BaseQuestionView *) view  numberOfItemsInData:(NSIndexPath * ) indexPath CollectionStatus:(CollectionViewStatus) status selectOrder:(NSInteger) order  ;

{
    
    self.order = order;
    
    
    
    self.CollectionStatus = status;
    self.indexPath = indexPath;
    
    if (status==CollectionViewHeader) {
        
        self.FootSelectView.hidden = YES;
        _FootMakeSureView.hidden = NO;
        _FootMakeSureView.title = @"开始";
        _FootMakeSureView.HiddenPoint = YES;
        _FootMakeSureView.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItems = nil;
        
        [super BaseQuestionView:view numberOfItemsInData:indexPath CollectionStatus:status selectOrder:order];

        return;
        
    }else if(status == CollectionViewFooter){
        self.FootSelectView.hidden = YES;
        _FootMakeSureView.hidden = NO;
        _FootMakeSureView.HiddenPoint = YES;

        _FootMakeSureView.title = @"完成";
        self.FootMakeSureView.userInteractionEnabled = YES;


    }else if(status == CollectionViewNone){
        _FootMakeSureView.title = @"确定";
    
        
        NSArray<QuestionInfo *> * modelArr = self.dataSource[indexPath.section];
        QuestionInfo * model = modelArr[indexPath.item];
        
        
        
        Question * q = model.QuestionArr[order];
        
        self.currModel = q;
        _FootMakeSureView.HiddenPoint = NO;

        if (q.isMakeSure) {
            self.FootSelectView.hidden = NO;
            self.FootMakeSureView.hidden = YES;
            [self changeSelectViewStatusWithOrder:order];

            
        }else{
            
            [self changeSelectViewStatusWithOrder:order];

            self.FootSelectView.hidden = YES;
            self.FootMakeSureView.hidden = NO;

        }
        if (q.User_SelectSet.count > 0) {
            
            
            self.FootMakeSureView.userInteractionEnabled = YES;
            
        }else
        {
            self.FootMakeSureView.userInteractionEnabled = NO;
            
        }

    
    }
    
    
    
    [super BaseQuestionView:view numberOfItemsInData:indexPath CollectionStatus:status selectOrder:order];

}





//  点击确定
-(void)BaseQuestionFootMakeSureViewDidSelect
{
  
    if (self.CollectionStatus == CollectionViewHeader) {
        [self.QuestionView ScrollViewWithDirection:true];

        
    }else if(self.CollectionStatus == CollectionViewNone)
    {
        self.currModel.isMakeSure = true;
        
        self.FootMakeSureView.hidden = YES;
        
        self.FootSelectView.hidden = NO;
        
        self.FootSelectView.NextEnabled = YES;

        [self changeSelectViewStatusWithOrder:self.order];
        
        [self.view bringSubviewToFront:self.FootMakeSureView];
        
        
        // 统计
       __block NSString * userSelect = nil;
        [self.currModel.User_SelectSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop){
            
            userSelect  = [NSString stringWithFormat:@"%@%@" , userSelect , obj];
        }];
        
        [TongJiTool XYWYClickEvent:TongJiToolClcikMakeSure attributes:nil ];

        
        NSMutableDictionary  * dic = [NSMutableDictionary dictionary ];
        dic[@"answerId"] = [NSString stringWithFormat:@"%ld" , self.currModel.answerId];
        if (self.currModel.User_SelectStatus == UserSelectCorrect) {
            dic[@"result"] = @"正确";
            
        }else{
            dic[@"result"] = @"错误";

        
        }
        dic[@"userSelect"] = userSelect;
        
        
        
        [TongJiTool XYWYClickEvent:TongJiToolUserSelect attributes:dic ];

    
        [self.QuestionView reloadData];
    
    }else if(self.CollectionStatus == CollectionViewFooter){
    
        QuestionResultVC * vc = [[QuestionResultVC alloc] initWithType:QuestionResultExamination];

        vc.dataSource = self.dataSource;
        
        [self.navigationController  pushViewController:vc animated:YES];
    
    }
    

}

-(void) changeSelectViewStatusWithOrder:(NSInteger ) order
{
     if ((self.indexPath.section == ( self.dataSource.count - 1 ))  && (self.indexPath.item == ([self.dataSource.lastObject count] -1 ))) {
         
         
         NSArray * arr = self.dataSource[self.indexPath.section];
         QuestionInfo * infoModel = arr[self.indexPath.item];
         
         if (self.questionType == QuestionResultPractice) {
             
             
             if (order == infoModel.QuestionArr.count -1) {
                 self.FootSelectView.netTitle = @"完成";

             }else{
                 self.FootSelectView.netTitle = @"下一页";

             }
             self.FootSelectView.NextEnabled = YES;

         }else if(self.questionType == QuestionResultExamination){
         
             self.FootSelectView.netTitle = @"下一页";
             self.FootSelectView.NextEnabled = YES;


         }else if((self.questionType == ExaminationWrongReview ) || (self.questionType == PracticeWrongReview) || (self.questionType == MyPracticeWrongOrRecord)){

            
             
             
             if (order == infoModel.QuestionArr.count -1) {
                 self.FootSelectView.netTitle = @"下一页";
                 
                 self.NotificationCenter = [NSNotificationCenter defaultCenter ] ;
                 
                 [self.NotificationCenter  addObserver:self selector:@selector(slidingHandle) name:NSNotificationCentersliding object:nil];
                 self.FootSelectView.NextEnabled = NO;

             }else{
                 self.FootSelectView.NextEnabled = YES;

             
                 if (self.NotificationCenter) {
                     
                     [self.NotificationCenter removeObserver:self];
                     self.NotificationCenter = nil;
                     
                 }
             }


         }
         
         
     }else{
         if (self.NotificationCenter) {
             
             [self.NotificationCenter removeObserver:self];
             self.NotificationCenter = nil;
             
         }
         self.FootSelectView.netTitle = @"下一页";
         
         self.FootSelectView.NextEnabled = YES;

     
     }
    


}

-(void)slidingHandle
{
    [MBProgressHUD showSuccess:@"已经是最后一题了"];

    
    NSLog(@"%s" , __func__);
    
}

// 上一页 下一页的代理方法
-(void)BaseQuestionFootSelectView :(BaseQuestionFootSelectView *) view direction:(BOOL) direction
{

    
    if ((self.questionType == QuestionResultPractice)  ) {
    
        
        if(direction == true){
            
            [TongJiTool XYWYClickEvent:TongJiToolClcikNextBtn attributes:nil ];

            if ((self.indexPath.section == ( self.dataSource.count - 1 ))  && (self.indexPath.item == ([self.dataSource.lastObject count] -1 ))) {
                
                NSArray * arr = self.dataSource[self.indexPath.section];
                QuestionInfo * infoModel = arr[self.indexPath.item];
                if (self.order == infoModel.QuestionArr.count -1) {
                    QuestionResultVC * vc = [[QuestionResultVC alloc] initWithType:QuestionResultPractice];
                    
                    vc.dataSource = self.dataSource;
                    
                    [self.navigationController  pushViewController:vc animated:YES];
                }else{
                    [self.QuestionView ScrollViewWithDirection:direction];

                }
                
                return;
                
                
                
                
            }
            
        }else{
            [TongJiTool XYWYClickEvent:TongJiToolClcikPreBtn attributes:nil ];

            [self.QuestionView ScrollViewWithDirection:direction];
            return;
            

        
        }
        
    }

    [self.QuestionView ScrollViewWithDirection:direction];

}


#pragma mark get 方法

-(BaseQuestionFootSelectView *)FootSelectView
{
    if (!_FootSelectView) {
        _FootSelectView = [BaseQuestionFootSelectView FootSelectView];
        
        _FootSelectView.frame = CGRectMake(0, SCREEN_HEIGHT - FootViewHeight, SCREEN_WIDTH, FootViewHeight);
        
        [self.view addSubview:_FootSelectView];
        _FootSelectView.delegate = self;
    }
    
    return _FootSelectView;
    
}

-(BaseQuestionFootMakeSureView *)FootMakeSureView
{
    if (!_FootMakeSureView) {
        _FootMakeSureView = [BaseQuestionFootMakeSureView FootMakeSureView    ];
        
        _FootMakeSureView.frame  =CGRectMake(0, SCREEN_HEIGHT - FootViewHeight, SCREEN_WIDTH, FootViewHeight);
        
        _FootMakeSureView.title = @"开始";
        
        _FootMakeSureView.delegate = self;
        
    }
    
    return _FootMakeSureView;
    
    
    
}





@end
