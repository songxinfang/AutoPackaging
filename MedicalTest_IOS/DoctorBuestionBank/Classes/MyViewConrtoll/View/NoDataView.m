//
//  NoDataView.m
//  DoctorBuestionBank
//
//  Created by  on 2016/11/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // 添加icon
        UIImage *icon = [UIImage imageNamed:@"myview_nodata"];
        self.noDataImageView = [[UIImageView alloc] initWithImage:icon];
        self.noDataImageView.frame = CGRectMake((frame.size.width - icon.size.width)/2, 150, icon.size.width, icon.size.height);
        [self addSubview:self.noDataImageView];
        
        // 添加label
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.noDataImageView.y+self.noDataImageView.height+15, frame.size.width, 22)];
        self.noDataLabel.textColor = [UIColor colorWithHex:0xCCCCCC];
        self.noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.noDataLabel.font = [UIFont systemFontOfSize:18];
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.noDataLabel];
    }
    
    return self;
}

@end
