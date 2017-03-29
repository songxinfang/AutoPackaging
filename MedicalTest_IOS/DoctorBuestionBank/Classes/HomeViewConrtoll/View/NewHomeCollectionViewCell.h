//
//  NewHomeCollectionViewCell.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/18.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@interface NewHomeCollectionViewCell : UICollectionViewCell


@property(nonatomic , strong)QuestionLevelModel * model;

@property(nonatomic , assign)CGFloat  duTime;
;


@end
