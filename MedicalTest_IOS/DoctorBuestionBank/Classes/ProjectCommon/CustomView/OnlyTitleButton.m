//
//  OnlyTitleButton.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/27.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "OnlyTitleButton.h"

@implementation OnlyTitleButton


-(void) layoutSubviews
{

    [super layoutSubviews];
    
    self.imageView.frame = CGRectZero;
    
    self.titleLabel.size = self.size;
    
    
}


@end
