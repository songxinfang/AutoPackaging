//
//  PracticeVC.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/28.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionViewController.h"
#import "BaseController.h"



@interface PracticeVC : BaseQuestionViewController


@property(nonatomic , strong ) NSArray  <QuestionTopicModel*> * TopicModelArr;


-(instancetype) initWithType:(QuestionResultType ) type;


@property(nonatomic , assign) BOOL loadingAnimate;

@property(nonatomic , strong) NSString *LevelId;




@end
