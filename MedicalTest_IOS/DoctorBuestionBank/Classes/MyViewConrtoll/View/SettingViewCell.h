//
//  SettingViewCell.h
//  DoctorBuestionBank
//
//  Created by  on 2016/10/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewData.h"

@interface SettingViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *m_IconImageView;
@property (weak, nonatomic) IBOutlet UILabel *m_TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *m_DetailLabel;

- (void)setCellData:(MyViewData *)data;

@end
