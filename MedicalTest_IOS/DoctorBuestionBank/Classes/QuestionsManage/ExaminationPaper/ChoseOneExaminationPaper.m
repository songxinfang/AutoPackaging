//
//  ChoseOneExaminationPaper.m
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ChoseOneExaminationPaper.h"
#import "ChoseGroup.h"
#import "ExaminationRequirementsConfig.h"
#import "QuestionSqlManage.h"





static ChoseOneExaminationPaper *  ExaminationPaper;



@interface ChoseOneExaminationPaper ()

@property(nonatomic , strong) NSMutableDictionary * everyGenerationDic; // 保存每一代的最优群里

@property(nonatomic , strong)  ChoseGroup * Group;

@property(nonatomic , strong) ExaminationRequirementsConfig * config;




@end

@implementation ChoseOneExaminationPaper


-(instancetype) initWihtConfig:(ExaminationRequirementsConfig *)config
{
    self = [super init];
    
    if (self) {
        _config = config;
        _Group = [ChoseGroup groupWithConfig:self.config];
        
    }
    
    return self;
    

}


-(NSArray <QuestionInfo *> *)OneExaminationPaper
{
    
    
    NSArray * arr = [self ExaminationPaperContent];
    

    NSMutableArray * questionIdArr =[NSMutableArray array];
    
    
    for (QuestionsAttribute * model in arr) {
        [questionIdArr addObject:model.QuestionId];
    }
    
    
    
    return  [self.Group choseQuestionWithQuestionIdArr:questionIdArr];
    

    
}



-(NSArray *) ExaminationPaperContent
{
    
    NSString * key  = nil;
    

    while (1) {
 
        NSDictionary * dic = nil;
        [self.everyGenerationDic removeAllObjects];

        
        for (NSInteger i = 0; i < self.config.MaxGenerationNum; i++) {
            
            NSLog(@"%s  第%ld代开始" , __func__ , i+1);
            
            // 生成群里
            dic = [self.Group ChoseGroupFromDic:dic];

            
            //  保存群体里面最大的
            float Fitness = [self saveMaxFitnessGroup:dic];
            
            if (Fitness > self.config.Fitness) {
                break;
            }
            NSLog(@"%s  第%ld代适应度%f" , __func__ , i+1 , Fitness);

        }
        
        // 选择最大的
        
        
       key = [self choseMaxFitness:self.everyGenerationDic];
        
        NSMutableSet * mSet = [NSMutableSet set];
        
       for (QuestionsAttribute * model in self.everyGenerationDic[key]) {//  防止应为交换而出现题好相同
           
           [mSet addObject:model.QuestionId  ];
           
        }
        
        if (mSet.count == (self.config.OneTopicDryCount + self.config.MoreTopicDryCount)) {
            break;
            
        }else{
            NSLog(@"%ld" , mSet.count);
            
        }
        
    }
    
        
    return self.everyGenerationDic[key];



}
/**
 *  保存当大适应度最佳的群体
 *
 */
-(float) saveMaxFitnessGroup:(NSDictionary *) dic
{
    
    NSString * key = [self choseMaxFitness:dic];
    
    
    self.everyGenerationDic[key] = dic[key];
    
    return key.floatValue;
    

}

-(NSString *) choseMaxFitness:(NSDictionary *)dic
{
    float maxFitness =  0;
    
    for (NSString * key in dic.allKeys) {
        
        float Fitness = key.floatValue;
        
        if (Fitness > maxFitness) {
            maxFitness = Fitness    ;
        }
        
       // NSLog(@"%f" , Fitness);
    }
    
    NSString *key = [NSString stringWithFormat:@"%f" , maxFitness];
    
    return key;
    
}



-(NSMutableDictionary *) everyGenerationDic
{
    if(!_everyGenerationDic){
    
        _everyGenerationDic = [NSMutableDictionary dictionary   ];
        
    }
    
    return _everyGenerationDic;
    

}

@end
