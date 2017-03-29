//
//  ChoseGroup.h
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QuestionsAttribute;
@class ExaminationRequirementsConfig;
@class  QuestionInfo;


typedef NSDictionary<NSString * , NSArray <QuestionsAttribute * > *> GroupDictionary  ;

@interface ChoseGroup : NSObject


+(instancetype) groupWithConfig:(ExaminationRequirementsConfig *) config;


/**
 *  生存第一代数据或下一代数据
 *
 *  @param dic 为nil时 生存第一代数据  ,否则生成第二代数据
 *
 */
-(GroupDictionary *) ChoseGroupFromDic:(GroupDictionary *) dic;


/**
 *  返回一套试卷
 *  @param questionArr 试题编号
 *
 */

-(NSArray <QuestionInfo *> *) choseQuestionWithQuestionIdArr:(NSArray *)  questionArr;



@end
