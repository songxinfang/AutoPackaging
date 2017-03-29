//
//  UIBarButtonItem+XYWY.h
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/4.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XYWY)

/**
 *  快速创建一个显示图片的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon size:(CGSize)size target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon size:(CGSize)size;

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title NormalColor :(UIColor *)NormalColor  HighColor :(UIColor *)HighColor UIFontSize:(NSInteger) UIFontsize  target:(id)target action:(SEL)action;



@end
