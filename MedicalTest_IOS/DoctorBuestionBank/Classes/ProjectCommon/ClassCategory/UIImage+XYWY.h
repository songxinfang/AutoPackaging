//
//  UIImage+XYWY.h
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/4.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XYWY)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;


@end
