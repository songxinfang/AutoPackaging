//
//  AnswerBreakDownCell.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Question;


@interface AnswerBreakDownModel : NSObject

@property(nonatomic , strong) NSString * answerStr;
@property(nonatomic , strong) NSString * optionsStr;


@end


@interface AnswerBreakDownCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *) tableView;

@property(nonatomic , strong) Question * model;


@property(nonatomic , strong) NSIndexPath  *indexPath;







@end
