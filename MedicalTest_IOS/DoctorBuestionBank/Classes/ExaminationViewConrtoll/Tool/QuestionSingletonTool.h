//
//  QuestionSingletonTool.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/11/2.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QuestionSingletonTool : NSObject


@property(nonatomic , strong) NSArray < NSArray <QuestionInfo *> *> * dataSource;

@property(nonatomic , assign) QuestionResultType  questionType;



+(instancetype)SingletonTool;


-(void) syncData;

// 上次退出是否完成

-(BOOL ) isComplete;


// 完成
-(void) Complete;


//  未完成的试题
-(NSArray<NSArray<QuestionInfo *> *> *) UnfinishedQuestion;



// 类别选中状态
-(BOOL) isSelectAllWithOrder:(NSInteger) order;


-(void) setSelectAllWithOrder:(NSInteger) order withStatus:(BOOL) status;



-(BOOL)ExaminationType;




@end
