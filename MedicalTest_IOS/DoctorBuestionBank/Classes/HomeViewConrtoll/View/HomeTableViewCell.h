//
//  HomeTableViewCell.h
//  DoctorBuestionBank
//
//  Created by lc on 16/10/8.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionTopicModel;


@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong)QuestionTopicModel *model;

+(instancetype ) cellWithTableView:(UITableView *) tableView;

@end
