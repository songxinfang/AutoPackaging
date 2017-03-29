//
//  MyViewCell.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyViewCell.h"

@implementation MyViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *bg = [[UIView alloc] initWithFrame:self.contentView.bounds];
    bg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    self.selectedBackgroundView = bg;
}

- (void)setCellData:(MyViewData *)data
{
    self.m_IconImageView.image = [UIImage imageNamed:data.m_Icon];
    
    self.m_TitleLabel.text = data.m_Title;
}

@end
