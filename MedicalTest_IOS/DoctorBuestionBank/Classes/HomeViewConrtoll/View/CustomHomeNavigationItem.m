//
//  CustomHomeNavigationItem.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/31.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "CustomHomeNavigationItem.h"


@interface CustomHomeNavigationItem ()

@property (weak, nonatomic) IBOutlet UIImageView *BackImageView;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *lLable;

@property(nonatomic , assign) NSInteger didNum;

@property (weak, nonatomic) IBOutlet UIButton *lBtn;
@property (weak, nonatomic) IBOutlet UIButton *rBtn;
@property (weak, nonatomic) IBOutlet UIImageView *titleBackImageView;

@end


@implementation CustomHomeNavigationItem

+(instancetype) HomeNavigationItem
{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void) awakeFromNib
{
    [super awakeFromNib ];
    
    self.autoresizingMask = NO;
    self.titleBackView.layer.cornerRadius = 15;
    self.titleBackView.clipsToBounds = YES;
    
    self.didNum = 2;

}


- (IBAction)clickMyBtn {
    
    
    if ([self.delegate respondsToSelector:@selector(CustomHomeNavigationItem:didClickType:)]) {
        
        [self.delegate CustomHomeNavigationItem:self didClickType:CustomHomeNavigationItemClickMy];
    }
    
}

- (IBAction)clickInstructionsMy {
    
    if ([self.delegate respondsToSelector:@selector(CustomHomeNavigationItem:didClickType:)]) {
        
        [self.delegate CustomHomeNavigationItem:self didClickType:CustomHomeNavigationItemClickInstructions];
    }

}
- (IBAction)ClickPractice {
    
    if (self.didNum == 2) {
        return;
    }
    self.didNum = 2;
    
    self.titleBackImageView.image = [UIImage imageNamed:@"homeLType"];
    [self.lBtn  setTitleColor :[UIColor colorFromHexRGB:@"6f80c8"] forState:UIControlStateNormal];
    [self.rBtn  setTitleColor :[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];

   
    
    if ([self.delegate respondsToSelector:@selector(CustomHomeNavigationItem:didClickType:)]) {
        
        [self.delegate CustomHomeNavigationItem:self didClickType:CustomHomeNavigationItemClickPractice];
    }
}

- (IBAction)clickExamination {
    
    if (self.didNum == 1) {
        
        return;
        
    }
    
    self.titleBackImageView.image = [UIImage imageNamed:@"homeRType"];
    [self.lBtn  setTitleColor :[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
    [self.rBtn  setTitleColor :[UIColor colorFromHexRGB:@"6f80c8"] forState:UIControlStateNormal];
    self.didNum = 1;
    
    
    if ([self.delegate respondsToSelector:@selector(CustomHomeNavigationItem:didClickType:)]) {
        
        [self.delegate CustomHomeNavigationItem:self didClickType:CustomHomeNavigationItemClickExamination];
    }
}

//-(void)setHiddenBackImage:(BOOL)hiddenBackImage
//{
//    //self.BackImageView.hidden = hiddenBackImage;
//    
//
//}

@end
