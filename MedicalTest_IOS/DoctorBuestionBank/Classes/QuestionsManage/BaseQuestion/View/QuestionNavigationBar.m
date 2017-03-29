//
//  QuestionNavigationBar.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "QuestionNavigationBar.h"
#import "UIView+NX.h"

@interface QuestionNavigationBar ()

@property (weak, nonatomic) IBOutlet UIButton *NavigationBack;


@property (weak, nonatomic) IBOutlet UIButton *NavigationTitle;
@property (weak, nonatomic) IBOutlet UIButton *NavigationShare;
@property (weak, nonatomic) IBOutlet UIButton *NavigationCollect;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation QuestionNavigationBar


+(instancetype)NavigationBar
{
    
    

    return [[NSBundle mainBundle ] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void)awakeFromNib
{
    [super awakeFromNib ];
    
    //  暂时关闭计时功能
    self.timeLable.hidden = YES;
    
    
    self.autoresizingMask = false;
}

- (IBAction)clickBack {
    
    
    if ([self.delegate respondsToSelector:@selector(QuestionNavigationBar:ClickType:)]) {
        
        [self.delegate QuestionNavigationBar:self ClickType:QuestionNavigationBarClickBack];
        
    }
    
    NSLog(@"%s" , __func__);
    
    
    
}
- (IBAction)clickShare {
    
    if ([self.delegate respondsToSelector:@selector(QuestionNavigationBar:ClickType:)]) {
        
        [self.delegate QuestionNavigationBar:self ClickType:QuestionNavigationBarClickShare];
        
    }
    
    NSLog(@"%s" , __func__);

}

- (IBAction)clcikCollect {
    if ([self.delegate respondsToSelector:@selector(QuestionNavigationBar:ClickType:)]) {
        
        [self.delegate QuestionNavigationBar:self ClickType:QuestionNavigationBarClickCollection];
        
    }
    
    NSLog(@"%s" , __func__);

}

- (IBAction)clickTitleBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(QuestionNavigationBar:ClickType:)]) {
        
        [self.delegate QuestionNavigationBar:self ClickType:QuestionNavigationBarClickTitle];
        
    }
        
    
}

-(void) setTitle:(NSString *)title
{

    _title = title;
    
    [self.NavigationTitle setTitle:title forState:UIControlStateNormal];
    
}


-(void) setIsHiddenShare:(BOOL)isHiddenShare
{
    self.NavigationShare.hidden = isHiddenShare;

}

-(void) setIsCollection:(BOOL)isCollection
{

    if (isCollection) {
        
        [self.NavigationCollect setImage:[UIImage imageNamed:@"NavigationCollectionSelect"] forState:UIControlStateNormal];
        
    }else{
        
        [self.NavigationCollect setImage:[UIImage imageNamed:@"NavigationCollection"] forState:UIControlStateNormal];

    
    }
    
}


-(void) setIsHiddenCollection:(BOOL)isHiddenCollection
{

    [self.NavigationCollect setHidden:isHiddenCollection];

  
    
    
}

-(void) setIsHiddenTitleImage:(BOOL)isHiddenTitleImage
{
    _isHiddenTitleImage = isHiddenTitleImage    ;
    
    if (_isHiddenTitleImage) {
        
        [self.NavigationTitle setImage:nil forState:UIControlStateNormal];
    }else{
        [self.NavigationTitle setImage:[UIImage imageNamed:@"NavigationTitle"] forState:UIControlStateNormal];
        
    }

}


-(void) setIsHiddenBack:(BOOL)isHiddenBack
{

    self.NavigationBack.hidden = isHiddenBack;
    

}

-(void) setIsHiddenTime:(BOOL)isHiddenTime
{
    //  暂时关闭计时功能
//    _isHiddenTime = isHiddenTime;
//    
//    self.timeLable.hidden = isHiddenTime;
    


}

-(void) setTimestr:(NSString *)timestr
{
    self.timeLable.text = timestr;
    

}




@end
