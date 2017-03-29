//
//  AnswerSheeSectionView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AnswerSheeSectionView.h"

@interface AnswerSheeSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *completeLable;
@property (weak, nonatomic) IBOutlet UILabel *NoCompleteLable;

@end



@implementation AnswerSheeSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleView)];
    
    [self addGestureRecognizer:tap];
    
    
}

-(void)clickTitleView
{
    
    NSLog(@"%s" , __func__);
    
    if ([self.delegate respondsToSelector:@selector(didClickAnswerSheeSectionView)]) {
        
        [self.delegate  didClickAnswerSheeSectionView   ];
        
    }

}

-(void) setCompleteCount:(NSInteger)completeCount
{

    self.completeLable.text = [NSString stringWithFormat:@"已答  %ld", completeCount];
}

-(void) setNoCompleteCount:(NSInteger)NoCompleteCount
{
    self.NoCompleteLable.text = [NSString stringWithFormat:@"未答  %ld" , NoCompleteCount];

}

@end
