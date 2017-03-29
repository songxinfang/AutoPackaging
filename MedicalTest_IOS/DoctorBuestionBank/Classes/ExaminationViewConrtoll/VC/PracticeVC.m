//
//  PracticeVC.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/28.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "PracticeVC.h"
#import "QuestionsApi.h"
#import "QuestionModel.h"
#import "BaseQuestionFootMakeSureView.h"
#import "QuestionResultVC.h"
#import "QuestionDataHandleTool.h"



@interface PracticeVC () <UIGestureRecognizerDelegate    , BaseQuestionFootMakeSureViewDelegate  >

@property(nonatomic , strong) BaseQuestionFootMakeSureView * FootMakeSureView;
@property(nonatomic , weak) Question * currModel;
@property(nonatomic , assign) CollectionViewStatus CollectionStatus;
@property(nonatomic , assign) QuestionResultType questionType;


@end

@implementation PracticeVC


-(instancetype) initWithType:(QuestionResultType ) type
{
    self = [super initWithType:type];
    
    self.questionType = type;
    self.loadingAnimate = true;
    
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.clearQuestionStatus = true;
    
   
   
    if (self.loadingAnimate) {
        
        
       __block  NSArray * questionArr = [NSArray array ];
        __block BOOL dataOk = false;
        
        QuestionTopicModel * model = self.TopicModelArr.firstObject;
        
        dispatch_queue_t queue = dispatch_queue_create("PracticeVCDataSorce", NULL);
        dispatch_async(queue, ^{


            if (model.TopicType > 0) {
            
                QuestionTopicModel * model = self.TopicModelArr.firstObject;
                
                NSArray * arr  = [[QuestionsApi share] ExaminationWithType:model.TopicType ];
                
                questionArr =  [QuestionDataHandleTool separateTopic:arr];
                    
                
                
            }else{
                
                questionArr = [[QuestionsApi share] practiceExaminationWithLevelModelArr:self.TopicModelArr LevelId:self.LevelId ];
            
            }
            
            dataOk = true;
            
        });

        
   
        [self.loadingAnimation start];
        CGFloat duTime = 2 + (arc4random()%10)/10.0;
        
        self.loadingAnimation.allTimer = duTime;
        [self.loadingAnimation start];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.loadingAnimation stop];
            [self setupFootView];
            self.dataSource = questionArr;
            
        });

            
        
        
        
      
    }else
    {
        [self setupFootView];

    
    }
    
    
    
    
 
}





-(void)setupFootView
{

    [self.view addSubview:self.FootMakeSureView];
    [self.view bringSubviewToFront:self.FootMakeSureView];
    
}



/**
 * 题型介绍的代理方法
 *
 */


-(void) BaseQuestionView :(BaseQuestionView *) view  numberOfItemsInData:(NSIndexPath * ) indexPath CollectionStatus:(CollectionViewStatus) status selectOrder:(NSInteger) order
{
    
    self.CollectionStatus = status;
    
    if (status == CollectionViewHeader) {
         self.navigationItem.rightBarButtonItems = nil;
        self.FootMakeSureView.userInteractionEnabled = YES;

        if (indexPath.section == 0) {
            
            _FootMakeSureView.hidden = NO;
            _FootMakeSureView.title = @"开始";
            
        }
    
    }else if(status == CollectionViewFooter){
         self.navigationItem.rightBarButtonItems = nil;
        _FootMakeSureView.hidden = NO;
        _FootMakeSureView.title = @"交卷";
        self.FootMakeSureView.userInteractionEnabled = YES;

    
    }else{
        
        _FootMakeSureView.title = @"确定";
        
        NSArray<QuestionInfo *> * modelArr = self.dataSource[indexPath.section];
        QuestionInfo * model = modelArr[indexPath.item];
        
        Question * q = model.QuestionArr[order];
        
        self.currModel = q;
        
        
        if (q.User_SelectSet.count > 0) {
            
            self.FootMakeSureView.userInteractionEnabled = YES;
            
        }else
        {
            self.FootMakeSureView.userInteractionEnabled = NO;
            
        }
    
    }
    
    [super BaseQuestionView:view numberOfItemsInData:indexPath CollectionStatus:status selectOrder:order];
        
    return;
        
    
    
}


//  点击确定
-(void)BaseQuestionFootMakeSureViewDidSelect
{
 
    if (self.CollectionStatus == CollectionViewFooter) {
        QuestionResultVC * vc = [[QuestionResultVC alloc] initWithType:self.questionType];
        vc.dataSource = self.dataSource;
        [self.navigationController  pushViewController:vc animated:YES];
        
    }else if(self.CollectionStatus == CollectionViewHeader){
        [self.QuestionView ScrollViewWithDirection:YES];

    }else if(self.CollectionStatus == CollectionViewNone)
    {
        [TongJiTool XYWYClickEvent:TongJiToolClcikMakeSure attributes:nil ];

        
      
        
        [self.QuestionView ScrollViewWithDirection:YES];

    
    }
    
}





-(BaseQuestionFootMakeSureView *)FootMakeSureView
{
    if (!_FootMakeSureView) {
        _FootMakeSureView = [BaseQuestionFootMakeSureView FootMakeSureView    ];
        
        _FootMakeSureView.frame  =CGRectMake(0, SCREEN_HEIGHT - FootViewHeight  , SCREEN_WIDTH , FootViewHeight);
        
        _FootMakeSureView.title = @"开始";
        
        _FootMakeSureView.delegate = self;
        
        
    }
    
    return _FootMakeSureView;

}


-(void)setLoadingAnimate:(BOOL)loadingAnimate
{
    _loadingAnimate = loadingAnimate;
    
    NSLog(@"%d" , loadingAnimate);
    

}


@end
