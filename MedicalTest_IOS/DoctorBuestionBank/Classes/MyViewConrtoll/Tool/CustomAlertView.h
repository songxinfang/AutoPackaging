//
//  CustomAlertView.h
//  DoctorBuestionBank
//
//  Created by  on 2016/10/20.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CustomAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

@interface CustomAlertView : UIViewController

@property (nonatomic, getter = isVisible) BOOL visible;

+ (instancetype)showAlertWithTitle:(NSString *)title;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                        completion:(CustomAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        completion:(CustomAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(CustomAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                        completion:(CustomAlertViewCompletionBlock)completion;

/**
 * @param otherTitles 是包含NSString对象的数组,可以设置为nil.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                        completion:(CustomAlertViewCompletionBlock)completion;


+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                       contentView:(UIView *)view
                        completion:(CustomAlertViewCompletionBlock)completion;

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                buttonsShouldStack:(BOOL)shouldStack
                       contentView:(UIView *)view
                        completion:(CustomAlertViewCompletionBlock)completion;

/**
 * @param otherTitles 是包含NSString对象的数组,可以设置为nil.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                       contentView:(UIView *)view
                        completion:(CustomAlertViewCompletionBlock)completion;

/**
 * 添加一个给出title的button.
 * @param title button
 * @return 返回button的index.
 */
- (NSInteger)addButtonWithTitle:(NSString *)title;

/**
 * 关闭alert
 */
- (void)dismiss;

/**
 * 响应buttonIndex并关闭alert.
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/**
 * 设置点击alert以外的区域是否关闭alert.
 */
- (void)setTapToDismissEnabled:(BOOL)enabled;


@end
