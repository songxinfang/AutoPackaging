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
#import "ExaminationViewConrtoller.h"
#import "QuestionSingletonTool.h"

#import "NXShareView.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "QuestionDataHandleTool.h"
#import "PracticeVC.h"





@interface QuestionResultVC ()<QuestionNavigationBarDelegate , ExaminationResultsDelegate , PracticeResultsDelegate,NXShareViewDelegate>

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
    [tool syncData];

    
    
    
    
    [self setUpNav];
    
    
    if (self.type == QuestionResultPractice) {
        
        self.PracticeResultsView.frame = CGRectMake(0 ,NAVIGATION_HEIGH,SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_HEIGH);
        
        self.PracticeResultsView.model = self.rModel;
        
    }else{
        self.ExaminationResultsView.frame =CGRectMake(0 ,NAVIGATION_HEIGH,SCREEN_WIDTH , SCREEN_HEIGHT - NAVIGATION_HEIGH);
        self.ExaminationResultsView.model = self.rModel;
       
        

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
        view.title = @"练习结果";


    }else if(self.type == QuestionResultExamination){
        view.title = @"考试成绩";

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
        
    
    }else if (type == ExaminationResultseGoToAgain) { //  再来一次 随堂测试
       
        
        [QuestionDataHandleTool clearDataStatusWithData:self.dataSource];
        
        PracticeVC * vc = [[PracticeVC alloc] initWithType:self.type];
        vc.popToRoot = YES;
        
        vc.loadingAnimate = false;
        vc.dataSource = self.dataSource;
        [self.navigationController   pushViewController:vc animated:YES];
        
        
    }

}

//  再来一次
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
            
            ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc]initWithType:ExaminationWrongReview];
            
            vc.dataSource = [mArr copy];
            
            
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            [MBProgressHUD showSuccess:@"没有错题"];
            
            
        }
        
 
    }else if (type == PracticeResultsGoToAgain) {  // 再来一次 练习

        
        [QuestionDataHandleTool clearDataStatusWithData:self.dataSource];
        
        
        ExaminationViewConrtoller * vc = [[ExaminationViewConrtoller alloc] initWithType:self.type];
        vc.popToRoot = YES;
        
        vc.loadingAnimate = false;
        vc.dataSource = self.dataSource;
        [self.navigationController   pushViewController:vc animated:YES];
        
      

     
   
    }

}


#pragma mark - QuestionNavigationBarDelegate

-(void) QuestionNavigationBar:(QuestionNavigationBar *) view ClickType:(QuestionNavigationBarClickType) type {
   
    
   

    if (type == QuestionNavigationBarClickShare) {  //  完成页 点击 分享
        UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
        NXShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"NXShareView" owner:nil options:nil] firstObject];
        shareView.delegate = self;
        
        UIImage *shareImage;
        
        if (_PracticeResultsView) {
            shareImage = [shareView getImageFromView:self.PracticeResultsView];
            NSLog(@"--- get PracticeResultsView");
        }else if (_ExaminationResultsView)
        {
            shareImage = [shareView getImageFromView:self.ExaminationResultsView];
            NSLog(@"--- get ExaminationResultsView");

        }else
        {
            NSLog(@"分享需要的view不存在");
        }

        
        //    UIImage *thumbImage = [UIImage imageNamed:@"share_qq_HY"];
        //    shareView.thumbImage = thumbImage;
        shareView.shareImage = shareImage;
        
        [shareView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [keyWindows addSubview:shareView];
    
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (self.type == QuestionResultExamination) {
            dic[@"type"] = @"考试结果页";
        }else{
            dic[@"type"] = @"练习结果页";

        }
        
        [TongJiTool XYWYClickEvent:TongJiToolShareResultQuestion attributes:dic ];
    }
    
  
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


-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{

    _dataSource = dataSource;
    
    self.rModel = [QuestionDataHandleTool questionResultsModelWithData:dataSource type:self.type];
    

    if (self.type == QuestionResultExamination) {
        
        [[QuestionsApi share ] updateResultModel:self.rModel];
        
    }
}


-(void) setPaperModel:(ExaminationProperty *)paperModel
{
    
    
    NSArray * arr = [[QuestionsApi share] ExaminationFromPaperName:paperModel.PaperName];
    
    _dataSource =   [QuestionDataHandleTool separateTopic:arr];
    
    [QuestionDataHandleTool changeQuestionStatusWithData:_dataSource];
    
    
    self.rModel = [[ResultsModel alloc ]init];
    self.rModel.Rank = paperModel.ranking;
    self.rModel.TotalNum = paperModel.allCount;
    self.rModel.errNum = paperModel.errCount;
    self.rModel.Scores = paperModel.Person_score;
    
    
    


}



@end
