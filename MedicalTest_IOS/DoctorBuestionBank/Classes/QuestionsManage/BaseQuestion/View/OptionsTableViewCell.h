//
//  OptionsTableViewCell.h
//  DoctorBuestionBank
//
//  Created by lc on 16/9/23.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"


@interface OptionsTableViewCell : UITableViewCell

@property (nonatomic,strong)QuestionInfo *model;
@property (nonatomic,assign)NSIndexPath *indexPath;
@property(nonatomic , assign) NSInteger index;




+(instancetype ) cellWithTableView:(UITableView *) tableView;







@end
