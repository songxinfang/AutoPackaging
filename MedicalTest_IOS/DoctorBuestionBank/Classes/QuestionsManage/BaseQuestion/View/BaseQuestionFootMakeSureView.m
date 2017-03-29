//
//  BaseQuestionFootMakeSureView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/11.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionFootMakeSureView.h"

@interface BaseQuestionFootMakeSureView ()

@property (weak, nonatomic) IBOutlet UIButton *MakeSureBtn;
@property (weak, nonatomic) IBOutlet UILabel *pointLable;

@end

@implementation BaseQuestionFootMakeSureView




-(void)awakeFromNib
{
    
    [super awakeFromNib ];
    
    self.MakeSureBtn.layer.cornerRadius   =5;
    self.MakeSureBtn.clipsToBounds = YES;
    UIColor * colour = [UIColor colorFromHexRGB:@"f6b241"];
    [self.MakeSureBtn setBackgroundImage:[UIImage imageWithColor:colour] forState:UIControlStateHighlighted];
    [self.MakeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.userInteractionEnabled = YES;
    
    

    

}


-(void) setHiddenPoint:(BOOL)HiddenPoint
{

    self.pointLable.hidden = HiddenPoint;
    
}


+(instancetype) FootMakeSureView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}




- (IBAction)clickMakeSureBtn:(UIButton *)sender {
    
    
    NSLog(@"%s" , __func__);
    
    
    if ([self.delegate respondsToSelector:@selector(BaseQuestionFootMakeSureViewDidSelect)]) {
        
        [self.delegate  BaseQuestionFootMakeSureViewDidSelect];
        
    }

    
}

-(void) setTitle:(NSString *)title
{
    _title = title;
    
    [self.MakeSureBtn setTitle:title forState:UIControlStateNormal];

}


-(void) setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    
    if (userInteractionEnabled) {
        
        [self.MakeSureBtn setTintColor:[UIColor colorFromHexRGB:@"f6b241"]];
        
    }else{
        [self.MakeSureBtn setTintColor:[UIColor colorFromHexRGB:@"cccccc"]];
 
    }
    
    

}





@end
