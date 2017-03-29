//
//  AnswerSheetView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerSheetView;

@protocol AnswerSheetViewDelegate <NSObject>

@optional
-(void) AnswerSheetView:(AnswerSheetView *) view  isSection:(BOOL) isSection   IndexPath:(NSIndexPath *)indexPath;



@end


@interface AnswerSheetView : UIView

@property (nonatomic,strong)NSArray < NSArray <QuestionInfo *> *> * dataSource;

// 是否显示Section

@property(nonatomic , assign) BOOL isShowSectionHeader;
@property(nonatomic , assign) BOOL isExamination;

@property(nonatomic ,assign) QuestionResultType questionType;



@property(nonatomic , weak) id<AnswerSheetViewDelegate> SheetViewDelegate;





@end
