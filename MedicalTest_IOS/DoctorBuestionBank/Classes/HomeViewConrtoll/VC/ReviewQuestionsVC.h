//
//  ReviewQuestionsVC.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"


@interface ReviewQuestionsVC : BaseController

@property (nonatomic,strong)NSArray < NSArray <QuestionInfo *> *> * dataSource;


@end
