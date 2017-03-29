//
//  AnswerSheeSectionView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AnswerSheeSectionViewDelegate <NSObject>

@optional

-(void ) didClickAnswerSheeSectionView;


@end


@interface AnswerSheeSectionView : UICollectionReusableView

@property(nonatomic , weak) id<AnswerSheeSectionViewDelegate> delegate;


@property(nonatomic , assign) NSInteger completeCount;
@property(nonatomic , assign) NSInteger NoCompleteCount;




@end
