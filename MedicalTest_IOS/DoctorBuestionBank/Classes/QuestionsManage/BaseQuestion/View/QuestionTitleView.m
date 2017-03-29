//
//  QuestionTitleView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionTitleView.h"

@interface QuestionTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;





@end


@implementation QuestionTitleView
{
    CGFloat _viewHeight;

}


+(instancetype)TitleView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}



-(void) awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat f = SCREEN_WIDTH*12.0/375.0;
    self.titleLable.font = [UIFont systemFontOfSize:f];
    
    
    self.titleLable.preferredMaxLayoutWidth = SCREEN_WIDTH - 32;
    
    
    

}

-(void) setTitle:(NSString *)title
{
    _title = title;
    self.titleLable.text = title;
    
    [self.titleLable sizeToFit];
    _viewHeight = self.titleLable.size.height + 32;
    
}



@end
