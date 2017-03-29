//
//  QuestionSingletonTool.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/2.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionSingletonTool.h"
#import "QuestionDataHandleTool.h"


static QuestionSingletonTool * SingletonToolObj;

#define QYYLLocalFilePath(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName]


#define UserDefaultsDataKey @"UserDefaultsDataKey"
#define UserDefaultsKillPid @"UserDefaultsKillPid"

#define UserDefaultsLastQuestionType @"UserDefaultsLastQuestionType"


@interface QuestionSingletonTool ()

@property(nonatomic , strong) NSMutableDictionary * selectDic;


@end


@implementation QuestionSingletonTool

+(instancetype)SingletonTool
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SingletonToolObj =[[QuestionSingletonTool alloc] init];
        
        
    });
    
    return SingletonToolObj;
    
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        
        _selectDic = [NSMutableDictionary dictionary    ];
        
    }
    
    return self;
    

}


-(void) syncData
{
    
    // 退出的时候先同步数据
    if ((self.questionType == QuestionResultPractice ) || (self.questionType == MyPracticeWrongOrRecord)  ) {
        
        for (NSArray * arr in self.dataSource) {
            for (QuestionInfo * infoModel in arr) {
                
                if (infoModel.needSync) {
                    [[QuestionsApi share] updateQuestionsWithModel:infoModel];
                    infoModel.needSync = NO;
                    
                }
                
            }
            
        }
    }

    
}

-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{
    _dataSource = dataSource;
    

    NSMutableArray * mArr = [NSMutableArray array];
    
    for (NSArray * arr in dataSource) {
        
        NSMutableArray  * cArr = [NSMutableArray array];
        
        
        for (QuestionInfo * model in arr) {
            
            [cArr addObject:model.QuestionId];
            

        }
        
        [mArr addObject:[cArr copy]];
        
    }
    
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    
    [useD setObject:[mArr copy] forKey:UserDefaultsDataKey];
    [useD synchronize];
    
    if ((self.questionType == QuestionResultPractice ) || ( self.questionType == QuestionResultExamination)) {
        [self setBegin];

    }
    

}


-(void) setQuestionType:(QuestionResultType)questionType
{
    _questionType = questionType;
    
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    
    [useD setObject:[NSNumber numberWithInteger:questionType] forKey:UserDefaultsLastQuestionType];
    
    [useD synchronize];

    
    
}


-(NSArray<NSArray<QuestionInfo *> *> *) UnfinishedQuestion
{
    
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    

    
    
    if (self.questionType == QuestionResultExamination) { // 从考试纪录中取出答案
        
        NSString * paperName = [useD objectForKey:UserDefaultsLastExaminationKey];
        
        NSArray * arr = [[QuestionsApi share] ExaminationFromPaperName:paperName];
        
        return  [QuestionDataHandleTool separateTopic:arr];
        
        
        
        
        
    }else{
        
        NSMutableArray * questionArr = [NSMutableArray array];

        NSArray * questionIdArr = [useD objectForKey:UserDefaultsDataKey];
        
        for (NSArray * arr in questionIdArr ) {
            
            NSArray <QuestionInfo *> *  qArr =  [[QuestionsApi share] selectQuestionWithQuestionIdArr:arr];
            
            [questionArr addObject:qArr];
            
            
        }
    
        return [questionArr copy];

    
    }
    
    
    


}



-(void ) setBegin
{
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];

    [useD setObject:@"1" forKey:UserDefaultsKillPid];
    
    [useD synchronize   ];
    
    

}

-(BOOL ) isComplete
{
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    NSString * str = [useD  objectForKey:UserDefaultsKillPid];
    
    self.questionType = [[useD objectForKey:UserDefaultsLastQuestionType] integerValue];

    if (str) {
        return false;
    }
    return true;
    

}

-(void) Complete
{
    
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];

    [useD removeObjectForKey:UserDefaultsKillPid];
    [useD synchronize];

}

-(BOOL) isSelectAllWithOrder:(NSInteger) order
{
    
    NSString * key = [NSString stringWithFormat:@"%ld" , order];

    
    if ([self.selectDic.allKeys containsObject:key]) {
        
        NSNumber * num = self.selectDic[key];
        
        return num.boolValue;
        
        
        
    }else{
        return false;

    }
    
    

}

-(void) setSelectAllWithOrder:(NSInteger) order withStatus:(BOOL) status
{
    NSString * key = [NSString stringWithFormat:@"%ld" , order];

    NSNumber * nub = [NSNumber numberWithBool:status];
    
    self.selectDic[key]  = nub;
    


}


-(BOOL)ExaminationType
{
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];

    NSString * paperName = [useD objectForKey:UserDefaultsLastExaminationKey];

    if ([paperName hasPrefix:@"专业务实"]) {
        
        return TRUE;
        
    }
    
    if ([paperName hasPrefix:@"实践能力"]) {
        return  TRUE;
    }
    
    return false;
    


}


@end
