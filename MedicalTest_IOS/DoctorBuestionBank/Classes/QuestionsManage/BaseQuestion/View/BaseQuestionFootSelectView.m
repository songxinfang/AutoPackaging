//
//  BaseQuestionFootSelectView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/11.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionFootSelectView.h"

@interface BaseQuestionFootSelectView ()

@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@end


@implementation BaseQuestionFootSelectView


+(instancetype) FootSelectView
{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
}

-(void) awakeFromNib
{

    [super awakeFromNib ];
    self.preBtn.layer.cornerRadius = 5;
    self.preBtn.clipsToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    self.nextBtn.clipsToBounds = YES;
    
    UIColor * colour = [UIColor colorFromHexRGB:@"f6b241"];
    [self.preBtn setBackgroundImage:[UIImage imageWithColor:colour] forState:UIControlStateHighlighted];
    [self.preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.nextBtn setBackgroundImage:[UIImage imageWithColor:colour] forState:UIControlStateHighlighted];
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.PreEnabled = YES;
    self.NextEnabled = YES;
    

    

}


- (IBAction)clickPreBtn:(UIButton *)sender {
    

    if ([self.delegate respondsToSelector:@selector(BaseQuestionFootSelectView:direction:)]) {
        
        [self.delegate BaseQuestionFootSelectView:self direction:false];
    }
    
    
}

- (IBAction)clickNextBtn:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(BaseQuestionFootSelectView:direction:)]) {
        
        [self.delegate BaseQuestionFootSelectView:self direction:true];
    }

}




-(void) setPreEnabled:(BOOL)PreEnabled
{
    self.preBtn.userInteractionEnabled = PreEnabled;

}
-(void) setNextEnabled:(BOOL)NextEnabled
{
    self.nextBtn.userInteractionEnabled = NextEnabled;
    
    if (NextEnabled) {
        
        [self.nextBtn setBackgroundColor:[UIColor whiteColor]];
        
        [self.nextBtn setTitleColor:[UIColor colorFromHexRGB:@"48CF84"] forState:UIControlStateNormal];
        
       
        
    }else{
        
        [self.nextBtn setBackgroundColor:[UIColor colorFromHexRGB:@"fafafa"]];
        [self.nextBtn setTitleColor:[UIColor colorFromHexRGB:@"cccccc"] forState:UIControlStateNormal];
    
    
        

    }
    
}


-(void) setNetTitle:(NSString *)netTitle
{

    [self.nextBtn setTitle:netTitle forState:UIControlStateNormal];

}


@end
