//
//  HomeContentHeaderView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/31.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeContentHeaderView.h"

@interface HomeContentHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *TitleLable;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;

@end

@implementation HomeContentHeaderView


+(instancetype)ContentHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}



- (IBAction)clickAllBtn:(id)sender {
    
  
    [self layoutIfNeeded];
    
    
    if ([self.delegate respondsToSelector:@selector(didClickSelectAllBtn)]) {
        
        [self.delegate didClickSelectAllBtn  ];
        
    }
    
    
}

-(void) setChapterNum:(NSInteger)ChapterNum
{
    self.TitleLable.text = [NSString stringWithFormat:@"( 第%ld章 )", ChapterNum +1];

    
}

-(void) setTitle:(NSString *)title
{
    
    [self.selectAllBtn setTitle:title forState:UIControlStateNormal];
}


@end
