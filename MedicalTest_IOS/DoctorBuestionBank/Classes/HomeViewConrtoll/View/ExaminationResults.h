//
//  ExaminationResults.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/21.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExaminationResults;
@class ResultsModel;



typedef NS_ENUM(NSInteger, ExaminationResultsDidClickType) {

    ExaminationResultseGoToHome,
    ExaminationResultseGoToWrong,
    ExaminationResultseGoToAgain   /**< 再来一次 */
    
};


@protocol ExaminationResultsDelegate <NSObject>

@optional

-(void) ExaminationResults:(ExaminationResults *) view didClickType:(ExaminationResultsDidClickType )type;


@end


@interface ExaminationResults : UIView

+(instancetype)ResultsView;


@property(nonatomic , weak )id<ExaminationResultsDelegate> delegate;

@property(nonatomic , strong)ResultsModel * model;



@end
