//
//  BaseQuestionViewController.h
//  DoctorBuestionBank
//
//  Created by lc on 16/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseController.h"
#import "QuestionModel.h"
#import "BaseQuestionView.h"

@interface BaseQuestionViewController : BaseController <BaseQuestionViewDelegate>

@property(nonatomic , strong) NSArray < NSArray <QuestionInfo *> *> * dataSource;


@property (nonatomic,copy)NSString *navTitle;
@property(nonatomic , assign) NSIndexPath * currentIndex;

@property(nonatomic , weak) BaseQuestionView * QuestionView;

@property(nonatomic ,strong) NSIndexPath * scrollToIndexPath;


@property(nonatomic , assign) BOOL clearQuestionStatus;



-(instancetype) initWithType:(QuestionResultType) type;



@property(nonatomic , assign) BOOL popToRoot;








@end
