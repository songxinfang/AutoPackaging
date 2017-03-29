//
//  QuestionSqlManage.h
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"
#import "ResultsModel.h"



/**
 *  试题属性
 */

@interface QuestionsAttribute : NSObject

@property(nonatomic , strong) NSString *  QuestionId;

@property(nonatomic , strong) NSString *   Cate_Id;
@property(nonatomic , strong) NSString *   Unit_id;
@property(nonatomic , assign) NSInteger  Score;
@property(nonatomic , assign) NSInteger Type;
@property(nonatomic , assign) NSInteger Repeat_Count;
@property(nonatomic , assign) float  Difficulty;
@property(nonatomic , strong) NSString * Point;

//是否做正确
@property(nonatomic , assign) BOOL isCorrect;

//适应度
@property(nonatomic , assign) float  Fitness;


@end


@class QuestionsAttribute;
@class QuestionInfo;
@class QuestionTopicModel;
@class QuestionLevelModel;






@interface QuestionSqlManage : NSObject


+(instancetype) share;



-(NSDictionary *) selectAllInfoFrom_CATEGORY;


-(NSArray *) selectQuestionIdArrWithLevel:(NSString *) level Type:(NSInteger) type ZSType:(NSInteger ) zsType;





/**
 *  根据编号取出一套试卷
 *
 *  @param idArr 数据库数组
 *
 */
-(NSArray  <QuestionsAttribute * >*) selectObjectWithIdArr:(NSArray *) idArr;




/**
 *   取出最终卷子需要显示的信息
 *
 *  @param questionArr 试题id数组
 *
 */
-(NSArray <QuestionInfo *> *) selectQuestionWithQuestionIdArr:(NSArray *)  questionArr;


-(void) ExaminationUserSelectWithPaperName:(NSString *) paperName QuestionInfo:(QuestionInfo *) infoModel;



/**
 *  取出一种类型下面的所有试题
 *
 *
 */
-(NSArray <QuestionInfo *> *) selectQuestionWithTopicId:(NSString *) TopicId type:(QuestionShowType)type;



-(NSArray <QuestionInfo *> *) selectQuestionsCompleteWithLevelId:(NSString *) levelId ;


-(NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> * ) selectLevelTopicWithType:(NSInteger) type;

-(NSArray<QuestionLevelModel *> *) selectLevelTopicWithTypeByOrder:(NSInteger) type;


-(NSArray<QuestionTopicModel *>  * ) selectLevelId:(NSString *) levelId;


-(NSInteger) countTopicWithType:(NSString *) TopicId;

-(NSInteger) completeCountTopicWithType:(NSString *) TopicId;

-(NSInteger) correctCountTopicWithType:(NSString *) TopicId;


-(NSInteger) examinationCompleteCountTopicWithType:(NSString *) TopicId;
-(NSInteger) examinationCorrectCountTopicWithType:(NSString *) TopicId;



//
////层级下面所有练过的
//-(NSInteger) completeCounCountTopicWithlevelId:(NSString *) levelId;



/**
 *  把选出的试题的repetCount字段加一
 *
 */
-(void) updateRepeatCountWithIdArr:(NSArray *) idArr;



/**
 *  保存试卷信息

 *
 *  @param userid 用户ID
 *  @param set    题目集合
 *  @param level  分类ID
 */
-(void) insertExaminationWithUserId:(NSString *) userid QuestionIdArr:(NSArray *) idArr Level:(NSString *) level withType:(NSInteger) type;






-(void) updateWithModel:(QuestionInfo *) model;


-(void) updateCollectionWithQuestionId:(NSString *) questionid status:(NSInteger) status;

-(void) updateShareWithQuestionId:(NSString *) questionid;


-(NSArray <QuestionLevelModel *> * ) LevelModelArr;

-(NSArray <QuestionTopicModel *> * )  QuestionsTopicWithLevelId:(NSString *) LevelId;



-(void  ) clearRecodeWithModel:(QuestionTopicModel *) model;


// 试卷相关

-(void)deleteExaminationRecord;

-(void)deletePracticeExaminationRecord;

-(void) deleteOneExaminationRecord;


-(NSArray <ExaminationProperty *>* )selectExistingExaminationProperty;


-(NSArray<QuestionInfo *> *)  selectExaminationFromPaperName:(NSString * )PaperName;


-(void) updateExaminationResultWithModel:(ResultsModel *) model;



@end
