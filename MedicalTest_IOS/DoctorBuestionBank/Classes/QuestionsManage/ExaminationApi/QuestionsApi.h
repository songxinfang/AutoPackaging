//
//  QuestionsApi.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"
#import "ResultsModel.h"






@class QuestionLevelModel;
@class QuestionTopicModel;
@class QuestionInfo;
@class MyInfoModel;





@interface QuestionsApi : NSObject

+(instancetype) share;



/************************************************************/
/*            首页需要的接口    */
/************************************************************/


/**
 *  题库的等级分类 如： 基础综合 专业综合 实践综合 等
 *
 */
-(NSArray <QuestionLevelModel *> * )  QuestionsLevel;
-(NSArray <QuestionLevelModel *> * )  QuestionsLevelContenchapter;



/**
 *   等级下面的题型
 *  @param LevelId 等级id
 *
 */

-(NSArray <QuestionTopicModel *> * )  QuestionsTopicWithLevelModel:(QuestionLevelModel *) model ;


-(void)examinationInfoWithQuestionLevelModel:(QuestionLevelModel *) model;


/**
 *  题型下面的试题
 *
 *  @param TopicId 题型ID
 *  @param type    type = QuestionShowAll        取出所有的
                   type = QuestionShowWrong      取出错误的的
                   type = QuestionShowCollection 取出收藏的

 
 *
 */
-(NSArray <QuestionInfo *> * )  QuestionsFromTopic:(NSString *) TopicId  type:(QuestionShowType ) type;



-(NSArray <QuestionInfo *> * )  QuestionsAllWithTomidArr:(NSArray *) arr;



-(NSArray <QuestionInfo *> * )  QuestionsCompleteWithLevelId:(NSString * ) levelId;


/**
 *   不按照题型ID ，取出所有的
 */
-(NSArray <QuestionInfo *> * )  QuestionsWithType:(QuestionShowType ) type;




/**
 *  保存用户选择
 */
-(void) updateQuestionsWithModel:(QuestionInfo *) model;




/************************************************************/
/*            考试需要的接口    */
/************************************************************/



/**
 *  出一套试卷
 *
 *  @param LevelId  基础综合 专业综合 实践综合等的编号
 *
 */

-(NSArray<QuestionInfo *> *)  ExaminationWithLevelId:(NSString * ) LevelId;


-(NSArray<QuestionInfo *> *)  ExaminationWithType:(NSInteger ) type;



-(NSArray < NSArray <QuestionInfo *> * > * ) practiceExaminationWithLevelModelArr:(NSArray  <QuestionTopicModel*> *) TopicModelArr  LevelId:(NSString *) LevelId;





/************************************************************/
/*            我的需要的接口    */
/************************************************************/


//-(NSArray <MyInfoModel *> *) MyHomeInfo;


/**
 *  我的错题
 *
 */

-( NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> *  ) MyWrongQuestion;




/**
 *  我的收藏
 *
 */
-(NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> * ) MyCollectionQuestion;



/**
 *
 * 我的练习纪录
 */

-(NSArray<QuestionLevelModel *> * ) MyPracticeRecord;


-(NSArray<QuestionTopicModel *> * ) MyPracticeRecordWithLevelId:(NSString * ) levelId;






/**
 *  已经存在的试卷属性
 *
 */
-(NSArray <ExaminationProperty *>* ) existingExaminationProperty;



-(NSArray <ExaminationProperty *>* ) existingPracticeExaminationProperty;

/**
 *  跟具试卷名次取出一套试卷
 *
 *  @param PaperName 试卷名称
 *
 */
-(NSArray<QuestionInfo *> *)  ExaminationFromPaperName:(NSString * ) PaperName;



/**
 *  收藏
 *
 *  @param questionid 试题ID
 *  @param status     0 取消收藏  1 收藏
 */

-(void) updateCollectionWithQuestionId:(NSString *) questionid status:(NSInteger) status ;

-(void) updateShareWithQuestionId:(NSString *) questionid ;




/**
 *  清楚练习纪录
 *
 */
-(void) clearPracticeRecodeWithModelArr:(NSArray<QuestionTopicModel *> *) modelArr;



/**
 *   取出最终卷子需要显示的信息
 *
 *  @param questionArr 试题id数组
 *
 */
-(NSArray <QuestionInfo *> *) selectQuestionWithQuestionIdArr:(NSArray *)  questionArr;



-(void) clearExaminationRecord;

-(void ) clearPracticeExaminationRecord;


-(void) clearOneExaminationRecord;

-(void)updateResultModel:(ResultsModel *) model;



@end
