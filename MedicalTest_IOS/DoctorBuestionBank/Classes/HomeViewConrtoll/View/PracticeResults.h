//
//  PracticeResults.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/21.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PracticeResults;
@class ResultsModel;


typedef NS_ENUM(NSInteger, PracticeResultsDidClickType) {
    
    PracticeResultsGoToHome,
    PracticeResultsGoToWrong,
    PracticeResultsGoToAgain   /**< 再来一次 */
    
};


@protocol PracticeResultsDelegate <NSObject>

@optional

-(void) PracticeResults:(PracticeResults *) view didClickType:(PracticeResultsDidClickType )type;


@end

@interface PracticeResults : UIView


+(instancetype) Results;

@property(nonatomic , weak )id<PracticeResultsDelegate> delegate;

@property(nonatomic , strong)ResultsModel * model;




@end
