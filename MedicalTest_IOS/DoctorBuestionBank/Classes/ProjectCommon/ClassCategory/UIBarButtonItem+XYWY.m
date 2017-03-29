//
//  UIBarButtonItem+XYWY.m
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/4.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import "UIBarButtonItem+XYWY.h"


@implementation UIBarButtonItem (XYWY)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if([icon isEqualToString:@""]){
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    
    if([highIcon isEqualToString:@""]){
        [button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon size:(CGSize)size target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if([icon isEqualToString:@""]){
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    
    if([highIcon isEqualToString:@""]){
        [button setBackgroundImage:nil forState:UIControlStateHighlighted];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    button.frame = (CGRect){CGPointZero, size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}


+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon size:(CGSize)size;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if([icon isEqualToString:@""]){
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    [button setBackgroundImage:nil forState:UIControlStateSelected];
    button.selected=YES;
    button.enabled=NO;
    button.frame=(CGRect){CGPointZero,size};
    button.exclusiveTouch = YES;
    UIBarButtonItem *item =  [[UIBarButtonItem alloc] initWithCustomView:button];
    item.enabled=NO;
    return item;
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title NormalColor :(UIColor *)NormalColor  HighColor :(UIColor *)HighColor UIFontSize:(NSInteger) UIFontsize  target:(id)target action:(SEL)action
{
    
    UIButton * button = [self customBtnWithTitle:title NormalColor:NormalColor HighColor:HighColor target:target action:action];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:UIFontsize]} context:nil].size;
    
    button.frame =CGRectMake(0, 0, size.width*1.5, size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:button];

}




+(UIButton *) customBtnWithTitle:(NSString *)title NormalColor :(UIColor *)NormalColor  HighColor :(UIColor *)HighColor   target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    
    if (NormalColor) {
        [button setTitleColor:NormalColor forState:UIControlStateNormal];
    }else
    {
        [button setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
        
    }
    
    if (HighColor) {
        [button setTitleColor:HighColor forState:UIControlStateHighlighted];
        
    }
    
   
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    
    return button;
    


}




@end
