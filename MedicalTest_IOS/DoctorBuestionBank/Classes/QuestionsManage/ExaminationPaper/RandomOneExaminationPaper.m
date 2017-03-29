//
//  RandomOneExaminationPaper.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/2.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "RandomOneExaminationPaper.h"
#import "QuestionDataHandleTool.h"

#import "ExaminationRequirementsConfig.h"
#import "QuestionSqlManage.h"

@interface RandomOneExaminationPaper ()

@property(nonatomic , strong) PracticeRequirementsConfig * config;

@end

@implementation RandomOneExaminationPaper

-(instancetype) initWihtConfig:(PracticeRequirementsConfig *)config
{

    self = [super init];
    
    if (self) {
        _config = config;
    }
    
    return self;
    

}


-(NSArray < NSArray <QuestionInfo *> * > * )OneExaminationPaper
{
    // 找出所有的题目
    
    NSMutableArray * questionArr = [NSMutableArray array];
    
    NSInteger count = 0;
    
    for (QuestionTopicModel * model in self.config.TopicModelArr) {
        NSArray <QuestionInfo *> *  arr =  [[QuestionSqlManage share ] selectQuestionWithTopicId:model.TopicId type:QuestionShowAll];
        count = count + arr.count;
        
        [questionArr addObjectsFromArray:arr];
        

    }
    
    NSInteger outCunt = (count > self.config.QuestionCount) ? self.config.QuestionCount :count;
    
    NSMutableArray * outArr = [NSMutableArray array];
    
    for (int i = 0 ; i < outCunt ;i++) { //  随机顺序出题
        
        NSInteger count = questionArr.count;
        NSInteger item = arc4random()%count;
        QuestionInfo * model = questionArr[item];
        [outArr addObject:model];
        [questionArr removeObjectAtIndex:item];
    }
    
    // 把共用题干的题分开
    NSArray * rArr =   [QuestionDataHandleTool separateTopic:outArr];
    
    
    return [rArr copy];
    

}

@end
