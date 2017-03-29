//
//  CorrectAnswerSectionView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorrectAnswerSectionView;


@protocol CorrectAnswerSectionViewDelegate <NSObject>


-(void) CorrectAnswerSectionView:(CorrectAnswerSectionView *) view DidClickWithTag:(NSInteger) tag;


@end


@interface CorrectAnswerSectionView : UIView

+(instancetype) AnswerSectionView ;



@property(nonatomic , weak) id<CorrectAnswerSectionViewDelegate> delegate;

/**
 *  是否展开
 */
@property(nonatomic , assign) BOOL isUnfold;



@end
