//
//  ExaminationViewConrtoller.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseController.h"
#import "BaseQuestionViewController.h"


@interface ExaminationViewConrtoller : BaseQuestionViewController

@property(nonatomic , strong ) NSArray  <QuestionTopicModel*> * modelArr;



-(instancetype) initWithType:(QuestionResultType ) type;

@property(nonatomic , assign) BOOL loadingAnimate;







@end
