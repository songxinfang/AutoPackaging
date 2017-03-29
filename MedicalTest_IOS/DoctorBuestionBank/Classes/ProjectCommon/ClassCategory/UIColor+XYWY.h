//
//  UIColor+XYWY.h
//  XunYiWenYao
//
//  Created by xywy—iOS on 15/11/9.
//  Copyright © 2015年 xywy—iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XYWY)

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

- (NSString *) hexString;

+ (UIColor *) colorWithHex:(int)color;
+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha;

+ (UIColor *) colorWithHexString:(NSString *)hexString;
+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;


@end
