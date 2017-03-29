//
//  ExaminationRequirementsConfig.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PracticeRequirementsConfig : NSObject

@property(nonatomic , strong) NSArray  <QuestionTopicModel*> * TopicModelArr;

@property(nonatomic , assign) NSInteger QuestionCount;

/**
 *  层级ID
 */
@property(nonatomic , strong) NSString *LevelId;


@end


@interface ExaminationRequirementsConfig : NSObject


/**
 *  层级ID
 */
@property(nonatomic , strong) NSString *LevelId;

@property(nonatomic , assign) NSInteger type;


/**
 *  一道题一个题干的数量
 */
@property(nonatomic , assign) NSInteger OneTopicDryCount;

/**
 *  共用题干的数量
 */

@property(nonatomic , assign) NSInteger MoreTopicDryCount;


/**
 *  适应度
 */

@property(nonatomic , assign) float Fitness ;




/**
 *  最大迭代代数 , 默认5代
 */
@property(nonatomic ,assign) NSInteger MaxGenerationNum;

/**
 *  每一代的群里数量 , 默认为4个群里
 */
@property(nonatomic  , assign) NSInteger GenerationGroupCount;







@end
