//
//  RandomOneExaminationPaper.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/2.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PracticeRequirementsConfig;

@interface RandomOneExaminationPaper : NSObject



-(instancetype) initWihtConfig:(PracticeRequirementsConfig *)config;

-(NSArray < NSArray <QuestionInfo *> * > * )OneExaminationPaper;



@end
