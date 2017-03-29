//
//  QuestionModel.m
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionModel.h"
#import "NSDate+Category.h"

@implementation QuestionLevelModel


-(NSString *) description
{
    return [NSString stringWithFormat:@"%@  %@" , self.LevelName , self.LevelId];
    

}

- (id)copyWithZone:(nullable NSZone *)zone
{
    
    QuestionLevelModel  * model = [[QuestionLevelModel allocWithZone:zone] init];
    model.LevelName =  [NSString stringWithFormat:@"%@", self.LevelName];
    model.LevelId = self.LevelId;
    model.order = self.order;
    return model;
    
    
    

}



@end


@implementation QuestionTopicModel


-(NSString *) description
{
    return [NSString stringWithFormat:@"name: %@   id: %@ " , self.TopicName , self.TopicId ];
    
    
}

@end


@implementation QuestionInfo


-(instancetype) init
{
    self = [super init];
    
    if (self) {
        _QuestionArr = [[NSMutableArray alloc ] init];
    }
    
    return self;
    

}

-(instancetype) copy
{

    QuestionInfo * newInfo = [[QuestionInfo alloc] init];
    newInfo.type = self.type;
    newInfo.isCollect = self.isCollect;
    newInfo.QuestionId = self.QuestionId;
    
    for (Question * model in self.QuestionArr) {
        
        [newInfo.QuestionArr addObject: [model copy]];
        
        
    }
    
    newInfo.order = self.order;

        
    return newInfo;
    

}

-(NSString *) description
{
    return [NSString stringWithFormat:@"%@  %ld " , self.QuestionId, self.type   ];
    
    
}


@end


@implementation Question

-(NSString *) description
{
    return [NSString stringWithFormat:@"%ld %@ " , self.answerId  , self.AnswerStr];
    

}


-(instancetype) copy
{

    Question * newQuestion = [[Question alloc] init];
    newQuestion.answerId = self.answerId;
    newQuestion.Child_Question = [self.Child_Question copy];
    newQuestion.optionsArr = [self.optionsArr copy];
    newQuestion.AnswerStr =  [self.AnswerStr copy] ;
    newQuestion.CorrectSet = [self.CorrectSet mutableCopy];
    newQuestion.User_SelectSet = [self.User_SelectSet mutableCopy];
    
    newQuestion.User_SelectStatus = self.User_SelectStatus;
    newQuestion.isMakeSure = self.isMakeSure;
    newQuestion.Solution = [self.Solution copy];
    newQuestion.cellHeightDic = [self.cellHeightDic mutableCopy];
    
    newQuestion.isShowDetal = self.isShowDetal;
    newQuestion.Question = self.Question;
    newQuestion.score = self.score;

    
    
    
    
    
    return newQuestion ;
    

}

-(void)clearStatus
{
    self.User_SelectStatus = UserNoneSelect;
    self.isShowDetal = false;
    [self.User_SelectSet removeAllObjects];
    self .isMakeSure = false;
    
    

}

-(NSMutableSet *) User_SelectSet
{
    if(!_User_SelectSet)
    {
        _User_SelectSet = [NSMutableSet set];
    
    }
    
    return _User_SelectSet;
    

}

-(NSMutableSet *)CorrectSet
{
    if (!_CorrectSet) {
        _CorrectSet = [NSMutableSet set];
    }
    
    return _CorrectSet;
    

}

-(NSMutableDictionary *)cellHeightDic
{
    if (!_cellHeightDic) {
        
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    
    return _cellHeightDic;
    

}




@end



@implementation ExaminationProperty
-(NSString *) description
{

    return [NSString stringWithFormat:@"%@ %@" , self.PaperName , self.LevelId];
    
}

- (NSString *)getSimplePaperName
{
    return [[[self PaperName] componentsSeparatedByString:@"|||"] firstObject];
}

- (NSString *)getTimeString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.createTime];
    
    if (date)
    {
        NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:self.createTime];
        if (tempDate.isToday)
        {
            return [NSDate stringFromDate:tempDate formatter:@"HH:mm"];
        }
        else
        {
            return [NSDate stringFromDate:tempDate formatter:@"MM-dd HH:mm"];
        }
    }

    return nil;
}

@end





