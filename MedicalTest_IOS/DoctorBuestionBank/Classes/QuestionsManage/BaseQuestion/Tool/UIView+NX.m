//
//  UIView+NX.m
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/11/18.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "UIView+NX.h"

@implementation UIView (NX)

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
