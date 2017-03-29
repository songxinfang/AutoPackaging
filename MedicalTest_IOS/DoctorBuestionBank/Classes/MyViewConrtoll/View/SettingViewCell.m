//
//  SettingViewCell.m
//  DoctorBuestionBank
//
//  Created by  on 2016/10/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(MyViewData *)data
{
    self.m_IconImageView.image = [UIImage imageNamed:data.m_Icon];
    
    self.m_TitleLabel.text = data.m_Title;
}

@end
