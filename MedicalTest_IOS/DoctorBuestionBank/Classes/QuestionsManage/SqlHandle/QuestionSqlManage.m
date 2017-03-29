//
//  QuestionSqlManage.m
//  QuestionBank
//
//  Created by 杨强 on 16/9/5.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionSqlManage.h"
#import "QuestionModel.h"
#import <FMDB.h>
#import "NSData+AES256.h"



static NSMutableDictionary * decodeDic;


typedef NS_ENUM(NSInteger,SqlManageStatus ) {
    
    SqlManagePaperExamination ,                 // 考试
    SqlManagePaperMyExamination ,                 // 我的考试
    SqlManagePaperPractise ,                   // 练习
    SqlManageMyShare,                         // 我的分享
    SqlManageMyCollection ,                   // 我的收藏
    SqlManageMyWrong,                          // 我的错题
    SqlManageAllMyCollection ,                   // 我的收藏
    SqlManageMyComplete,                  // 我的完成
    SqlManagesprint                  // 考前冲刺


    

};



#define QuestionUnitZhuan @"\"Z\""
#define QuestionUnitShijian @"\"S\""






@implementation QuestionsAttribute


-(NSString *) description
{

    return [NSString stringWithFormat:@"question_id %@  Difficulty %f  %@" , self.QuestionId , self.Difficulty , self.Point];
    
}



@end


#define  CATEGORY_Table_Name  @"CATEGORY"

static QuestionSqlManage * SqlManage;


@interface QuestionSqlManage  ()

@property(nonatomic , strong) FMDatabaseQueue * sqlDb;


@property(nonatomic , strong) NSDictionary *CATEGORY_dic;
@property(nonatomic , strong) NSDictionary * Level_dic;

@property(nonatomic , assign) SqlManageStatus  ManageStatus;


// 一级名
@property(nonatomic , strong) NSArray * firstNameArr;

// 一级名对应的一级ID
@property(nonatomic , strong) NSDictionary * firstNameToFirstId;


// 一级民名对应的二级名数组
@property(nonatomic , strong) NSDictionary *firstToSeconName;

// 二级名对应的二级ID
@property(nonatomic , strong) NSDictionary * secondNameToSecondId;


@end

@implementation QuestionSqlManage



+(instancetype) share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SqlManage = [[QuestionSqlManage alloc] init];
        
        decodeDic = [NSMutableDictionary dictionary];

        
    });
    
    return SqlManage;
    

}


-(FMDatabaseQueue * )sqlDb
{
    if (!_sqlDb) {
        
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"bmp.db"];
        
        
        _sqlDb = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        [_sqlDb inDatabase:^(FMDatabase *db) {
            
            NSString * updateSql = [NSString stringWithFormat:@"create table if not exists USER   (id integer primary key autoincrement, User_id text  ,Cate_id text, Unit_id text , Percent  text    , PaperScore text , Person_score text , Paper_Name text UNIQUE ,createTime text  , completeTime  text default NULL  , Question_Answer_Arr text  ,  rank text  , allCount  text , errCount test )" ];
            
            
        
            
            BOOL result  = [ db executeUpdate:updateSql];
            
            if (result) {
                NSLog(@"sql create ok");
                
            }else
            {
                NSLog(@"sql create err");
                
            }
            
            
        }];
        
        
        [_sqlDb inDatabase:^(FMDatabase *db) {
            
            NSString * updateSql = [NSString stringWithFormat:@"create table if not exists USER_Paper_Questio_Answer    (id integer primary key autoincrement, User_id text  ,Paper_Name  text   , QUESTION_ID text , USER_SELECT  text    , IS_RIGHT integer  default 0  ,CompleteTime text  default NULL, foreign key(Paper_Name) references USER(Paper_Name) )" ];
            
            
            
            BOOL result  = [ db executeUpdate:updateSql];
            
            if (result) {
                NSLog(@"sql create ok");
                
            }else
            {
                NSLog(@"sql create err");
                
            }
            
            
        }];
        
        
        
       // [self encryptionDate];


        
    }
    
    
    
    
    return _sqlDb;
    
    
}



-(void)encryptionDate
{
    
    
   
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    
    [_sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * selectStr =@"select _id , CORRECT_ANSWER  from ANSWER";
        
        FMResultSet * rs = [db executeQuery:selectStr];
        
        while (rs.next) {
            
            NSString *  _id = [rs stringForColumn:@"_id"];
            NSString * CORRECT_ANSWER = [rs stringForColumn:@"CORRECT_ANSWER"];
            
            dic[_id] = CORRECT_ANSWER;
            
            
            
        }
        
        
    }];
    
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString * CORRECT_ANSWER = (NSString *)obj;
        CORRECT_ANSWER = [NSData AES256EncryptWithPlainText:CORRECT_ANSWER];
        
        NSString * updateStr = [NSString stringWithFormat:@"update ANSWER set CORRECT_ANSWER = '%@' where _id = %@ " , CORRECT_ANSWER , key];
        
        [_sqlDb  inDatabase:^(FMDatabase *db) {
            
            bool ret = [db executeUpdate:updateStr   ];
            NSLog(@"%d" ,ret);
            
            
            
        }];
        
        
    
        
    }];
        
        
        
        
    

    


}



-(NSDictionary *) selectAllInfoFrom_CATEGORY
{

    
    NSMutableDictionary * PARENT_dic = [NSMutableDictionary dictionary];
    NSMutableDictionary * Level_dic = [NSMutableDictionary dictionary];

    
    NSMutableDictionary * CATEGORY_dic = [NSMutableDictionary dictionary];

    
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        
        FMResultSet *rs =  [db executeQuery:@"select * from CATEGORY order by  PARENT_ID "  ];
        
        while (rs.next) {
            
            NSString * PARENT_ID = [rs stringForColumn:@"PARENT_ID"];
            NSString * CATE_ID = [rs stringForColumn:@"CATE_ID"];
            NSString * CATE_NAME = [rs stringForColumn:@"CATE_NAME"];

            
            if ([PARENT_ID isEqualToString:@"0"]) {
                
                NSMutableDictionary * childDic = [NSMutableDictionary dictionary  ];
                
                CATEGORY_dic[CATE_ID] = childDic;
                PARENT_dic[CATE_NAME] = CATE_ID;
                Level_dic[CATE_ID] =CATE_NAME;
                
                
            }else{
                
                NSMutableDictionary * childDic = CATEGORY_dic[PARENT_ID];
                
                if (childDic) {
                    childDic[CATE_NAME] =CATE_ID;
                }
            
            };
        }

        
    }];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"PARENT"] = PARENT_dic;
    dic[@"CATEGORY"] = CATEGORY_dic;
    
    
    _CATEGORY_dic = CATEGORY_dic;
    _Level_dic = Level_dic;
    
    
 
    
   // [self getFirstOrderName];
    

    return dic;
    
}


-(NSArray <QuestionLevelModel *> * ) LevelModelArr
{
    
    NSMutableDictionary * firstNameToFirstId = [NSMutableDictionary dictionary];
    NSMutableArray * arr = [NSMutableArray array];
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        NSString * selectStr = @"select * from CATEGORY  where PARENT_ID = 0  order by  SORT ";
        FMResultSet *rs =  [db executeQuery:selectStr ];
        
        

        while (rs.next) {
            
            NSString * CATE_ID = [rs stringForColumn:@"CATE_ID"];
            NSString * CATE_NAME = [rs stringForColumn:@"CATE_NAME"];
            NSString * sort = [rs stringForColumn:@"SORT"];

            
            QuestionLevelModel * model = [[QuestionLevelModel alloc] init];
            
            model.LevelId = CATE_ID;
            model.LevelName = CATE_NAME;
            model.order = sort.integerValue;
            

            
            
            // 一极名对应的以及ID
            firstNameToFirstId[CATE_NAME] = CATE_ID;
            
            [arr addObject:model];

            
        }
        
    }];
    
    return [arr copy];
    
    


}

-(NSArray <QuestionTopicModel *> * )  QuestionsTopicWithLevelId:(NSString *) LevelId
{
   

    NSMutableArray * arr = [NSMutableArray array    ];
    

    [self.sqlDb inDatabase:^(FMDatabase *db) {
    
         NSString * selectStr = [NSString stringWithFormat:@"select * from CATEGORY  where PARENT_ID = %@  order by  SORT" , LevelId];
        
        FMResultSet *rs =  [db executeQuery:selectStr ];
        
        while (rs.next) {
            
            
            NSString * CATE_ID = [rs stringForColumn:@"CATE_ID"];
            NSString * CATE_NAME = [rs stringForColumn:@"CATE_NAME"];
            
            QuestionTopicModel * model = [[QuestionTopicModel alloc] init];
            model.TopicId = CATE_ID;
            model.TopicName = CATE_NAME;
            
            [arr addObject:model];
        }
        
        
        
        
        
    }];
    
    return [arr copy];
    
    
}

-(void  ) clearRecodeWithModel:(QuestionTopicModel *) model
{
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
    
        NSString * updateSql = [NSString stringWithFormat:@"update  QUESTION  set USER_SELECT = NULL , CompleteTime = NULL where cate_id = %@ " , model.TopicId];
        
    [ db executeUpdate:updateSql];
        
        

        
        
      
    }];
    
    NSArray <QuestionInfo *> * arr = [self selectQuestionWithTopicId:model.TopicId type:QuestionShowAll];

    for (QuestionInfo * infoModel  in arr) {
        
        NSString * updateAnswer = [NSString stringWithFormat:@"update ANSWER set makesure = 0 where QUESTION_ID = %@ ", infoModel.QuestionId ];
        
        

        [self.sqlDb inDatabase:^(FMDatabase *db) {
            
            [ db executeUpdate:updateAnswer];

        }];
        

        
    }
    
    


}

-(void)deleteExaminationRecord
{
    
    
    [self deleteExaminationRecordWithFlag:true];
    


}

-(void) deleteExaminationRecordWithFlag :(BOOL) flag
{
    NSMutableArray * arr = [NSMutableArray array];
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * selectStr = [NSString stringWithFormat:@"select Paper_Name from USER "];
        
        FMResultSet * ret = [db executeQuery:selectStr];
        
        while (ret.next) {
            
            
            NSString * paperName = [ret stringForColumn:@"Paper_Name"];
            
            
            BOOL f = false;
            
            if ([paperName hasPrefix:@"专业务实"]) {
                
                f = true;
                
            }
            
            if ([paperName hasPrefix:@"实践能力"]) {
                f = true;
            }
            
            if (f == flag) {
                [arr addObject:paperName];
                
            }
            
            
            
        }
        
        
    }];
    
    
    
    for (NSString * paperName in arr) {
        NSString * d1 = [NSString stringWithFormat:@"delete from USER_Paper_Questio_Answer where Paper_Name  =  '%@'" ,  paperName];
        NSString * d2 = [NSString stringWithFormat:@"delete from USER where Paper_Name =  '%@'" ,  paperName];
        
        
        [self.sqlDb inDatabase:^(FMDatabase *db) {
            
            
            [ db executeUpdate:d1];
            [ db executeUpdate:d2];
            
        }];
        
        
    }
    

}

-(void)deletePracticeExaminationRecord
{
    
    [self deleteExaminationRecordWithFlag:false];
    
    


}

-(void) deleteOneExaminationRecord
{
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    NSString * paperName = [useD objectForKey:UserDefaultsLastExaminationKey];

    [self.sqlDb inDatabase:^(FMDatabase *db) {
        NSString * selectStr = [NSString stringWithFormat:@"select completeTime  from USER where Paper_Name = '%@' " , paperName];
        FMResultSet * fRet =  [ db executeQuery:selectStr];
        
        NSString * completeTime = nil;
        
        if (fRet.next) {
            
        completeTime = [fRet stringForColumn:@"completeTime"];
            
            NSLog(@"%@" , completeTime);
            completeTime = [fRet stringForColumn:@"completeTime"];
            
            
        }
        

        if (completeTime.floatValue == 0) {
            NSString * d1 =   [NSString stringWithFormat:@"delete from USER where Paper_Name = '%@' and completeTime  is NULL " , paperName];
            
            BOOL ret =  [ db executeUpdate:d1];
            
            if (ret) {
                NSString * d2 = [NSString stringWithFormat:@"delete from USER_Paper_Questio_Answer where Paper_Name = '%@'" , paperName];
                [db executeUpdate:d2];
                
                
            }
            

            
        }
        
    
        
        
        
    }];
    

}

-(void) updateExaminationResultWithModel:(ResultsModel *) model
{
    
    NSUserDefaults * useD = [NSUserDefaults standardUserDefaults];
    NSString * paperName = [useD objectForKey:UserDefaultsLastExaminationKey];
    NSDate * now = [NSDate  date];
    NSTimeInterval  inter = now.timeIntervalSince1970;
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * str = [NSString stringWithFormat:@"update  USER set rank = %ld  , completeTime = %lf , Person_score = %ld  , allCount = %ld , errCount = %ld where Paper_Name = '%@'" , model.Rank , inter , model.Scores ,  model.TotalNum , model.errNum , paperName ];
        
        NSLog(@"%@" , str);
        
        [db executeUpdate:str];
        

        
    }];



}







-(NSArray *) selectQuestionIdArrWithLevel:(NSString *) level Type:(NSInteger) type ZSType:(NSInteger ) zsType
{
    

    NSMutableArray  * arr = [NSMutableArray array];
    
    NSDictionary * dic = self.CATEGORY_dic[level];
    
    NSMutableString * whereStr = [NSMutableString string];
    
    if(zsType > 0){
    
        NSString * str = nil;
        if (zsType == 1) {
            
              str = [NSString stringWithFormat:@" TYPE = %@  and UNIT = %@  order by  _id " , [NSString stringWithFormat:@"%ld" , type] , QuestionUnitZhuan];
            
        }else if(zsType == 2){
            str = [NSString stringWithFormat:@" TYPE = %@  and UNIT = %@  order by _id " , [NSString stringWithFormat:@"%ld" , type],  QuestionUnitShijian];

        
        }else if(zsType == 3){
            
            str = [NSString stringWithFormat:@" TYPE = %@   order by _id " , [NSString stringWithFormat:@"%ld" , type]];
        
        
        }
        
        whereStr = [NSString stringWithFormat:@"%@" ,str];
        
        
    
    }else{
        
        [dic.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            NSString * str = [NSString stringWithFormat:@"CATE_ID = %@" , obj];
            
            if (idx == 0) {
                
                [whereStr appendFormat:@"TYPE = %@  and ( %@" , [NSString stringWithFormat:@"%ld" , type] ,  str];
                
            }else
            {
                [whereStr appendFormat:@" or %@" , str];
                
                
            }
            
            
        }];
        [whereStr appendFormat:@")" ];

        
    
    
    }
    
   

    

    

    [self.sqlDb inDatabase:^(FMDatabase *db) {
        NSString * selectStr = [NSString stringWithFormat:@"select QUESTION_ID , CATE_ID from QUESTION  where %@" , whereStr];
        
        
        FMResultSet *rs = [db executeQuery:  selectStr];


        while (rs.next) {
            
            NSString * QUESTION_ID = [rs stringForColumn:@"QUESTION_ID"];
            
            [arr addObject:QUESTION_ID];
            
        }
        
    }];
    


    return [arr copy];
    
}




-(NSArray  <QuestionsAttribute * >*) selectObjectWithIdArr:(NSArray *) idArr
{
    __block NSString * whereStr = nil;
    
    [idArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!whereStr) {
            whereStr = [NSString stringWithFormat:@"where QUESTION_ID = %@" , obj];
            
        }else
        {
            whereStr = [NSString stringWithFormat:@"%@ or QUESTION_ID = %@" ,whereStr ,  obj];
        }
        
    }];
    
    
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:idArr.count];
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        NSString * selectStr = [NSString stringWithFormat:@"select QUESTION_ID , CATE_ID , POINT , DIFFICULTY , REPEAT_COUNT, TYPE  from QUESTION %@" , whereStr];
        
        FMResultSet *rs = [db executeQuery:  selectStr];
       
        while (rs.next) {
            
            QuestionsAttribute * model = [[QuestionsAttribute alloc] init];
            model.Repeat_Count = [rs intForColumn:@"REPEAT_COUNT"];
            model.Point = [rs stringForColumn:@"POINT"];
            model.QuestionId   = [rs stringForColumn:@"QUESTION_ID"];
            model.Difficulty  = [rs stringForColumn:@"DIFFICULTY"].doubleValue;
            model.Type = [rs intForColumn:@"TYPE"];
            
            
            
            
            [arr addObject:model];
        }
        
    }];
    
    
    

    return [arr copy];
    
}





-(NSArray <QuestionInfo *> *) selectQuestionWithTopicId:(NSString *) TopicId type:(QuestionShowType)type
{
    
    
    NSString * whereStr = nil;
    
    if ([TopicId isEqualToString:@"ALLByTime"]) {
        
        
        if (type == QuestionShowCollection) {
            
            self.ManageStatus = SqlManageAllMyCollection;
            
            whereStr = @"where a.QUESTION_ID = b.QUESTION_ID   and b.IS_COLLECT = 1 order by b.CompleteTime";
            
            
        }else if(type == QuestionShowWrong){
            
            self.ManageStatus = SqlManageMyWrong;
            
            whereStr = @"where a.QUESTION_ID = b.QUESTION_ID    and  b.IS_RIGHT = 2 order by b.CompleteTime" ;
        
        
        }else if(type == QuestionShowShare){
        
            self.ManageStatus = SqlManageAllMyCollection;
            
            whereStr = @"where a.QUESTION_ID = b.QUESTION_ID and b.IS_SHARE = 1 order by b.CompleteTime" ;
            
        }

        
    }else{
        
        if (type == QuestionShowAll) { // 所有试题
            
            self.ManageStatus = SqlManagePaperPractise;
            
            whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID and b.CATE_ID = %@  and b.UNIT = %@  order by a._id" , TopicId , QuestionUnitZhuan];
        }else if(type == QuestionShowWrong){  // 我的错题
            self.ManageStatus = SqlManageMyWrong;
            
            whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID and b.CATE_ID = %@    and  b.IS_RIGHT = 2 order by b.CompleteTime" , TopicId];
            
            
        }else if(type == QuestionShowCollection){ //  我的收藏
            self.ManageStatus = SqlManageMyCollection;
            
            whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID and b.CATE_ID = %@  and b.IS_COLLECT = 1 order by b.CompleteTime" , TopicId];
            
            
            
        }else if(type == QuestionComplete){
        
            self.ManageStatus = SqlManageMyComplete;
            
            whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID and b.CATE_ID = %@   and b.user_select not NULL order by b.CompleteTime" , TopicId];
        
        }else if(type == QuestionAllSpecialty){
        
              whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID   and b.UNIT = %@  order by a._id" , QuestionUnitZhuan];
        }else if(type == QuestionAllpractice){
            
            whereStr = [NSString stringWithFormat:@"where a.QUESTION_ID = b.QUESTION_ID   and b.UNIT = %@  order by a._id" , QuestionUnitShijian];
        
        
        }
    
    }
    
 
    
    self.ManageStatus = SqlManagePaperPractise;
    
  
    

    return  [self selectQuestionWithWhereStr:whereStr];

}


-(NSArray <QuestionInfo *> *) selectQuestionsCompleteWithLevelId:(NSString *) levelId
{
    
    NSDictionary * dic = self.CATEGORY_dic[levelId];
    
    
    NSMutableArray * outArr = [NSMutableArray array];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        QuestionTopicModel *  TopicModel = [[QuestionTopicModel alloc] init];
        TopicModel.TopicId  = obj;
        TopicModel.TopicName = key;
        

        NSArray * arr =  [self selectQuestionWithTopicId:TopicModel.TopicId type:QuestionComplete  ];
        
        if (arr.count > 0) {
            
            [outArr addObjectsFromArray:arr];
        }
        
        
        
        
    }];
    
    return [outArr copy];
    


}




-(NSArray <QuestionInfo *> *) selectQuestionWithQuestionIdArr:(NSArray *)  questionArr
{
    
    __block NSString * whereStr = nil;
    
    [questionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!whereStr) {
            whereStr = [NSString stringWithFormat:@"where (  a.QUESTION_ID = %@" , obj];
            
        }else
        {
            whereStr = [NSString stringWithFormat:@"%@ or a.QUESTION_ID = %@" ,whereStr ,  obj];
        }
        
    }];
    
    
    
    whereStr = [NSString stringWithFormat:@"%@ ) and  a.QUESTION_ID = b.QUESTION_ID  order by TYPE " , whereStr];
    
    // 保存显示的题目是卷子 还是练习
    
    self.ManageStatus = SqlManagePaperExamination;
    
   
    
    return  [self selectQuestionWithWhereStr:whereStr ];

    
}


-(void ) ExaminationUserSelectWithPaperName:(NSString *) paperName QuestionInfo:(QuestionInfo *) infoModel
{
    
    
    __block NSString * userSelect = nil;
    
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * selectStr = [NSString stringWithFormat:@"select USER_SELECT from USER_Paper_Questio_Answer where  User_id = %d and Paper_Name = '%@'  and QUESTION_ID =  %@" ,0 , paperName ,infoModel.QuestionId ];
        FMResultSet *rs =  [db executeQuery:selectStr];
        
        while (rs.next){
        
            userSelect = [rs stringForColumn:@"USER_SELECT"];
            NSLog(@"%@" , userSelect);
            
        
        
        }
        
    }];
    
    NSMutableDictionary * answerIdDic = [NSMutableDictionary dictionary];

    
    [self handleUserSelect:userSelect Dic:answerIdDic];
    
    for (Question * q in infoModel.QuestionArr) {
        NSString * key = [NSString stringWithFormat:@"%ld" , q.answerId];
        if ([answerIdDic.allKeys containsObject:key]) {
            NSString * selectStr = answerIdDic[key];
            NSArray * arr = [selectStr componentsSeparatedByString:@"|"];
            for (NSString * str in arr) {
                [q.User_SelectSet addObject:str];
            }
            
        }else{
            q.User_SelectSet = nil;
            
        }

    }

    
    
    
    return ;
    
}

-(NSArray <QuestionInfo *> *) selectQuestionWithWhereStr:(NSString *) whereStr
{
    NSMutableArray * arr = [NSMutableArray array];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        
        NSString * selectStr = [NSString stringWithFormat:@"select a._id , a.QUESTION_ID  , a.QUESTION, a.COMMON_QUESTION,    a.ANSWER ,a.CORRECT_ANSWER ,  a.SOLUTION  , a.makesure , b.TYPE  , b.USER_SELECT  , b.SCORE  , b.IS_COLLECT from ANSWER as a inner join QUESTION as b    %@  " , whereStr];
        
        
        
        FMResultSet *rs = [db executeQuery:  selectStr];
        
        NSMutableDictionary * answerIdDic = [NSMutableDictionary dictionary];
        
        while (rs.next) {
            
            
            NSInteger type =  [rs intForColumn:@"TYPE"];
            NSString * questionId = [rs stringForColumn:@"QUESTION_ID"];
            
            Question * q = [[Question  alloc] init];
            q.answerId =  [rs intForColumn:@"_id"];
            q.Child_Question = [rs stringForColumn:@"COMMON_QUESTION"];
            q.AnswerStr = [rs stringForColumn:@"ANSWER"];
            q.isMakeSure = [[rs stringForColumn:@"makesure"] integerValue];
            

            
            NSString * allCorrectStr =[rs stringForColumn:@"CORRECT_ANSWER"];
            
            if ([decodeDic.allKeys containsObject:allCorrectStr]) {
                allCorrectStr = decodeDic[allCorrectStr];
                
            }else{
                
                NSString * decCorrectStr = [NSData AES256DecryptWithCiphertext:allCorrectStr];
                
                decodeDic[allCorrectStr] = decCorrectStr;
                
                allCorrectStr = decCorrectStr;
                

                
                

            }
            
            

            
            
            NSArray * CorrectArr = [allCorrectStr componentsSeparatedByString:@"|"];
            
            for (NSString * correctStr in CorrectArr) {
                
                [q.CorrectSet addObject:correctStr];
                
            }
            
            
            NSString * userSelect = [rs stringForColumn:@"USER_SELECT"];
            

            
            // 主要处理共用题干的试题
            [self handleUserSelect:userSelect Dic:answerIdDic];
            NSString * key = [NSString stringWithFormat:@"%ld" , q.answerId];
            if ([answerIdDic.allKeys containsObject:key]) {
                NSString * selectStr = answerIdDic[key];
                NSArray * arr = [selectStr componentsSeparatedByString:@"|"];
                for (NSString * str in arr) {
                    [q.User_SelectSet addObject:str];
                }
                
            }else{
                q.User_SelectSet = nil;
                
            }
            
            

            q.Solution = [rs stringForColumn:@"SOLUTION"];
            q.score = [rs intForColumn:@"SCORE"];
            q.Question = [rs stringForColumn:@"QUESTION"];

            
        
            BOOL ret =  [dic.allKeys containsObject:questionId];
            
            if (ret) {
                
                
                QuestionInfo * model = dic[questionId];
                [model.QuestionArr addObject:q];
                
                
            }else
            {
                
                QuestionInfo * model = [[QuestionInfo  alloc ] init];
                model.QuestionId = questionId;
                model.type = type;
                model.isCollect =[rs intForColumn:@"IS_COLLECT"] ;
                
                [model.QuestionArr addObject:q];
                
                
                [arr addObject:model];
                
                dic[questionId] = model;
                
                
            }
            
        }
        
    }];
    
    
    
    
    return arr;
    
    
    
    
}


-(void) handleUserSelect:(NSString * ) UserSelect Dic:(NSMutableDictionary *)dic
{

    if (UserSelect && UserSelect.length > 0) {
        
        
        NSArray * arr = [UserSelect componentsSeparatedByString:@"|"];
        
        if (arr && arr.count ) {
            
            for (NSString * str in arr) {
                
                NSArray * temp = [str componentsSeparatedByString:@"="];
                
                if (temp.count == 2) {
                    
                    dic[temp[0]] = temp[1];
                }
            }
        }
    }
    
    
    return;
    

}


-(NSArray<QuestionLevelModel *> *) selectLevelTopicWithTypeByOrder:(NSInteger) type
{

    NSMutableArray * outArr = [NSMutableArray array];
    

    NSArray * arr = [self LevelModelArr];

    for (QuestionLevelModel * LevelModel in arr) {
        
        NSDictionary * dic = self.CATEGORY_dic[LevelModel.LevelId];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSInteger count  = [self selectCountWithTopic:obj  type: type];
            LevelModel.CompleteCount = LevelModel.CompleteCount + count;
    
        }];
        
        if(LevelModel.CompleteCount > 0)
        {
            [outArr addObject:LevelModel];
            
        }
        
        
    }
    
    return [outArr copy];
    

}



-(NSDictionary<QuestionLevelModel * , NSArray<QuestionTopicModel *>  *> * ) selectLevelTopicWithType:(NSInteger) type 
{
    
     NSMutableDictionary * outDic = [NSMutableDictionary dictionary];
    
    NSArray * arr = [self LevelModelArr];
    
    for (QuestionLevelModel * LevelModel in arr) {
        
        NSDictionary * dic = self.CATEGORY_dic[LevelModel.LevelId];
        
        NSMutableArray * TopicModelArr = [NSMutableArray array];
        
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            QuestionTopicModel *  TopicModel = [[QuestionTopicModel alloc] init];
            TopicModel.TopicId  = obj;
            TopicModel.TopicName = key;
            
            NSInteger count  = [self selectCountWithTopic:TopicModel.TopicId  type: type];
            
            TopicModel.CompleteCount = count;
            
            if (count > 0) {
                [TopicModelArr addObject:TopicModel];
            }
            
            
        }];
        
        outDic[LevelModel] = TopicModelArr;
        
    }
    

    
    return outDic;
    
    
    
    
}

-(NSArray<QuestionTopicModel *>  * ) selectLevelId:(NSString *) levelId
{
    
    NSDictionary * dic = self.CATEGORY_dic[levelId];
    
    NSMutableArray * TopicModelArr = [NSMutableArray array];
    
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        QuestionTopicModel *  TopicModel = [[QuestionTopicModel alloc] init];
        TopicModel.TopicId  = obj;
        TopicModel.TopicName = key;
        
        NSInteger count  = [self selectCountWithTopic:TopicModel.TopicId  type: 3];
        TopicModel.CompleteCount = count;
        
        if (count > 0) {
            [TopicModelArr addObject:TopicModel];
        }
        
        
    }];
    
    return [TopicModelArr copy];
    
    


}

-(NSInteger) countTopicWithType:(NSString *) TopicId
{
    
    NSInteger count  = [self selectCountWithTopic:TopicId  type: 4];
    
    return count;
    



}

-(NSInteger) completeCountTopicWithType:(NSString *) TopicId
{
    NSInteger count  = [self selectCountWithTopic:TopicId  type: 5];
    
    return count;


}

-(NSInteger) correctCountTopicWithType:(NSString *) TopicId
{
    
    NSInteger count  = [self selectCountWithTopic:TopicId  type: 6];
    
    return count;
    

}

-(NSInteger) examinationCompleteCountTopicWithType:(NSString *) TopicId
{

    NSInteger count  = [self selectCountWithTopic:TopicId  type: 7];

    
    return count;

}

-(NSInteger) examinationCorrectCountTopicWithType:(NSString *) TopicId
{
    
    NSInteger count  = [self selectCountWithTopic:TopicId  type: 8];
    
    
    return count;
    
}





-(NSInteger) selectCountWithTopic:(NSString *) TopicId type:(NSInteger ) type
{
    
    __block NSInteger count = 0;
    
    
    


    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * selectStr = nil;
        
        if (type == 1) { // 我的错题
            
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where   IS_RIGHT = 2 and CATE_ID = %@" , TopicId ];
            
        }else if(type == 2){// 我的收藏
            
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where   IS_COLLECT = 1  and CATE_ID = %@" , TopicId ];
        
        }else if(type == 3){ // 我的练习
            
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where  USER_SELECT not null  and CATE_ID = %@" , TopicId ];
        }else if(type == 4){ // TopicId 下面所用的
            
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where  CATE_ID = %@ and UNIT = %@", TopicId,  QuestionUnitZhuan];
        }else if(type == 5){// TopicId 下面所用的完成的
        
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where  CATE_ID = %@ and  UNIT = %@ and user_select not NULL" , TopicId  , QuestionUnitZhuan];
        }else if(type == 6){
            
            selectStr = [NSString stringWithFormat:@"select count(*) as count from QUESTION where   IS_RIGHT = 1 and CATE_ID = %@" , TopicId ];
        }else if(type == 7){
        
            NSString * name = nil;
            if ([TopicId isEqualToString:@"Z"]) {
                
                name = @"专业务实|||%";
                
            }else{
                name = @"实践能力|||%";
                

            
            }
            
            selectStr = [NSString  stringWithFormat:@"select count(*) as count from USER_Paper_Questio_Answer where Paper_Name like '%@'" , name];
            
            
        }else if(type == 8){
            NSString * name = nil;
            if ([TopicId isEqualToString:@"Z"]) {
                
                name = @"专业务实|||%";
                
            }else{
                name = @"实践能力|||%";
                
                
                
            }
            
            selectStr = [NSString  stringWithFormat:@"select count(*) as count from USER_Paper_Questio_Answer where Paper_Name like '%@' and IS_RIGHT = 1" , name];
        
        }
            
        
        FMResultSet *rs = [db executeQuery:  selectStr];
        
        while (rs.next) {
            
             NSString  * str = [rs stringForColumn:@"count" ];
            
            
            count = str.integerValue;
            
            
            
            
        }

        
    }];
    
  
    
    
    
    return count;
    


}




/**
 *  把选出的试题的repetCount字段加一
 *
 */
-(void) updateRepeatCountWithIdArr:(NSArray *) idArr
{
    
    __block NSString * whereStr = nil;
    
    
    for (NSString * questionId in idArr) {
       
        if (!whereStr) {
            whereStr = [NSString stringWithFormat:@"where   QUESTION_ID = %@" , questionId];
            
        }else
        {
            whereStr = [NSString stringWithFormat:@"%@ or QUESTION_ID = %@" ,whereStr ,  questionId];
        }
        
    }

    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSString * updateSql = [NSString stringWithFormat:@"update QUESTION set REPEAT_COUNT = (REPEAT_COUNT + 1) %@ ", whereStr];
        
        
       [db executeUpdate:updateSql];
        
    
        
        
        
        
        
    }];
    

    
    

    return;
    

}

-(void) insertExaminationWithUserId:(NSString *) userid QuestionIdArr:(NSArray *) idArr Level:(NSString *) level withType:(NSInteger) type
{
    
    
    NSString * paperName = nil;
    
    NSDate * now = [NSDate  date];
    NSTimeInterval  inter = now.timeIntervalSince1970;
    
    
    if (type == 0) {
        
        paperName = self.Level_dic[level];
        
    }else if(type ==1){
        paperName = @"专业务实";
    
    }else if(type ==2){
        paperName = @"实践能力";


    }
    
    paperName = [NSString stringWithFormat:@"%@|||%lf" , paperName , inter];
    
  
    
    NSUserDefaults * userd = [NSUserDefaults standardUserDefaults];
    [userd setObject:paperName forKey:UserDefaultsLastExaminationKey   ];
    [userd synchronize  ];
    
    self.ManageStatus = SqlManagePaperExamination;


    
    // 在USER中存储 卷子的信息
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        

        
        
        
        [db executeUpdate:@"insert into USER (User_id  , createTime , Cate_id , PaperScore , Paper_Name ) values (?, ?, ? , ? , ?);" , userid  , [NSNumber numberWithDouble:inter] , level , @"100" , paperName ];
        
       
        
        
    }];
    
    
    
    // 保存卷子的试题到卷子属性表中
    
    
    for (NSString * questionId in idArr) {
        
        [self.sqlDb inDatabase:^(FMDatabase *db) {
            
            [db executeUpdate:@"insert into USER_Paper_Questio_Answer (User_id  , Paper_Name , QUESTION_ID  ) values (?, ?, ? );" , userid  ,  paperName , questionId ];
            
         
            
            
            
        }];
        
    }
    

    
    
    return;
    

}


-(NSArray <ExaminationProperty *>* )selectExistingExaminationProperty
{
    
    NSMutableArray * arr = [NSMutableArray array];


    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        NSString * selectStr = [NSString stringWithFormat:@"select Paper_Name , PaperScore , createTime ,Person_score , Cate_id  , Percent  , rank  , allCount , errCount  from USER where User_id = %d"  , 0];
        
        FMResultSet * rs = [db executeQuery:selectStr];
        
        while (rs.next) {
            
            ExaminationProperty * model  = [[ExaminationProperty alloc] init];
            
            model.PaperName = [rs stringForColumn:@"Paper_Name"];
            model.LevelId = [rs stringForColumn:@"Cate_id"];
            model.PaperScore = [[rs stringForColumn:@"PaperScore"] integerValue];
            model.Person_score = [[rs stringForColumn:@"Person_score"] integerValue];
            
          
            model.Percent = [[rs stringForColumn:@"Percent"] doubleValue];

            model.createTime = [[rs stringForColumn:@"createTime"] doubleValue];
            model.allCount = [[rs stringForColumn:@"allCount"] integerValue];
            model.errCount = [[rs stringForColumn:@"errCount"] integerValue];
            
            
            //  随机生成一个排名
            model.ranking = [[rs stringForColumn:@"rank"] integerValue];;
            
            
            [arr addObject:model];
            
            
            
            
        }
        
        
        
        
    }];
    
    
    

    
    return [arr copy];
    
    

}



-(NSArray<QuestionInfo *> *)  selectExaminationFromPaperName:(NSString * )PaperName
{
    
    __block NSMutableArray * questionIdArr = [NSMutableArray array];
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        
        NSString * selectSql = [NSString stringWithFormat:@"select QUESTION_ID from USER_Paper_Questio_Answer  where Paper_Name = '%@'and User_id = 0  order by id" , PaperName];
        
        
        
        FMResultSet * rs = [db executeQuery:selectSql];
        
        while (rs.next) {
            
            NSString * questionId = [rs stringForColumn:@"QUESTION_ID"];
            
            [questionIdArr addObject:questionId];
            
            
            
        }
        
        
        
    }];
    
   
    
    NSUserDefaults * userd = [NSUserDefaults standardUserDefaults];
    [userd setObject:PaperName forKey:UserDefaultsLastExaminationKey   ];
    [userd synchronize  ];
    
    self.ManageStatus = SqlManagePaperMyExamination;
    
    NSArray <QuestionInfo *> * QuestionArr =[self selectQuestionWithQuestionIdArr:questionIdArr];
    
    // 从试卷库中取出用户选择  替换用户选择
    
    for (QuestionInfo * model in QuestionArr) {
        
        [self ExaminationUserSelectWithPaperName:PaperName QuestionInfo:model];
    }
    
    
    
    
    return QuestionArr;
    
    

    

}





-(void) updateWithModel:(QuestionInfo *) model
{
    
    
    NSString * userSelect = nil;
    
    for (Question * qModel in model.QuestionArr) {
        
        
        for (NSString * str in qModel.User_SelectSet) {
            
            if (!userSelect) {
                userSelect = [NSString stringWithFormat:@"%ld=%@" , qModel.answerId , str ];
            }else{
                userSelect = [NSString stringWithFormat:@"%@|%ld=%@" ,userSelect, qModel.answerId , str];
                
            }
            
            NSString * updateAnswer = [NSString stringWithFormat:@"update ANSWER set makesure = %d where _id = %ld ", qModel.isMakeSure , qModel.answerId ];
            
            [self.sqlDb inDatabase:^(FMDatabase *db) {
                
               BOOL  ret   = [db executeUpdate:updateAnswer];
                
                NSLog(@"%d" , ret);
            }];
            


        }

        
    }
    
    userSelect = [NSString stringWithFormat:@"'%@'", userSelect ];
    
    
    
    if (userSelect) {
        
        [self.sqlDb inDatabase:^(FMDatabase *db) {
            
            
            NSString * update = nil;
    
            
            NSDate * now = [NSDate  date];
            NSTimeInterval  inter = now.timeIntervalSince1970;
            
            
            
            
            NSInteger isRight = 1;

            
            // 保存用户的选择
            if((self.ManageStatus == SqlManagePaperExamination) ){
                

                for (Question * QuestionMode  in model.QuestionArr){
                    
                    if (QuestionMode.User_SelectStatus != UserSelectCorrect) {
                        isRight = 2;
                        break;
                        
                    }
                    
                }

               
                NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
                NSString * paperName = [userD objectForKey:UserDefaultsLastExaminationKey];
                update = [NSString stringWithFormat:@"update USER_Paper_Questio_Answer set USER_SELECT = %@   , CompleteTime = %@   , IS_RIGHT = %ld where User_id = %d and Paper_Name = '%@'  and QUESTION_ID =  %@" ,userSelect ,  [NSNumber numberWithDouble:inter] , isRight,0 , paperName , model.QuestionId   ];

                
                

            }else{
                update = [NSString stringWithFormat:@"update  QUESTION  set    USER_SELECT = %@  , CompleteTime = %@ where QUESTION_ID = %@ " , userSelect , [NSNumber numberWithDouble:inter] , model.QuestionId ];
                

  
            }
            
            [db executeUpdate:update];
            
         
            
            // 更新答题次数后最后一次的答题结果
            
            
            
           
            isRight = 1;
            if (self.ManageStatus != SqlManagePaperExamination) {
                
                for (Question * QuestionMode  in model.QuestionArr) {
                    
                    if (QuestionMode.User_SelectStatus == UserSelectWrong) {
                        isRight = 2;
                        break;
                        
                        
                    }else if(QuestionMode.User_SelectStatus == UserNoneSelect){
                    
                        isRight = 0;
                        
                    }

        
                    
                    
                }
                
                
                update = [NSString stringWithFormat:@"update  QUESTION set IS_RIGHT = %ld  , CorrectCount = (CorrectCount + 1)  where QUESTION_ID = %@" , isRight ,model.QuestionId ];

               
                
                [db executeUpdate:update];

                

                
            }
            
           

            
        }];
        
    }


}


-(void) updateCollectionWithQuestionId:(NSString *) questionid  status:(NSInteger) status
{
    
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSDate * now = [NSDate  date];
        NSTimeInterval  inter = now.timeIntervalSince1970;
        

        NSString * update = [NSString stringWithFormat:@"update  QUESTION  set IS_COLLECT = %ld  , CompleteTime = %@  where QUESTION_ID = %@" , status, [NSNumber numberWithDouble:inter] ,questionid  ];
        
       
        [db executeUpdate:update];
        
      
        
    }];
}
-(void) updateShareWithQuestionId:(NSString *) questionid
{
    
    [self.sqlDb inDatabase:^(FMDatabase *db) {
        
        NSDate * now = [NSDate  date];
        NSTimeInterval  inter = now.timeIntervalSince1970;
        
        
        NSString * update = [NSString stringWithFormat:@"update  QUESTION  set is_share = 1  , CompleteTime = %@  where QUESTION_ID = %@" , [NSNumber numberWithDouble:inter] ,questionid  ];
        
       [db executeUpdate:update];
        
       
        
    }];


}




@end
