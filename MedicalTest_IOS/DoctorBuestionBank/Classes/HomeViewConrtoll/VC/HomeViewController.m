//
//  HomeViewController.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/18.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeViewController.h"

#import <POP.h>

#import "QuestionsApi.h"
#import "QuestionModel.h"
#import "ChoseOneExaminationPaper.h"
#import "ExaminationRequirementsConfig.h"
#import "BaseQuestionViewController.h"
#import "UIBarButtonItem+XYWY.h"
#import "MyViewController.h"
#import "MyMistakenViewController.h"
#import "HomeTipView.h"


#import "HomeTableViewCell.h"
#import "GradeTabView.h"
#import "HomeCollectionViewCell.h"
#import "TriangleView.h"
#import "ExaminationViewConrtoller.h"
#import "PracticeVC.h"
#import "NewHomeCollectionViewCell.h"
#import "CustomHomeNavigationItem.h"
#import "CustomAlertView.h"
#import "QuestionSingletonTool.h"
#import "CustomAlertView.h"
#import "HomeContentView.h"
#import "QuestionDataHandleTool.h"





#define identifer @"HomeCollectionViewCell"
#import "UIViewController+MMDrawerController.h"

#define DurationTime  0.3
#define ClickUtemDuTime  0.25
#define ExchangeSubviewTime 0.5





@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , HomeContentViewDelegate , CustomHomeNavigationItemDelegate>

@property(nonatomic , strong) QuestionsApi * qApi ;

@property(nonatomic , strong) NSArray<QuestionLevelModel *> * levelArr;
@property(nonatomic , strong) NSArray<QuestionLevelModel *> * examinationLevelArr;


@property(nonatomic , strong) NSMutableArray<NSArray <QuestionTopicModel *> * > * TopicModelArr;

@property(nonatomic , assign) CGFloat ItemWidth;



@property(nonatomic , strong) UICollectionViewFlowLayout * layout;

@property(nonatomic , strong) UICollectionView *HorizontalCollectionView;
@property(nonatomic , strong) UICollectionView *VerticalCollectionView;
@property(nonatomic , strong) UICollectionView *ExaminationHorizontalCollectionView;


@property(nonatomic , strong) UICollectionView *DetailcollectionView;
@property(nonatomic , strong) HomeContentView * contentView;
@property(nonatomic , strong) HomeContentView * animateContentView;
@property(nonatomic , assign) NSInteger didSelectItem;

@property(nonatomic ,assign) BOOL isVerticalFirst;

@property(nonatomic , strong) TriangleView *triangleView;

@property(nonatomic , assign ) BOOL panGestureStatus;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property(weak , nonatomic) CustomHomeNavigationItem * CustomNavigationItem;


@property(nonatomic , strong) UIImageView * indicateImageView;

@property(nonatomic , weak) UIView * transitionView;

@property(nonatomic , weak) UIView * practiseView;
@property(nonatomic , weak) UIView * examinationView;





@end

@implementation HomeViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupTransitionView];

    self.backImageView.image = [UIImage imageNamed:@"homeTitle"];
    
    
     _qApi = [QuestionsApi share];

    [self setupCustomNavigation];
    
    [self setupHorizontalCollectionView];
    [self setupExaminationHorizontalCollectionView];


    [self setupVerticalCollectionView];
    
    _isVerticalFirst = YES;
    
    self.didSelectItem = -1;
    

    
}

-(void)setupTransitionView
{
    
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH    , SCREEN_WIDTH      , SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    
    UIImageView *  imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0    , SCREEN_WIDTH      , SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    imageView1.image = [UIImage imageNamed:@"homeTitle"];
    
    UIImageView *  imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0    , SCREEN_WIDTH      , SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    imageView2.image = [UIImage imageNamed:@"homeTitle"];
    
    UIView  * examinationView =[[UIView alloc] initWithFrame:CGRectMake(0, 0    , SCREEN_WIDTH      , SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    [examinationView addSubview:imageView1];
    
    examinationView.backgroundColor = [UIColor redColor];
    
    self.examinationView = examinationView;
    [view addSubview:examinationView];
    
    UIView  * practiseView =[[UIView alloc] initWithFrame:CGRectMake(0, 0    , SCREEN_WIDTH      , SCREEN_HEIGHT - NAVIGATION_HEIGH)];
    [practiseView addSubview:imageView2];

    self.practiseView = practiseView;
    [view addSubview:practiseView];
    
 

    
    self.transitionView = view;
    [self.view addSubview:view];
}

-(void)setupCustomNavigation
{
    CustomHomeNavigationItem  * view = [CustomHomeNavigationItem HomeNavigationItem];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_HEIGH);
    view.delegate = self;
    view.hiddenBackImage = YES;
    self.CustomNavigationItem = view;
    [self.view addSubview:view];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [TongJiTool XYWYClickEvent:TongJiToolHome attributes:nil ];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.view sendSubviewToBack:self.backImageView];
    self.navigationController.navigationBarHidden = YES;
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    if (self.didSelectItem >= 0) { // 更新未完成数目
        
        QuestionLevelModel * model  = self.levelArr[self.didSelectItem];
        
        NSArray <QuestionTopicModel *> *  arr = [[QuestionsApi share] QuestionsTopicWithLevelModel:model];
        
        NSArray * oldArr = self.TopicModelArr[self.didSelectItem];
        
        for (NSInteger i = 0;  i < [oldArr   count] ; i++) {
            QuestionTopicModel *oldModel = oldArr[i];
            
            QuestionTopicModel * newModel = arr[i];
            oldModel.CompleteCount = newModel.CompleteCount;

            oldModel.AllCount = newModel.AllCount;
            oldModel.correctCount = newModel.correctCount;
            oldModel.type = newModel.type;
            
            
            
        }
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.didSelectItem inSection:0];
      
        [self.contentView reloadAtIndexPath:path];
        
        
    }else{
        
        QuestionSingletonTool * tool = [QuestionSingletonTool SingletonTool];
        
        BOOL ret = [tool isComplete  ];
        
        if (!ret) {
            
            NSString * title = nil;
            
            if (tool.questionType == QuestionResultPractice) {
                title = @"上次有未完成练习，是否继续";
                
            }else if(tool.questionType == QuestionResultExamination){
                title = @"上次有未完成随堂测验，是否继续";

                if ([[QuestionSingletonTool SingletonTool] ExaminationType]) {
                    
                    title = @"上次有未完成考试  ，是否继续";
                    
                }
                

            }
            
            [CustomAlertView showAlertWithTitle:title message:nil cancelTitle:@"继续" otherTitle:@"放弃" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
                NSLog(@"%ld" , buttonIndex);
                

                if (buttonIndex == 0) {
                    
                    NSArray * arr = [tool UnfinishedQuestion];
                    
                    if (tool.questionType == QuestionResultPractice) {
                        ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:tool.questionType];
                        
                        vc.clearQuestionStatus = false;

                        vc.loadingAnimate = false;
                        vc.dataSource = arr;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        
                        PracticeVC * vc = [[PracticeVC alloc] initWithType:tool.questionType];
                        vc.loadingAnimate = false;
                        vc.dataSource = arr;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    
                    }
             
                }else {
                
                    [tool Complete];
                }
            }];
        }
    
    }
    

 
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
}

-(void)setupHorizontalCollectionView
{
    
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, HomeCellHeight + HomeRowrowSpace);
    UICollectionView * view =  [self createCollectionViewWuthFrame:frame ScrollDirection:UICollectionViewScrollDirectionHorizontal];

    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [view addGestureRecognizer:panGesture];
    view.hidden = YES;
    
    self.HorizontalCollectionView = view;
    [self.practiseView addSubview:view];
    _panGestureStatus = false;
    
}

-(void)setupExaminationHorizontalCollectionView
{
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, HomeCellHeight + HomeRowrowSpace);
    UICollectionView * view =  [self createCollectionViewWuthFrame:frame ScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.ExaminationHorizontalCollectionView = view;
    [self.examinationView addSubview:view];
    


}




-(void)setupVerticalCollectionView{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH);
    
    UICollectionView * view =  [self createCollectionViewWuthFrame:frame ScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.VerticalCollectionView = view;
    
    [self.practiseView addSubview:view];
    

}



-(UICollectionView *) createCollectionViewWuthFrame:(CGRect) frame ScrollDirection:(UICollectionViewScrollDirection)ScrollDirection ;
{
    
    

    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.minimumLineSpacing = 0.0;
    layOut.minimumInteritemSpacing = 0;
    layOut.scrollDirection = ScrollDirection;

    if (ScrollDirection == UICollectionViewScrollDirectionHorizontal) {
        layOut.sectionInset = UIEdgeInsetsMake(16, 16, 0, 3*self.ItemWidth );
        layOut.minimumLineSpacing = 16;



    }else{
        layOut.sectionInset = UIEdgeInsetsMake(16 , 16, 0, 16);
        layOut.minimumInteritemSpacing = 16;
    
    }
    
    layOut.itemSize = CGSizeMake(self.ItemWidth, HomeCellHeight);
    
    UICollectionView  *collectionView = [[UICollectionView alloc] initWithFrame: frame collectionViewLayout:layOut];
    

    
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    

    
    [collectionView registerNib:[UINib nibWithNibName:@"NewHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    
    if (ScrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        collectionView.scrollEnabled = NO;
    }else{
        
        
        
    }
    return collectionView;
    
    

}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.ExaminationHorizontalCollectionView) {
        
        return self.examinationLevelArr.count;
        
    }
    return self.levelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    QuestionLevelModel * model = nil;
    
    if (collectionView == self.ExaminationHorizontalCollectionView) {
        model = self.examinationLevelArr[indexPath.item];
    }else{
        
       model = self.levelArr[indexPath.item];

    
    }
    cell.model = model;
    
    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NewHomeCollectionViewCell * cell =(NewHomeCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    if (collectionView == self.ExaminationHorizontalCollectionView) {
        
        
        NSString * tongjiStr = nil;
        
     

        if (indexPath.item == 0 ) {
            
            tongjiStr = TongJiToolClickZhuanYeWuShi;
            QuestionTopicModel * zObj = [[QuestionTopicModel alloc] init];
            zObj.TopicType = 1;
            PracticeVC * vc = [[PracticeVC alloc] initWithType:QuestionResultExamination];
            vc.TopicModelArr = @[zObj];
            [self.navigationController   pushViewController:vc animated:YES];
            
            
        }else{
            
            tongjiStr = TongJiToolClickShijianNeli;

            QuestionTopicModel * sObj = [[QuestionTopicModel alloc] init];
            sObj.TopicType = 2;

            PracticeVC * vc = [[PracticeVC alloc] initWithType:QuestionResultExamination];
            vc.TopicModelArr = @[sObj];
            [self.navigationController   pushViewController:vc animated:YES];
            
            
        }
        [TongJiTool XYWYClickEvent:tongjiStr attributes:nil ];

        
        return;
        
    }

    if (_isVerticalFirst) { // 显示全部类型
        
        self.didSelectItem = indexPath.item;
        
        self.animateContentView.item = self.didSelectItem;
        self.contentView.hidden = YES;
        self.contentView.item = self.didSelectItem;
        
        

        cell.duTime = DurationTime;

        NSInteger row =  floor(indexPath.item/4);

        
        double totalDis = SCREEN_HEIGHT -HomeCellHeight - NAVIGATION_HEIGH-16;
        double distanceS = row*HomeCellHeight - self.VerticalCollectionView.contentOffset.y ;
        double distanceF  =totalDis -  distanceS  ;
        double segmentationTime =distanceF/( totalDis);

        
        CAKeyframeAnimation * ContentViewAnimation = [self createCAKeyframeAnimationWithDistanceF:distanceF distanceS:(totalDis) segmentationTime:segmentationTime pmFlag:false upOrDown:false ];
       
        CAKeyframeAnimation * collectionViewAnimation = [self createCAKeyframeAnimationWithDistanceF:0 distanceS:distanceS segmentationTime:segmentationTime  pmFlag:false upOrDown:false];
    
        collectionViewAnimation.delegate = self;
        
        self.HorizontalCollectionView.hidden = YES;
        
        CGPoint offset = CGPointMake(SCREEN_WIDTH*row -16*row , 0);
        [self.HorizontalCollectionView setContentOffset:offset animated:NO];
        
        [self.animateContentView.layer addAnimation:ContentViewAnimation forKey:nil];
        [self.VerticalCollectionView.layer addAnimation:collectionViewAnimation forKey:nil];
    }else{
    
        
        if (self.didSelectItem != indexPath.item) {
            
            self.didSelectItem = indexPath.item;
            self.contentView.item = self.didSelectItem;
            [self scrollTriangleViewWithItem:self.didSelectItem];
            cell.duTime = ClickUtemDuTime;
        };

    }
    
    
}



-(CAKeyframeAnimation *) createCAKeyframeAnimationWithDistanceF:(CGFloat) distanceF  distanceS:(CGFloat) distanceS segmentationTime:(CGFloat) segmentationTime pmFlag:(BOOL) pmFlag upOrDown:(BOOL) upOrDorn;

{
    
    
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    keyAnima.keyPath=@"transform.translation";
    
    if (!pmFlag) {
        distanceS = -distanceS;
        distanceF = -distanceF;
    }
    
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(0, 0)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(0, distanceF)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(0, distanceS)];
    
    keyAnima.values=@[value1,value2 , value3];

    if (!pmFlag) {
        
        if (upOrDorn) {// 向下
            
            keyAnima.values=@[value3,value2 , value1];

            
        }
    }
    
    NSNumber * num1 = [NSNumber numberWithFloat:0.0];
    NSNumber * num2 = [NSNumber numberWithFloat:segmentationTime];
    NSNumber * num3 = [NSNumber numberWithFloat:1.0];
    keyAnima.keyTimes = @[num1 , num2 , num3 ];
    [keyAnima setCalculationMode:kCAAnimationLinear];
    keyAnima.removedOnCompletion=NO;
    keyAnima.fillMode=kCAFillModeForwards;
    keyAnima.duration=DurationTime;
    
 
    
    return keyAnima;
    
}

- (void)animationDidStart:(CAAnimation *)anim
{
 
    self.CustomNavigationItem.hiddenBackImage = NO;
    self.view.userInteractionEnabled = NO;
    
    if (_isVerticalFirst) {
        
        NSInteger row =  floor(self.didSelectItem/4);
        
        

        self.indicateImageView.hidden = YES;
        
        
        CGPoint offset = CGPointMake(SCREEN_WIDTH*row -16*row , 0);
        [self.HorizontalCollectionView setContentOffset:offset animated:NO];
      
    }else
    {
        self.HorizontalCollectionView.hidden = YES;
        [self triangleViewAnimationWithPm:true];
        
    }
    

}


-(void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    self.CustomNavigationItem.hiddenBackImage = YES;

    self.view.userInteractionEnabled = YES;

    
    if (self.isVerticalFirst) {
        self.VerticalCollectionView.hidden = YES;
        [self.practiseView bringSubviewToFront:self.HorizontalCollectionView];
        
        

        self.contentView.hidden = NO;
        self.animateContentView.hidden = YES;
        
        self.indicateImageView.hidden = NO;
        
        
        [self.practiseView bringSubviewToFront:self.indicateImageView];
        
        
        
        [self triangleViewAnimationWithPm:false];
        
        
        self.isVerticalFirst = false;
        self.HorizontalCollectionView.hidden = NO;


        
    }else{
        
        self.VerticalCollectionView.hidden =  NO;
        
        [self.animateContentView removeFromSuperview];
        self.animateContentView = nil;
        
        if (self.isVerticalFirst == false) {
            
            [self.contentView removeFromSuperview ];
            self.contentView = nil;
        }

        self.panGestureStatus = false;
        self.isVerticalFirst = true;
    }
    
    

   
}

-(void)panGesture:(UIGestureRecognizer*)gestureRecognizer
{
    
    static  CGFloat  originalY = 0;

    
    if (!self.panGestureStatus) {
        
        float pointerY = [gestureRecognizer locationInView:self.HorizontalCollectionView   ].y;
        
        if (originalY == 0) {
            
            originalY = pointerY;
        }
        
        if (originalY > pointerY) {
            originalY = pointerY;
        }
        
      
        
        if (pointerY - originalY > 50) {
            
     
            self.panGestureStatus = true;
            originalY = 0;

            [self.practiseView bringSubviewToFront:self.contentView];
            self.HorizontalCollectionView.hidden = YES;
            self.VerticalCollectionView.hidden =  NO;
            
        
            NSInteger i =  floor(self.didSelectItem/4);
            double totalDis = SCREEN_HEIGHT -HomeCellHeight - NAVIGATION_HEIGH-16;
            
            
            double distanceS = i*HomeCellHeight - self.VerticalCollectionView.contentOffset.y;
            double segmentationTime =distanceS/totalDis;
            
            
            CAKeyframeAnimation * contentViewAnimation = [self createCAKeyframeAnimationWithDistanceF:distanceS distanceS:totalDis segmentationTime:segmentationTime pmFlag:true upOrDown:false ];
            
            
            CAKeyframeAnimation * collectionViewAnimation = [self createCAKeyframeAnimationWithDistanceF:0 distanceS:distanceS segmentationTime:segmentationTime pmFlag:false upOrDown:true  ];
            
            
            collectionViewAnimation.delegate = self;
            
            [self.contentView.layer addAnimation:contentViewAnimation forKey:nil];
            
            [self.VerticalCollectionView.layer addAnimation:collectionViewAnimation forKey:nil];
 
        }
        
    }
    

}


-(NSArray<QuestionLevelModel *> *) examinationLevelArr
{
    
    if (!_examinationLevelArr) {
        
        
        QuestionLevelModel * zObj = [[QuestionLevelModel  alloc] init];
        zObj.LevelName = @"专业务实";
        zObj.AllCount = 1900;
        zObj.LevelId =@"Z";
        
        [[QuestionsApi share] examinationInfoWithQuestionLevelModel:zObj];
        zObj.type = [QuestionDataHandleTool getTopicTypeWithCompleteCount:zObj.CompleteCount withCorrectCount:zObj.correctCount allCount:zObj.AllCount];

        
        QuestionLevelModel * sObj = [[QuestionLevelModel  alloc] init];
        sObj.LevelName = @"实践能力";
        sObj.LevelId = @"S";
        sObj.AllCount = 900;
        [[QuestionsApi share] examinationInfoWithQuestionLevelModel:sObj];
        sObj.type = [QuestionDataHandleTool getTopicTypeWithCompleteCount:sObj.CompleteCount withCorrectCount:sObj.correctCount allCount:sObj.AllCount];


    
        _examinationLevelArr = @[zObj , sObj];
        
    }
    
    return _examinationLevelArr;
    


}

-(NSArray<QuestionLevelModel *> *) levelArr
{
    if (!_levelArr) {
        NSArray * arr = [[QuestionsApi share ] QuestionsLevel];
        NSMutableArray * levelArr = [NSMutableArray arrayWithArray:arr];
        
        
        
        
        _levelArr = [levelArr copy];
        
        NSMutableArray  * mArr = [NSMutableArray array];
        
        
        for (NSInteger i = 0; i < _levelArr.count; i++) {
            
            QuestionLevelModel * model  = self.levelArr[i];
            
            NSArray <QuestionTopicModel *> *  arr = [[QuestionsApi share] QuestionsTopicWithLevelModel:model];
            
            
            
            [mArr addObject:arr];
            
        }
      
        
        self.TopicModelArr = mArr;
    }
    
    return _levelArr ;
    
    
}


-(HomeContentView *) animateContentView
{
    if (!_animateContentView) {
        _animateContentView = [HomeContentView ContentView];
        _animateContentView.frame = CGRectMake(0, SCREEN_HEIGHT -NAVIGATION_HEIGH , SCREEN_WIDTH, SCREEN_HEIGHT  - HomeCellHeight -NAVIGATION_HEIGH - HomeCellLineSpace);
        _animateContentView.backgroundColor = [UIColor whiteColor];
        _animateContentView.TopicModelArr = self.TopicModelArr;
        
        [self.practiseView addSubview:_animateContentView];
        _animateContentView.singleItem = YES;

        
    }
    return _animateContentView;
    
}

-(HomeContentView *) contentView
{
    if (!_contentView) {
        _contentView = [HomeContentView ContentView];
        _contentView.frame = CGRectMake(0, HomeCellHeight + HomeCellLineSpace , SCREEN_WIDTH, SCREEN_HEIGHT  - HomeCellHeight -NAVIGATION_HEIGH - HomeCellLineSpace);
        
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.levelArr = self.levelArr;
        _contentView.TopicModelArr = [self.TopicModelArr copy];
        _contentView.delegate = self;
        _contentView.singleItem = false;
        
        _contentView.backgroundColor = [UIColor redColor];
        
        
        [self.practiseView addSubview:_contentView];
        
        
    }
    
    return _contentView;
    
    
}

-(TriangleView *)triangleView
{
    if (!_triangleView) {
        
        CGFloat h = 10;
        CGFloat w = 32;
        _triangleView = [[TriangleView alloc] initWithFrame:CGRectMake(100, HomeCellHeight -h, w, h)];

        [self.view addSubview:_triangleView];
    }
    
    return _triangleView;
    

}

#pragma mark 箭头的滚动
// 箭头的左右滚动
-(void) scrollTriangleViewWithItem:(NSInteger) item
{
    
    NSInteger column = item%4;
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat x = (column*2 + 1)*self.ItemWidth/2 + (column +1)*HomeCellLineSpace -self.indicateImageView.width/2;
        
        self.indicateImageView.frame = CGRectMake(x, HomeCellHeight - self.indicateImageView.height + HomeCellLineSpace + NAVIGATION_HEIGH, self.indicateImageView.width   , self.indicateImageView.height);
        
        
        
    } completion:^(BOOL finished) {
        
        
    }];


}

// 箭头的上下滚动


-(void) triangleViewAnimationWithPm:(BOOL) pm{
    
    
    NSInteger column = self.didSelectItem%4;

    CGFloat x = (column*2 + 1)*self.ItemWidth/2 + (column +1)*HomeCellLineSpace -self.indicateImageView.width/2;

    CGFloat yTo = 0;
    CGFloat yF = 0;
    if (pm) {
        yF =HomeCellHeight + NAVIGATION_HEIGH - self.indicateImageView.height ;
        yTo = -30;
    }else{
        yF = 0;
        yTo=HomeCellHeight - self.indicateImageView.height + HomeCellLineSpace + NAVIGATION_HEIGH;
    }
    
    
    POPSpringAnimation *triangleViewAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    triangleViewAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(x, yF  , self.indicateImageView.width   , self.indicateImageView.height)];
    triangleViewAnim.toValue = [NSValue valueWithCGRect:CGRectMake(x, yTo, self.indicateImageView.width   , self.indicateImageView.height)];
    triangleViewAnim.springBounciness = 1;
    triangleViewAnim.springSpeed = 1;
    
    triangleViewAnim.beginTime = CACurrentMediaTime() ;
    
    [self.indicateImageView pop_addAnimation:triangleViewAnim forKey:nil];
    
    
    
    
    
}

#pragma mark 代理方法


-(void ) HomeContentView:(HomeContentView *) view ScrollViewFromItem:(NSInteger) fromItem toItem:(NSInteger) toItem;
{
    
    
    
    [self scrollTriangleViewWithItem:toItem];
    CGFloat delaySecond = 0;
    
    NSInteger row =  floor(toItem/4);


    
    if(toItem %4 == 0){// 向右滑动真个屏幕的宽度
        
        
        CGPoint offset = CGPointMake(SCREEN_WIDTH*row -HomeCellLineSpace*row , 0);
        [self.HorizontalCollectionView setContentOffset:offset animated:YES];
        
        
        delaySecond = 0.1;
        
    
    }else if(toItem %4 == 3){
    

        delaySecond = 0.1;
        CGPoint offset = CGPointMake(SCREEN_WIDTH*row -HomeCellLineSpace*row , 0);
        [self.HorizontalCollectionView setContentOffset:offset animated:YES];

    
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:toItem inSection:0];
        NewHomeCollectionViewCell * cell =(NewHomeCollectionViewCell *) [self.HorizontalCollectionView cellForItemAtIndexPath:indexPath];
        cell.duTime = ClickUtemDuTime;
        
        
    });
    
    
    self.didSelectItem = toItem;
    
    

}

#pragma mark 考试和练习按钮的代理方法

-(void ) HomeContentView:(HomeContentView *) view didType:(HomeContentViewClickType) type
{
 
    NSArray * selectedArray =  [self checkSelect];
    
    if (type == HomeContentViewClickPractice) {
        
        
        
        if (selectedArray.count)
        {
            
            NSMutableArray * CompleteArr = [NSMutableArray array];
            
            NSMutableDictionary * dic = [NSMutableDictionary  dictionary];
            
            

            
            for (QuestionTopicModel * model in selectedArray) {
                
                if (model.AllCount == model.CompleteCount) {
                    
                    [CompleteArr addObject:model];
                    
                }
                
                dic[model.TopicId] = model.TopicName;
                
                
            }
            [TongJiTool XYWYClickEvent:TongJiToolClickPractice attributes:dic ];

            
            if (CompleteArr.count > 0) {
                
                NSString * title = [NSString stringWithFormat:@"您选择的章节有%ld个已全部练完，是否全部重新练习",CompleteArr.count ];
                
                [CustomAlertView showAlertWithTitle:title message:nil cancelTitle:@"是" otherTitle:@"否" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                    
                    
                    if(buttonIndex == 0){
                        
                        [self.qApi clearPracticeRecodeWithModelArr:CompleteArr];
                        
                    }
                    
                    
                    ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:QuestionResultPractice];
                    vc.modelArr = selectedArray;
                    [self.navigationController   pushViewController:vc animated:YES];
                    
                    
                }];
                
            }else{
                
                
                ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:QuestionResultPractice];
                vc.modelArr = selectedArray;
                [self.navigationController   pushViewController:vc animated:YES];
                
            }
            
        }else{ // 一个都没选 默认为练习第一个
            
            return;
            

            
        }
    }else if(type == HomeContentViewClickExamination){
        

        
        
        if (selectedArray.count == 0) {
            return;
            
        }
        
        
        
        NSMutableDictionary * dic = [NSMutableDictionary  dictionary];

        for (QuestionTopicModel * model in selectedArray) {
            dic[model.TopicId] = model.TopicName;

            
        }
        [TongJiTool XYWYClickEvent:TongJiToolClickExamination attributes:dic ];
        
        PracticeVC * vc = [[PracticeVC alloc] initWithType:QuestionResultExamination];
        vc.TopicModelArr = selectedArray;

        QuestionLevelModel * model = self.levelArr[self.didSelectItem];
        vc.LevelId = model.LevelId;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
   
}



-(NSArray * ) checkSelect
{
    
    NSArray * arr  = self.TopicModelArr[self.didSelectItem];
    
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    for (QuestionTopicModel *cModel in arr)
    {
        if (cModel.isSelect)
        {
            [selectedArray addObject:cModel];
        }
    }
    
    if (selectedArray.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"至少选择一个章节" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        
        return nil;
        
    }
    
    return selectedArray;
    
    
    
    


}


-(void) CustomHomeNavigationItem:(CustomHomeNavigationItem *) view didClickType:(CustomHomeNavigationItemClickType) clickType
{
    if (clickType == CustomHomeNavigationItemClickMy){
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

        
    }else if(clickType == CustomHomeNavigationItemClickInstructions){
        [HomeTipView showTipViewWithIconFrame:view.instructionsButton.frame];

    }else if(clickType == CustomHomeNavigationItemClickExamination){
    
        [self customExchangeSubview];
        
        if(_indicateImageView){
            
            self.indicateImageView.hidden = YES ;
            
            
        }
        
       
        
        
    }else if(clickType == CustomHomeNavigationItemClickPractice){
    
        if(_indicateImageView){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ExchangeSubviewTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.indicateImageView.hidden = NO ;

                
                
            });
            
            
        }
        [self customExchangeSubview];

    }

}

-(void) customExchangeSubview
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:ExchangeSubviewTime];
    

    NSInteger first = [self.transitionView.subviews indexOfObject:self.examinationView ];
    NSInteger second =[self.transitionView.subviews indexOfObject:self.practiseView ];
    
    UIViewAnimationTransition  AnimationTransition=UIViewAnimationTransitionFlipFromLeft;
    if(first > second)
    {
        AnimationTransition = UIViewAnimationTransitionFlipFromRight;
        
    }
    
    [UIView setAnimationTransition:AnimationTransition forView:self.transitionView cache:YES ];
    
    
    
    [self.transitionView exchangeSubviewAtIndex:first withSubviewAtIndex:second ];
    
    [UIView commitAnimations];
    
    
    
}



-(CGFloat)ItemWidth
{
    if (_ItemWidth == 0) {
        
        
        _ItemWidth =(SCREEN_WIDTH - HomeCellLineSpace *5)/4.00;
    }
    
    return _ItemWidth;
    

}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view sendSubviewToBack:self.backImageView];
    [self.view bringSubviewToFront:self.CustomNavigationItem];

    

}

-(UIImageView *) indicateImageView
{
    if (!_indicateImageView) {
        
        UIImage * image = [UIImage imageNamed:@"indicateImage"];
        
        
        CGFloat h = image.size.height;
        CGFloat w = image.size.width;
        
     _indicateImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(100, HomeCellHeight -h, w, h)];
        
        _indicateImageView.image = image;
        
        [self.view addSubview:_indicateImageView];

        
        
        
        
    }
    
    return _indicateImageView;
    


}


@end
