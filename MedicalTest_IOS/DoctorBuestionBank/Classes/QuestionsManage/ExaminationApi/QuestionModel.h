//
//  QuestionModel.h
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GradeTabView.h"


typedef NS_ENUM(NSInteger,ComprehensiveType ) {
    
    BaseComprehensive ,           //基础综合
    ProfessionalComprehensive ,   //专业综合
    PracticeComprehensive        //实践综合
    
    
};

typedef NS_ENUM(NSInteger,MyQuestionType ) {
    
    MyWrongTopic ,           //我的错题
    MySimulationTest,        // 模拟试题
    MyCollection            //我的收藏
    
    
};

typedef NS_ENUM(NSInteger,QuestionShowType ) {
    
    QuestionShowAll ,                 // 所有试题
    QuestionShowWrong,                // 错题
    QuestionShowCollection ,           //我的收藏
    QuestionShowShare ,           //我的分享
    QuestionComplete   ,           // 完成的
    
    QuestionAllSpecialty ,            // 专业
    QuestionAllpractice             // 实践


    
    
    
};

typedef NS_ENUM(NSInteger,UserSelectStatus ) {
    
    UserNoneSelect ,                 // 未选择
    UserSelectCorrect,                // 回答正确
    UserSelectWrong                  //回答错误
    
    
};






@class Question;



/**
 *  层级
 */
@interface QuestionLevelModel: NSObject <NSCopying>

@property(nonatomic , strong) NSString *LevelName;
@property(nonatomic , strong) NSString *LevelId;
@property(nonatomic , assign) GradeTabType type;

@property(nonatomic , assign) NSInteger levelType;


// add by sxf
@property(nonatomic , assign) NSInteger CompleteCount;

@property(nonatomic , assign) NSInteger correctCount;


@property(nonatomic , assign) NSInteger AllCount;

@property(nonatomic , assign) NSInteger  order;





@end


/**
 *  科目
 */
@interface QuestionTopicModel: NSObject

@property(nonatomic , strong) NSString *TopicName;
@property(nonatomic , strong) NSString *TopicId;

@property(nonatomic , assign) NSInteger TopicType;

@property(nonatomic , assign) NSInteger correctCount;



// 所有的试题数量
@property(nonatomic , assign) NSInteger AllCount;

// 完成的试题数量
@property(nonatomic , assign) NSInteger CompleteCount;





@property(nonatomic , assign) BOOL isSelect;
@property(nonatomic , assign) GradeTabType type;




@end



/**
 * 每一道试题属性
 */
@interface QuestionInfo : NSObject

// 题目类型
@property(nonatomic , assign) NSInteger type;

// 是否收藏
@property(nonatomic , assign) BOOL isCollect;


// 试题编号
@property(nonatomic , strong) NSString * QuestionId;


//// 问题
//@property(nonatomic , strong) NSString * Question;

@property(nonatomic , strong) NSMutableArray<Question *> * QuestionArr;


// 编号  给显示用
@property(nonatomic , assign) NSInteger order;

// 是否需要向数据库同步数据
@property(nonatomic , assign) BOOL needSync;

@end


@interface Question:NSObject




@property(nonatomic , assign) NSInteger answerId;


// 问题
@property(nonatomic , strong) NSString * Question;


// 子问题
@property(nonatomic ,strong) NSString  * Child_Question;

// 答案数组
@property(nonatomic , strong) NSArray * optionsArr;
// 答案字符串
@property(nonatomic , strong) NSString * AnswerStr;

// 正确答案
@property(nonatomic ,strong) NSMutableSet  *  CorrectSet;

// 用户选择
@property(nonatomic ,strong) NSMutableSet  *  User_SelectSet;


//答题状态
@property(nonatomic , assign) UserSelectStatus User_SelectStatus;

//是否确定

@property(nonatomic , assign) BOOL isMakeSure;



// 解释
@property(nonatomic ,strong) NSString  * Solution;

//分值
@property(nonatomic , assign) NSInteger score;


//  下面为显示试用的
// 保存cell的高度
@property(nonatomic , strong) NSMutableDictionary * cellHeightDic;

@property(nonatomic , assign) CGFloat titleHeight;

// 是否显示详情
@property(nonatomic , assign) BOOL isShowDetal;


-(void) clearStatus;





@end


/**
 *  试卷属性
 */

@interface ExaminationProperty : NSObject

//试卷名称
@property(nonatomic , strong) NSString * PaperName;

@property(nonatomic , strong) NSString *LevelId;

@property(nonatomic , assign) NSInteger  PaperScore;
@property(nonatomic , assign) NSInteger  Person_score;
@property(nonatomic , assign) float  Percent;

@property(nonatomic , assign) float createTime;

@property(nonatomic , assign) NSInteger allCount;
@property(nonatomic , assign) NSInteger errCount;



// 排名
@property(nonatomic , assign) NSInteger ranking;

- (NSString *)getSimplePaperName;

- (NSString *)getTimeString;



@end




