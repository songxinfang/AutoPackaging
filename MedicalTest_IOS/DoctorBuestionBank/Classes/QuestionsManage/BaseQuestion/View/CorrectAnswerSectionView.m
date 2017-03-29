//
//  CorrectAnswerSectionView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "CorrectAnswerSectionView.h"

@interface CorrectAnswerSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *IndicateTitleLable;

@property (weak, nonatomic) IBOutlet UIImageView *IndicateImageView;


@end

@implementation CorrectAnswerSectionView


+(instancetype) AnswerSectionView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void) awakeFromNib
{
 
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    
    [self addGestureRecognizer:tap];
    
    
    

}


-(void)clickView
{
    
    
    if ([self.delegate respondsToSelector:@selector(CorrectAnswerSectionView:DidClickWithTag:)]) {
        
        [self.delegate  CorrectAnswerSectionView:self DidClickWithTag:self.tag];
    }

    
}


-(void) setIsUnfold:(BOOL)isUnfold
{
    if (isUnfold) {
        self.IndicateImageView.image = [UIImage imageNamed:@"AnswerIndicateDown"];
        self.IndicateTitleLable.text = @"展开";
    }else{
        
        self.IndicateImageView.image = [UIImage imageNamed:@"AnswerIndicateUp"];

        self.IndicateTitleLable.text = @"详情";
    }
    
    [self layoutIfNeeded];

}



@end
