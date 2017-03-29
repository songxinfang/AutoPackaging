//
//  MyViewCell.h
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewData.h"

@interface MyViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *m_BGView;
@property (weak, nonatomic) IBOutlet UIImageView *m_IconImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;

- (void)setCellData:(MyViewData *)data;

@end
