//
//  BaseQuestionViewController.m
//  DoctorBuestionBank
//
//  Created by lc on 16/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionViewController.h"
#import "QuestionNavigationBar.h"
#import "QuestionsApi.h"
#import "AnswerSheetView.h"

#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NXShareModel.h"
#import "NXShareView.h"
#import "CustomAlertView.h"
#import "UIViewController+HUD.h"



#import "QuestionSingletonTool.h"

#import "BaseQuestionCell.h"






#define identifer @"BaseQuestionCell"


@interface BaseQuestionViewController ()  <QuestionNavigationBarDelegate , AnswerSheetViewDelegate,NXShareViewDelegate>

@property(nonatomic , weak) QuestionNavigationBar * customNavigationBar;

@property(nonatomic , assign) NSInteger  QuestionTotal;

@property(nonatomic , strong)AnswerSheetView  *SheetView;

@property(nonatomic ,assign) QuestionResultType questionType;



// 是否隐藏收藏
@property(nonatomic , assign)BOOL isHiddenCollection;

// 是否隐藏分享
@property(nonatomic , assign)BOOL isHiddenShare;

@property(nonatomic , strong) NSTimer * timer;
@property(nonatomic , assign) NSInteger timeNum;

@property(nonatomic , strong) BaseQuestionCell * questionShareView;
@property(nonatomic , assign) NSInteger  ord;





@end

@implementation BaseQuestionViewController


-(instancetype) initWithType:(QuestionResultType) type
{
    self = [super init];
    self.questionType = type;
    self.clearQuestionStatus = true;

    self.popToRoot = false;


    return self;
    

}

-(void) setClearQuestionStatus:(BOOL)clearQuestionStatus
{
    _clearQuestionStatus = clearQuestionStatus;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.view.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
    
    
     [self BaseQuestionView:nil numberOfItemsInData:nil CollectionStatus:CollectionViewHeader selectOrder:0];
    
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}



- (void)setupNav
{
    
    QuestionNavigationBar * view =  [QuestionNavigationBar NavigationBar];
    view.delegate = self;
    view.frame = CGRectMake(0, 0,SCREEN_WIDTH , NAVIGATION_HEIGH);
    
    [self.view addSubview:view];
    self.customNavigationBar = view;
    
    if (self.questionType != QuestionResultExamination) {
        self.customNavigationBar.isHiddenTime = YES;
        
        
    }else{
    
        self.customNavigationBar.isHiddenTime = NO;
        
        NSTimer * timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(HindleTime) userInfo:nil repeats:YES];
        
        self.timer = timer;
        
        

    
    }
   


}

-(void)HindleTime
{

    self.timeNum++;
    
    int h =(int) floor( self.timeNum /3600);
    int m  = (int)floor(self.timeNum/60);
    NSInteger s = self.timeNum%60;
    
    NSString * timeStr = nil;
    
    if (h> 0) {
        
        timeStr = [NSString stringWithFormat:@"%02d:%02d%02ld" , h , m , s];
        
        
    }else if(m > 0)
    {
        timeStr = [NSString stringWithFormat:@"%02d:%02ld" , m , s];

    
    }else{
        timeStr = [NSString stringWithFormat:@"00:%02ld"   , s];

    
    }
    
    self.customNavigationBar.timestr = timeStr;
    
    
    
    
    

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


-(void) BaseQuestionView :(BaseQuestionView *) view  numberOfItemsInData:(NSIndexPath * ) indexPath CollectionStatus:(CollectionViewStatus) status selectOrder:(NSInteger) order

{
    
    
    _ord = order;
    
    
    if (status == CollectionViewHeader) {
        
        self.customNavigationBar.title = @"题型介绍";
        self.customNavigationBar.isHiddenCollection = YES;
        self.customNavigationBar.isHiddenShare = YES;
        self.customNavigationBar.isHiddenTitleImage = YES;
        
        
    }else {
        _currentIndex  = indexPath;

        self.customNavigationBar.isHiddenShare = NO;
        
        if (!self.isHiddenCollection) {
            self.customNavigationBar.isHiddenCollection = NO;
            
            
        }
        if (!self.isHiddenShare) {
            
            self.customNavigationBar.isHiddenTitleImage = NO;
            
            
        }
        
        NSArray<QuestionInfo *> * modelArr = self.dataSource[indexPath.section];
        
        QuestionInfo * model = modelArr[indexPath.item];
        

        if (status == CollectionViewFooter) {
            model = modelArr.lastObject;
            self.customNavigationBar.isHiddenCollection = YES;
            self.customNavigationBar.isHiddenShare = YES;
           
        }
        

       
        

        self.customNavigationBar.title = [NSString stringWithFormat:@" %ld/%ld" , model.order   ,self.QuestionTotal];
        
      
        
        
        [self handleCollectionWithFlag:false];
        
    
    }
    
    

}

-(void)clearInfoModel:(QuestionInfo *) infoModel
{

    if ((self.questionType != QuestionResultPractice) ) {
        
        if (self.clearQuestionStatus) {
            
            for (Question * model in infoModel.QuestionArr) {
                
                model.User_SelectStatus = UserNoneSelect;
                model.isMakeSure = false;
                model.isShowDetal = false;
                [model.User_SelectSet removeAllObjects];
                
                
            }
        }
      
    }
}

-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{
    _dataSource = dataSource;
   
    _QuestionTotal = 0;
    for (NSArray * arr in dataSource) {
        
        
        for (QuestionInfo * model in arr) {
            _QuestionTotal++;
            model.order = _QuestionTotal;
            
            [self clearInfoModel:model];
            
            
        }
        
    }
   
    
    QuestionSingletonTool * tool = [QuestionSingletonTool SingletonTool];
    tool.questionType = self.questionType;
    tool.dataSource = dataSource;
    
    
    
    if (_dataSource.count > 0) {
        
        if (!self.QuestionView) {
            
            BaseQuestionView *view = [[BaseQuestionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH - FootViewHeight)];
            view.questionType = self.questionType;
            
            view.dataSource = _dataSource;
            view.delegate = self;
            view.questionType = self.questionType;
            self.QuestionView = view;

            [self.view addSubview:view];
        }
    }
    
}

-(void) QuestionNavigationBar:(QuestionNavigationBar *) view ClickType:(QuestionNavigationBarClickType) type
{
    
    if (type == QuestionNavigationBarClickBack) {
        
        if (self.questionType == QuestionResultExamination) {
           
            
            NSString * str = @"是否放弃本次随堂测验?";
            if ([[QuestionSingletonTool SingletonTool] ExaminationType]) {
                
                str = @"是否放弃本次考试?";

            }
            
            [CustomAlertView showAlertWithTitle:str message:nil cancelTitle:@"继续答题" otherTitle:@"放弃" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
                
                if (cancelled == false) {
                    
                    [self customPopViewController];
                 
                    
                }
            }];

            
        }else if (self.questionType == QuestionResultPractice){
            
            [CustomAlertView showAlertWithTitle:@"是否退出本次练习?" message:nil cancelTitle:@"退出" otherTitle:@"继续答题" completion:^(BOOL cancelled, NSInteger buttonIndex) {
                
                
                if (cancelled == true) {
                    
                   
                    [self customPopViewController];

                    
                }
            }];
            



        }else{
            [self customPopViewController];

        
        }
        
        
    }else if (type == QuestionNavigationBarClickCollection) {
        
        [self handleCollectionWithFlag:true];
        
        
    }else if(type == QuestionNavigationBarClickShare){
        [self handleShare];
        
        
    }else if(type == QuestionNavigationBarClickTitle){
        
        [self showAnswerSheetView ];

        
    }


}

-(void) customPopViewController
{
   
    QuestionSingletonTool * tool = [QuestionSingletonTool SingletonTool];
    [tool Complete];
    [tool syncData];
    
    [[QuestionsApi share ] clearOneExaminationRecord];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        
        
    }
    
    if (self.popToRoot) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    
    }
    


}


-(void ) handleCollectionWithFlag:(BOOL) flag
{
    NSArray <QuestionInfo *> * modeArr = self.dataSource[self.currentIndex.section];
    
    QuestionInfo * model = modeArr[self.currentIndex.item];
    
    
    
    if (flag) {
        model.isCollect = !model.isCollect;
        
        NSMutableDictionary  * dic = [NSMutableDictionary dictionary ];
        if (self.questionType == QuestionResultExamination) {
            dic[@"type"] = @"考试";
            
        }else{
            dic[@"type"] = @"练习";

        }
        
        dic[@"QuestionId"] = [NSString stringWithFormat:@"%@" , model.QuestionId];
        
        
        NSString * tongjiStr= nil;

        
        if (model.isCollect) {
            
            tongjiStr = TongJiToolCollection;

            [MBProgressHUD showSuccess:@"收藏成功"];
        }else{
            [MBProgressHUD showSuccess:@"取消收藏"];
            tongjiStr = TongJiToolcancelCollection;

            
            
        }
        
        
        [TongJiTool XYWYClickEvent:tongjiStr attributes:dic ];

    }
    
    
    
    
    
    self.customNavigationBar.isCollection = model.isCollect;
    
    QuestionsApi * api = [QuestionsApi share];
    NSInteger status = 0;
    if (model.isCollect) {
        status = 1;
    }
    if (flag) {
        [api updateCollectionWithQuestionId:model.QuestionId status:status];

        
    }
    
    
    
    
}



-(void) handleShare
{
    
    NSArray <QuestionInfo *> * modeArr = self.dataSource[self.currentIndex.section];
    QuestionInfo * model = modeArr[self.currentIndex.item];

    QuestionInfo * newModel = [model copy];
    
    Question * q = newModel.QuestionArr[self.ord];
    
    
    [q.User_SelectSet removeAllObjects];
    q.isMakeSure  = false;

    
    [newModel.QuestionArr removeAllObjects];
    [newModel.QuestionArr addObject:q];
    

    // 算高度
    CGFloat h = 0.0;
    for (NSNumber * num  in q.cellHeightDic.allValues) {
        
        h = h + [num floatValue];
        
        
    }
    h = h + q.titleHeight + 16;
    self.questionShareView.frame = CGRectMake(0, 100, SCREEN_WIDTH, h);
    self.questionShareView.hidden = NO;
    self.questionShareView.model = newModel;
    
  
    NSMutableDictionary  * dic = [NSMutableDictionary dictionary ];
    if (self.questionType == QuestionResultExamination) {
        dic[@"type"] = @"考试";
        
    }else{
        dic[@"type"] = @"练习";
        
    }
    
    dic[@"QuestionId"] = [NSString stringWithFormat:@"%@" , model.QuestionId];
    
    
    [TongJiTool XYWYClickEvent:TongJiToolShareQuestion attributes:dic ];

    
    
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    NXShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"NXShareView" owner:nil options:nil] firstObject];
    shareView.delegate = self;
    UIImage *shareImage = [shareView getImageFromView:self.questionShareView];
    //    UIImage *thumbImage = [UIImage imageNamed:@"share_qq_HY"];
    //    shareView.thumbImage = thumbImage;
    shareView.shareImage = shareImage;
    
    [shareView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [keyWindows addSubview:shareView];
    
    NSLog(@"%@ %s" , [self class] , __func__);

}


-(void)showAnswerSheetView
{
    self.SheetView.dataSource = self.dataSource;
    
    CGFloat  y = 0.0;
    
    if (self.SheetView.y > 0) {
        
        
        self.customNavigationBar.isHiddenShare = NO;
        self.customNavigationBar.isHiddenCollection = NO;

        y =NAVIGATION_HEIGH - SCREEN_HEIGHT;
    }else{
    
        y = NAVIGATION_HEIGH;
        
        self.customNavigationBar.isHiddenShare = YES;
        self.customNavigationBar.isHiddenCollection = YES;
        
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.SheetView.y =y;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    [self.view bringSubviewToFront:self.SheetView];


}

-(AnswerSheetView *) SheetView
{

    if (!_SheetView ) {
        _SheetView = [[AnswerSheetView alloc] initWithFrame:CGRectMake(0, NAVIGATION_HEIGH - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGH )];
        [self.view addSubview:_SheetView];
        
        _SheetView.SheetViewDelegate = self;
        
        _SheetView.questionType = self.questionType;
        
        
        
    }
    
    return _SheetView;
    

}


-(void) AnswerSheetView:(AnswerSheetView *) view  isSection:(BOOL) isSection   IndexPath:(NSIndexPath *)indexPath

{
    
    if (!isSection) {
    
        self.QuestionView.scrollToIndexPath = indexPath;
    }
    
    [self showAnswerSheetView];



}

-(void) setScrollToIndexPath:(NSIndexPath *)scrollToIndexPath
{
    self.QuestionView.scrollToIndexPath = scrollToIndexPath;
}




-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:self.customNavigationBar];

}


-(void) setQuestionType:(QuestionResultType)questionType
{
    
    self.isHiddenShare = NO;
    self.isHiddenCollection = NO;
    
    _questionType = questionType;
    
    


}

-(BaseQuestionCell *) questionShareView
{
    if (!_questionShareView) {
        _questionShareView = [BaseQuestionCell QuestionCell ];
        _questionShareView.frame = CGRectMake(0, 200, SCREEN_HEIGHT, 300);
        
        [self.view addSubview:_questionShareView];
        [self.view sendSubviewToBack:_questionShareView];
        
        _questionShareView.hidden = YES;
        
        
    }
    
    return _questionShareView;
    

}


#pragma mark - NXShareViewDelegate

- (void)NXShareView:(NXShareView *)shareView didSelectedItem:(NSInteger)item thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage {
    __weak typeof(self) weakSelf = self;
    
    [weakSelf shareImageToPlatformType:item thumbImage:thumbImage shareImage:shareImage];
}

#pragma mark - 友盟分享
//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    //shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    shareObject.thumbImage = thumbImage;

    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            
            NSArray <QuestionInfo *> * modeArr = self.dataSource[self.currentIndex.section];
            QuestionInfo * model = modeArr[self.currentIndex.item];
            QuestionsApi * api = [QuestionsApi share];
            [api updateShareWithQuestionId:model.QuestionId];

            
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
}




@end
