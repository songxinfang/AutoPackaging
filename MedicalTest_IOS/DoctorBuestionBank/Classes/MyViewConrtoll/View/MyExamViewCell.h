//
//  MyExamViewCell.h
//  DoctorBuestionBank
//
//  Created by  on 2016/10/18.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyExamViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *m_TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_ScoreIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_ScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *m_RankIcon;
@property (weak, nonatomic) IBOutlet UILabel *m_RankLabel;

@end
