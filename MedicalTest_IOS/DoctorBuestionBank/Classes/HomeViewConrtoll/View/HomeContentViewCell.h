//
//  HomeContentViewCell.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionLevelModel;



@interface HomeContentViewCell : UICollectionViewCell

@property(nonatomic , strong)NSArray <QuestionTopicModel *> * modelArr;

@property(nonatomic , assign) NSInteger ChapterNum;







@end
