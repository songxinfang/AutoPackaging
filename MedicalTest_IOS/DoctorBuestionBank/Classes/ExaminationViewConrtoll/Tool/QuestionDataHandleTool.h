//
//  QuestionDataHandleTool.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/3.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResultsModel;


@interface QuestionDataHandleTool : NSObject


+(NSArray < NSArray <QuestionInfo *> * > * ) separateTopic:(NSArray <QuestionInfo *> * ) questionArr;


+(NSInteger) getTopicTypeWithCompleteCount:(NSInteger)completeCount withCorrectCount:(NSInteger )CorrectCount allCount:(NSInteger) count;



+(void) clearDataStatusWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource;


+(ResultsModel *) questionResultsModelWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource type:(QuestionResultType ) type;


+(void) changeQuestionStatusWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource;

+(void) isRingtWithModel:(Question *) model;



@end
