//
//  ChoseOneExaminationPaper.h
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QuestionsAttribute;
@class ExaminationRequirementsConfig;
@class QuestionInfo;



@interface ChoseOneExaminationPaper : NSObject


//
//+(instancetype) share;


-(instancetype) initWihtConfig:(ExaminationRequirementsConfig *)config;



/**
 *
 *  @param config 试题的配置信息
 *
 */

-(NSArray <QuestionInfo *> *)OneExaminationPaper;







@end
