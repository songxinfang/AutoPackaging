//
//  PlaceholdTextView.h
//  adult
//
//  Created by shen yan ping on 15/11/5.
//  Copyright (c) 2015年 AiMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TextViewEditStatus) {
    TEXTVIEW_EDIT_BEGIN,//开始编辑
    TEXTVIEW_EDIT_ING,//点击按钮修改中
    TEXTVIEW_EDIT_END,//结束编辑
};


@protocol TextViewChangedDelegate <NSObject>

- (void)textView:(UITextView*)textView status:(TextViewEditStatus)editStatus changed:(NSString*)currentText;

@end

@interface PlaceholdTextView : UITextView<UITextViewDelegate>

@property(nonatomic, assign)id<TextViewChangedDelegate> myDelegate;

@property(nonatomic, retain)UIColor* placeholdColor;
@property(nonatomic, copy)NSString*  placeholdText;
@property(nonatomic, retain)UIColor* inputColor;

@property(nonatomic, assign)BOOL     isShowHolder;

- (instancetype)initWithFrame:(CGRect)frame placeholdText:(NSString*)holdText placeholdColor:(UIColor*)holdColor textColor:(UIColor*)normalColor font:(UIFont*)font;
- (void)buildCurrentText:(NSString*)currentText;
- (NSString*)getCurrentText;//剔除hold
@end
