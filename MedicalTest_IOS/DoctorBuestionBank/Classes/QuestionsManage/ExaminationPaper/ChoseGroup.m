//
//  ChoseGroup.m
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ChoseGroup.h"
#import "QuestionModel.h"
#import "QuestionSqlManage.h"
#import "ExaminationRequirementsConfig.h"



@interface ChoseGroup ()

@property(nonatomic , strong) ExaminationRequirementsConfig * config;
@property(nonatomic , strong) QuestionSqlManage * sqlManage;



@end


@implementation ChoseGroup

+(instancetype) groupWithConfig:(ExaminationRequirementsConfig *) config
{
    ChoseGroup * group = [[ChoseGroup alloc ] init];
    group.sqlManage  = [QuestionSqlManage share] ;
    
    group.config = config;
    return group;
}


-(GroupDictionary *) ChoseGroupFromDic:(GroupDictionary *) dic{
   
    if (dic == nil) { // 第一代数据
        return  [self firstGeneration];
    }else
    {
        
        return [self laterGenerationWithDic:dic];
    
    }
    
    return nil;
    

}

/**
 *   第一代数据
 */
-(NSDictionary *)firstGeneration
{
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    

    
  //  NSLog(@"%s开始生成第一代群体" , __func__  );
    NSArray * OneTopicArr = [self.sqlManage selectQuestionIdArrWithLevel:self.config.LevelId Type:0 ZSType:self.config.type];
    if (OneTopicArr.count < self.config.OneTopicDryCount) {
        
        NSLog(@"err");
        
        return nil;
        
    }
    
    NSArray * MoreTopicArr = [self.sqlManage selectQuestionIdArrWithLevel:self.config.LevelId Type:1 ZSType:3];


    NSInteger OneTopicDryCoun =self.config.OneTopicDryCount;
    NSInteger MoreTopicDryCount= self.config.MoreTopicDryCount;
    
    if (!MoreTopicArr) { // 没有共用题干的试题
        OneTopicDryCoun = OneTopicDryCoun + MoreTopicDryCount;
        MoreTopicDryCount = 0;
        
    }else{
        if (MoreTopicArr.count < MoreTopicDryCount) {
            
            OneTopicDryCoun = OneTopicDryCoun + MoreTopicDryCount -MoreTopicArr.count;
            
            MoreTopicDryCount = MoreTopicArr.count;
            
        }
    
    }
    



    for (int i = 0 ; i < self.config.GenerationGroupCount; i++) {
        
        NSMutableArray  * idArr = [NSMutableArray array];
        
        
        for (int j = 0; j < OneTopicDryCoun   ; j++) {
            
            while (1) { // 去掉重复的
                NSInteger temp = arc4random()%OneTopicArr.count ;
                
                if ([idArr containsObject:OneTopicArr[temp]]) {
                    continue;
                }
                [idArr addObject:OneTopicArr[temp]];
                break;
            }
            
        }

        for (int j = 0; j < MoreTopicDryCount   ; j++) {
            while (1) { // 去掉重复的
                NSInteger temp = arc4random()%MoreTopicArr.count ;
                if ([idArr containsObject:MoreTopicArr[temp]]) {
                    continue;
                }
                [idArr addObject:MoreTopicArr[temp]];
                break;
            }
        }

        
        // 从数据看取出该组数据的属性
        
        NSArray * arr = [self.sqlManage selectObjectWithIdArr:idArr];
       
        // 算出每一道题的适应度和该套卷子的适应度
        
        float Fitness  = [self  computeFitnessWithArr:arr];
        
        NSLog(@"第一代 %lf" , Fitness);
        

        
        NSString * key  = [NSString stringWithFormat:@"%lf" , Fitness];
        
        while ([dic.allKeys containsObject:key]) {
            
            float f = arc4random()%100/100000.0;
            key = [NSString stringWithFormat:@"%lf" , key.floatValue - f];
            
        }
        
        dic[key] = arr;

 
    }
    
    
    NSLog(@"%s第一代群体生成结束" , __func__  );


    return [dic copy];
}


/**
 *  下一代数据
 *
 */
-(NSDictionary  *)laterGenerationWithDic:(GroupDictionary *)dic
{
    
    NSMutableDictionary * outDic = [NSMutableDictionary dictionary];
    
    NSArray * arr = [self choseCanGeneticGroupWith:dic];
    
    
    while (outDic.count < self.config.GenerationGroupCount) {
        
        NSInteger first   = arc4random()%arr.count;
        NSInteger second  = arc4random()%arr.count;
        
        NSArray * childArr =  [self laterGenerationFromAgo:arr[first] mother:arr[second]];

        float Fitness  = [self  computeFitnessWithArr:childArr];

        NSString * key  = [NSString stringWithFormat:@"%lf" , Fitness];
        
        while ([outDic.allKeys containsObject:key]) {
            
            float f = arc4random()%100/100000.0;
            
            key = [NSString stringWithFormat:@"%lf" , key.floatValue - f];
            
        }
        
        outDic[key] = childArr;
        
    }
    
    return [outDic copy];

}


-(NSArray *) laterGenerationFromAgo:(NSArray * ) fatherArr mother:(NSArray *) motherArr
{
    NSMutableArray * childArr = [NSMutableArray array];

    NSInteger count = self.config.OneTopicDryCount + self.config.MoreTopicDryCount;
    
    for (int i = 0 ; i < count; i++) {
        
        QuestionsAttribute * fatherModel = nil;
        if (i > (fatherArr.count -1)) {
            fatherModel = fatherArr.lastObject;
        }else{
            fatherModel = fatherArr[i];
            
        }
        QuestionsAttribute * motherModel = nil;
        
        if (i > (motherArr.count -1)) {
            motherModel = motherArr.lastObject;
        }else{
            motherModel = motherArr[i];
            
        }
        
        
        QuestionsAttribute * childModel  = [self childModelFromFatherModel:fatherModel motherModel:motherModel];
        
        [childArr addObject:childModel];

        
        
    }
    
    return childArr;
    
    
}




// 下一代个体
-(QuestionsAttribute *)childModelFromFatherModel:(QuestionsAttribute *)fatherModel motherModel:(QuestionsAttribute *) motherModel
{
    
    
    NSInteger i = arc4random()%3;
    
    if (i == 0) {
        return fatherModel;
    }else if(i == 1){
    
        return motherModel;
        
    }else{
    
        if (fatherModel.Fitness > motherModel.Fitness) {
            
            return fatherModel;
        }else
        {
            return motherModel;
            
        }
    }

    
}



//选出适合遗传的群体
-(NSArray *) choseCanGeneticGroupWith:(GroupDictionary *)dic
{
    
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:NO selector:@selector(compare:)];
    NSArray * arr =  [dic.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]];
    
    
    float min = [[arr lastObject] floatValue];
    float max = [[arr firstObject] floatValue];
    
    NSInteger count = arr.count;
    
    if ((max/min) > 2.0) {
        count = count -1;
    }
    
    
    NSMutableArray * outArr = [NSMutableArray array];
    
    for (NSString * key  in arr) {
        [outArr addObject:dic[key]];
    }
    
    return [outArr copy];
}



// 算出每一道题的适应度和该套卷子的适应度
-(float) computeFitnessWithArr:(NSArray *)arr
{
    __block  float totalFitness = 0.0;
    
    
    NSMutableDictionary  * pointDic = [NSMutableDictionary dictionary];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        QuestionsAttribute * model = (QuestionsAttribute *) obj;
        [self addPoint:model.Point Dic:pointDic];
        model.Fitness = [self formulaFitnessWithModel:model];
        totalFitness = totalFitness + model.Fitness;
 
    }];
    
    return 1.00*(totalFitness + pointDic.count )/arr.count;
 

}


-(void) addPoint:(NSString * ) point  Dic:(NSMutableDictionary *) dic
{
    
    if (!point) {
        return;
    }
    
    NSArray * arr = [point componentsSeparatedByString:@"|"];
    
    
    for (NSString * key  in arr) {
        
        if ([dic.allKeys containsObject:key]) {
            
            dic[key] = [NSString stringWithFormat:@"%ld" ,[dic[key] integerValue] +1];
    
        }else
        {
            dic[key] = [NSString stringWithFormat:@"%d" ,0];

        
        }
        
        
    }
    
}




/**
 *  适应度公式
 *
 */
-(float) formulaFitnessWithModel:(QuestionsAttribute *) model
{

    float multiple = 1.0;
    
//    if (model.Repeat_Count > 0) {
//        
//        if (model.isCorrect) {
//            multiple = multiple/model.Repeat_Count;
//        }else{
//            model.isCorrect = 1.2;
//        }
//    }
    
    model.Fitness = model.Difficulty * multiple;
    

    return 0;
    

}


/**
 *  返回一套试卷
 *  @param questionArr 试题编号
 *
 */

-(NSArray <QuestionInfo *> *) choseQuestionWithQuestionIdArr:(NSArray *)  questionArr
{
    
    NSArray * arr = [self.sqlManage    selectQuestionWithQuestionIdArr:questionArr];
    
    

    
    NSMutableArray * idArr = [NSMutableArray array];
    
    
    for (QuestionInfo * infoModel in arr) {
        
        [idArr addObject:infoModel.QuestionId];
        
    }
    
    
   [self.sqlManage  updateRepeatCountWithIdArr:[idArr copy]];
    
    
  
    
    // 保存卷子信息
    NSString * LevelId =  self.config.LevelId;
    [self.sqlManage insertExaminationWithUserId:@"0" QuestionIdArr:[idArr copy] Level:LevelId withType:self.config.type];
    

    
    
    return  arr;
    
    
    

}



@end
