//
//  HomeCollectionViewCell.h
//  DoctorBuestionBank
//
//  Created by lc on 16/10/10.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionTopicModel;


@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)NSArray <QuestionTopicModel *> * arr;

@end
