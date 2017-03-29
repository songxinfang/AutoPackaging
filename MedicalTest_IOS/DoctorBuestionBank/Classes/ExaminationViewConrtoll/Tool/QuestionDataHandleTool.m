//
//  QuestionDataHandleTool.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/3.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionDataHandleTool.h"
#import "ResultsModel.h"


@implementation QuestionDataHandleTool

+(NSArray < NSArray <QuestionInfo *> * > * ) separateTopic:(NSArray <QuestionInfo *> * ) questionArr
{
    NSMutableArray * oneArr = [NSMutableArray array];
    NSMutableArray * MoreArr = [NSMutableArray array];
    NSMutableArray * outArr = [NSMutableArray array];
    
    
    for (QuestionInfo  * model in questionArr) {
        
        NSString * type = [NSString stringWithFormat:@"%ld" , model.type];
        
        if (type.integerValue == 1) {
            [MoreArr addObject:model];
            
        }else{
            [oneArr addObject:model];
            
            
        }
        
    }
    
    if (oneArr.count > 0) {
        [outArr addObject:[oneArr copy]];
    }
    
    if (MoreArr.count > 0) {
        [outArr addObject:[MoreArr copy]];
        
    }
    

    return [outArr copy];
    


}

+(NSInteger) getTopicTypeWithCompleteCount:(NSInteger)completeCount withCorrectCount:(NSInteger )CorrectCount allCount:(NSInteger) allCount
{
    
  
    if (completeCount == 0) {
        return 0;
    }
    
    
    
    CGFloat offset = 10;
    CGFloat logParam = 2;
    CGFloat logMax = 100 + offset;
    CGFloat logMin = offset;
    NSInteger levelNum = 13;
    
    NSInteger level = 0;
    
    
    NSInteger completeValue = (NSInteger) ((completeCount*1.0/allCount) * 100);
    NSInteger correctValue = (NSInteger) ((CorrectCount*1.0/allCount) * 100);
    
    NSInteger value = completeValue * correctValue/ 100 + offset;
    
    double maxValue = log(logMax) /log(logParam);
    
    double minValue = log(logMin) /log(logParam);
    double logValue = log(value) / log(logParam);
    
    
    
    level = (NSInteger) (levelNum * (logValue - minValue) / (maxValue - minValue));
    
  
    
    level =  level == levelNum ? levelNum - 1 : level;
    

    return level;
    
    

    
    
}


+(void) clearDataStatusWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource
{
    
    for (NSArray * arr in dataSource) {
        
        for (QuestionInfo *  infoModel in arr) {
            
            infoModel.needSync = NO;
            

            for (Question * model in infoModel.QuestionArr) {
                
                [model clearStatus];
            }
            
        }

        
        
    }
    


    


    return;
    

}

+(ResultsModel *) questionResultsModelWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource type:(QuestionResultType ) type
{
    ResultsModel * rModel = [[ResultsModel alloc] init];
    rModel.paperScore = 0;
    
    for (NSArray * arr in dataSource) {
        
        for (QuestionInfo * infoModel in arr) {
            
            BOOL isAdd = true;
            
            for (Question * model in infoModel.QuestionArr) {
                rModel.paperScore = rModel.paperScore + model.score;
                if (model.User_SelectStatus != UserSelectCorrect) {
                    
                  isAdd = false;
                   
                }else{
                    
                    if (type == QuestionResultExamination) {
                        rModel.Scores = model.score + rModel.Scores;
                    }
                    
                
                }
                
            }
            
            rModel.TotalNum++;
            if (isAdd == false) {
                rModel.errNum++;
                
            }
            
            
        }
        
    }
    
    if (type ==QuestionResultExamination ) {
        rModel.Rank = [self calculateHowGoodWithWrong:(rModel.errNum)];
    }
    
    return rModel;

}

+(NSInteger) calculateHowGoodWithWrong:(NSInteger)wrongs
{
    if(wrongs < 0) {
        return -1;
    }
    if(wrongs == 0) {
        return 1;
    }
    int base = 31;
    NSInteger tmpWrongs = wrongs;
    NSInteger grade;
    int alpha = 1;
    
    if (tmpWrongs % 10 == 0) {
        grade = tmpWrongs / 10;
    } else {
        grade = tmpWrongs / 10 + 1;
    }
    
    int rand = arc4random()%20;
    rand = rand - 10;
    for (int i = 2; i <= grade; i++) {
        alpha = alpha * 2;
    }
    int ret = base * alpha + rand;
    return ret;
}

+(void) isRingtWithModel:(Question *) model
{

    if (model.User_SelectSet.count == model.CorrectSet.count) {
        model.User_SelectStatus = UserSelectCorrect;
        
        for (NSString * str in model.User_SelectSet) {
            
            if (![model.CorrectSet containsObject:str]) {
                
                model.User_SelectStatus = UserSelectWrong;
                break;
            }
        }

        
    }else{
        model.User_SelectStatus = UserSelectWrong;

        return ;
        
    }

}

+(void) changeQuestionStatusWithData:(NSArray < NSArray <QuestionInfo *> *> * )dataSource
{
    

    NSInteger num = 0;
    for (NSArray * arr  in dataSource) {
        
        for (QuestionInfo * infoModel  in arr) {
            num++;
            infoModel.order = num;

            
            for (Question * model in infoModel.QuestionArr) {
                [self isRingtWithModel:model];
                
            }
            
            
        }
        
    }
    

    return ;
    

}


@end
