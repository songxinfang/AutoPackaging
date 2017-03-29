//
//  QuestionsApi.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionsApi.h"
#import "QuestionSqlManage.h"
#import "QuestionModel.h"
#import "ExaminationRequirementsConfig.h"
#import "ChoseOneExaminationPaper.h"
#import "RandomOneExaminationPaper.h"
#import "QuestionDataHandleTool.h"

#import <math.h>







static  QuestionsApi  *  QuestionsApiHanle;

@interface QuestionsApi ()

@property(nonatomic , strong) NSDictionary * PARENT_dic;

@property(nonatomic , strong) NSDictionary * PARENT_CATE_dic;

@property(nonatomic , strong) QuestionSqlManage * sqlManage;



@end


@implementation QuestionsApi



+(instancetype) share
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QuestionsApiHanle = [[QuestionsApi alloc] init];
        
    });
    

    return QuestionsApiHanle;
    
}


-(instancetype) init
{
    self = [super init ];
    
    if (self) {
        
        _sqlManage = [QuestionSqlManage share];
        
        NSDictionary * dic = [self.sqlManage  selectAllInfoFrom_CATEGORY ];
        
        _PARENT_dic = dic[@"PARENT"];
        _PARENT_CATE_dic = dic[@"CATEGORY"];

        
    }
    
    return self;
    

}

-(NSArray <QuestionLevelModel *> * )  QuestionsLevel
{
    
    NSArray * arr = [self.sqlManage LevelModelArr];
    
    
    for (QuestionLevelModel * model  in arr) {
        
       
        
        NSArray * arr = [model.LevelName componentsSeparatedByString:@"章"];
        model.LevelName  = arr.lastObject;
         model.LevelName = [model.LevelName stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
        
        
        model.type =arc4random()%13;
        
    }
    
    return arr;
    
    
}

-(NSArray <QuestionLevelModel *> * )  QuestionsLevelContenchapter
{
    
    NSArray * arr = [self.sqlManage LevelModelArr];
    
    return arr;
    
    
}




-(NSArray <QuestionTopicModel *> * )  QuestionsTopicWithLevelModel:(QuestionLevelModel *) levelModel ;
{
    
    
    NSArray * arr = [self.sqlManage  QuestionsTopicWithLevelId:levelModel.LevelId];
    
    NSMutableArray * outArr = [NSMutableArray array];
    
    
    for (QuestionTopicModel * model in arr) {
        
        
       
        
        if ([model.TopicId isEqualToString:@"102"]) {
            
            NSLog(@"222");
        }
        
        if ([levelModel.LevelId isEqualToString:@"102"]) {
            NSLog(@"33");
            
        }
        
        NSInteger count =  [self.sqlManage countTopicWithType:model.TopicId];
        model.AllCount = count;
        model.CompleteCount = [self.sqlManage completeCountTopicWithType:model.TopicId];
        model.correctCount = [self.sqlManage    correctCountTopicWithType:model.TopicId];
        
        
        if(model.correctCount > 0){
            NSLog(@"444");
        
        }

        levelModel.CompleteCount = levelModel.CompleteCount + model.CompleteCount;
        levelModel.correctCount = levelModel.correctCount + model.correctCount;
        levelModel.AllCount = levelModel.AllCount + model.AllCount;
        
        
        model.type = [QuestionDataHandleTool getTopicTypeWithCompleteCount:model.CompleteCount withCorrectCount:model.correctCount allCount:model.AllCount];
        
        
            
        
        if (model.AllCount > 0) {
            [outArr addObject:model];

        }
    }
    
    
    levelModel.type = [QuestionDataHandleTool getTopicTypeWithCompleteCount:levelModel.CompleteCount withCorrectCount:levelModel.correctCount allCount:levelModel.AllCount];
    
    
    return [outArr copy];
    

    

}

-(void)examinationInfoWithQuestionLevelModel:(QuestionLevelModel *) model
{
    model.CompleteCount = [self.sqlManage examinationCompleteCountTopicWithType:model.LevelId];

    model.correctCount = [self.sqlManage examinationCorrectCountTopicWithType:model.LevelId];
    

}



/**
 *  题型下面的试题
 *
 *  @param TopicId 题型ID
 *
 */
-(NSArray <QuestionInfo *> * )  QuestionsFromTopic:(NSString *) TopicId type:(QuestionShowType)type

{
    
    return [self.sqlManage selectQuestionWithTopicId:TopicId  type:type];
    

}

-(NSArray <QuestionInfo *> * )  QuestionsAllWithTomidArr:(NSArray *) arr
{
    NSMutableArray * outArr = [NSMutableArray array];
    
    for (QuestionTopicModel * model in arr) {
        
        QuestionShowType type = QuestionAllSpecialty;
        if (model.TopicType == 2) {
            type = QuestionAllpractice;
            
        }
        
        NSArray * arr =  [self.sqlManage selectQuestionWithTopicId:nil  type:type];
        [outArr addObjectsFromArray:arr];
        
        
    }


    return [outArr copy];
    

}


-(NSArray <QuestionInfo *> * )  QuestionsCompleteWithLevelId:(NSString * ) levelId
{
    
    return [self.sqlManage selectQuestionsCompleteWithLevelId:levelId];
    
}


-(NSArray <QuestionInfo *> * )  QuestionsWithType:(QuestionShowType ) type
{
    
    return [self.sqlManage selectQuestionWithTopicId:@"ALLByTime"  type:type];
    

    
}


-(void) updateQuestionsWithModel:(QuestionInfo *) model
{

    return [self.sqlManage updateWithModel:model];
    

}



/**
 *  出一套试卷
 *
 *  @param LevelId  基础综合 专业综合 实践综合等的编号
 *
 */


-(NSArray<QuestionInfo *> *)  ExaminationWithLevelId:(NSString * ) LevelId
{
    
    ExaminationRequirementsConfig * config = [[ExaminationRequirementsConfig alloc] init];
    
    
    config.LevelId = LevelId;
    config.OneTopicDryCount = 2;
    config.MoreTopicDryCount = 2;
    config.Fitness = 2.0;
    
    ChoseOneExaminationPaper * paper = [[ChoseOneExaminationPaper alloc] initWihtConfig:config];
    
    return   [paper OneExaminationPaper];

}


-(NSArray<QuestionInfo *> *)  ExaminationWithType:(NSInteger ) type
{
    
    
    ExaminationRequirementsConfig * config = [[ExaminationRequirementsConfig alloc] init];
    
    
    config.type    = type;
    config.OneTopicDryCount = 90;
    config.MoreTopicDryCount = 10;
    config.Fitness = 2.0;
    
    ChoseOneExaminationPaper * paper = [[ChoseOneExaminationPaper alloc] initWihtConfig:config];
    
    return   [paper OneExaminationPaper];


}




-(NSArray < NSArray <QuestionInfo *> * > * ) practiceExaminationWithLevelModelArr:(NSArray  <QuestionTopicModel*> *) TopicModelArr  LevelId:(NSString *) LevelId
{
    
    PracticeRequirementsConfig * config = [[PracticeRequirementsConfig alloc] init];
    config.QuestionCount = 60;
    config.TopicModelArr = TopicModelArr;
    config.LevelId = LevelId;
    
    RandomOneExaminationPaper  * paper = [[RandomOneExaminationPaper alloc] initWihtConfig:config];
    
    NSArray < NSArray <QuestionInfo *> * > *  outArr =[paper OneExaminationPaper];
    
    
    NSMutableArray * idArr = [NSMutableArray array];
    
    for (NSArray * arr in outArr) {
        
        for (QuestionInfo * model in arr) {
            
            [idArr addObject:model.QuestionId];
        }
        
    }

    
    // 保存卷子信息
    [self.sqlManage insertExaminationWithUserId:@"0" QuestionIdArr:[idArr copy] Level:LevelId withType:0] ;
    
    return outArr;
    
    
    


}


-(NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> *  ) MyWrongQuestion
{

    NSDictionary * dic = [self.sqlManage selectLevelTopicWithType:1];
    return dic;
    
}


/**
 *  我的收藏
 *
 */

-(NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> * ) MyCollectionQuestion
{
    
    
    return [self.sqlManage selectLevelTopicWithType:2];
    
}

-(NSArray<QuestionLevelModel *> * ) MyPracticeRecord
{
    
    NSArray<QuestionLevelModel *> * arr  = [self.sqlManage selectLevelTopicWithTypeByOrder:3];
    
   
    return arr;


}

-(NSArray<QuestionTopicModel *> * ) MyPracticeRecordWithLevelId:(NSString * ) levelId
{
    
    return [self.sqlManage selectLevelId:levelId];
    


}






/**
 *  已经存在的试卷属性
 *
 */

-(NSArray <ExaminationProperty *>* ) existingExaminationProperty
{

    NSArray * arr =  [self.sqlManage selectExistingExaminationProperty];
    
    
    
    NSMutableArray * mArr = [NSMutableArray array];
    
    for (ExaminationProperty  * model in arr) {
        
        BOOL flag = false;
        
        
        if ([model.PaperName hasPrefix:@"专业务实"]) {
            
            flag =  TRUE;
            
        }
        
        if ([model.PaperName hasPrefix:@"实践能力"]) {
            flag =  TRUE;
        }
        
        if (flag) {
            [mArr addObject:model];

            
        }
        
        
        
    }
    
    return [mArr copy];

}

-(NSArray <ExaminationProperty *>* ) existingPracticeExaminationProperty
{

    NSArray * arr =  [self.sqlManage selectExistingExaminationProperty];

    NSMutableArray * mArr = [NSMutableArray array];
    
    for (ExaminationProperty  * model in arr) {
        
        BOOL flag = false;
        
        
        if ([model.PaperName hasPrefix:@"专业务实"]) {
            
            flag =  TRUE;
            
        }
        
        if ([model.PaperName hasPrefix:@"实践能力"]) {
            flag =  TRUE;
        }
        
        if (!flag) {
            [mArr addObject:model];

        }
        
        
    }
    
    return [mArr copy];
    
    



}


/**
 *  根据试卷名次取出一套试卷
 *
 *  @param PaperName 试卷名称
 *
 */

-(NSArray<QuestionInfo *> *)  ExaminationFromPaperName:(NSString * ) PaperName
{
   
    
    return [self.sqlManage    selectExaminationFromPaperName:PaperName];
    
    
}

-(void) updateCollectionWithQuestionId:(NSString *) questionid  status:(NSInteger) status 
{

    return [self.sqlManage updateCollectionWithQuestionId:questionid status:status ];


}

-(void) updateShareWithQuestionId:(NSString *) questionid
{
    return [self.sqlManage updateShareWithQuestionId:questionid ];


}


-(void) clearPracticeRecodeWithModelArr:(NSArray<QuestionTopicModel *> *) modelArr
{
    
    for (QuestionTopicModel * model in modelArr) {
     
        [self.sqlManage clearRecodeWithModel:model];
    }
    
    
    return;
    


}


-(NSArray <QuestionInfo *> *) selectQuestionWithQuestionIdArr:(NSArray *)  questionArr
{
    return  [self.sqlManage  selectQuestionWithQuestionIdArr:questionArr];
    

}



-(void) clearExaminationRecord
{

    return [self.sqlManage   deleteExaminationRecord];
    

}

-(void ) clearPracticeExaminationRecord
{
    
    return [self.sqlManage   deletePracticeExaminationRecord];



}



-(void) clearOneExaminationRecord
{

    return [self.sqlManage   deleteOneExaminationRecord];
    

}

-(void)updateResultModel:(ResultsModel *) model
{
    return [self.sqlManage  updateExaminationResultWithModel:model];
    

}





@end
