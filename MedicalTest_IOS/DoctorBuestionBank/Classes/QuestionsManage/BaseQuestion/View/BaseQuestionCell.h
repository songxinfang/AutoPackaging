//
//  BaseQuestionCell.h
//  DoctorBuestionBank
//
//  Created by lc on 16/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@class BaseQuestionCell;

@protocol BaseQuestionCellDelegate <NSObject>

-(void) BaseQuestionCellDidSelect;



@end


@interface BaseQuestionCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)QuestionInfo *model;

@property (nonatomic,assign)int questionNum;


@property(nonatomic , weak) id<BaseQuestionCellDelegate> delegate;

+(instancetype)QuestionCell;


-(void) reloadData;









@end
