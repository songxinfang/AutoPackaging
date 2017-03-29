//
//  PlaceholdTextView.m
//  adult
//
//  Created by shen yan ping on 15/11/5.
//  Copyright (c) 2015年 AiMeng. All rights reserved.
//

#import "PlaceholdTextView.h"

@implementation PlaceholdTextView

- (instancetype)initWithFrame:(CGRect)frame placeholdText:(NSString*)holdText placeholdColor:(UIColor*)holdColor textColor:(UIColor*)normalColor font:(UIFont*)font
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholdColor = holdColor;
        self.placeholdText = holdText;
        self.inputColor = normalColor;
        
        self.isShowHolder = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.text = self.placeholdText;
        self.textColor = self.placeholdColor;
        self.font = font;
        
        self.delegate = self;
    }
    return self;
}

- (void)buildCurrentText:(NSString*)currentText
{
    self.text = currentText;
    self.textColor = self.inputColor;
}

#pragma mark- textViewDelegate
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (self.isShowHolder) {
        textView.text = @"";
        textView.textColor = self.inputColor;
    }
    if ([self.myDelegate respondsToSelector:@selector(textView:status:changed:)]) {
        [self.myDelegate textView:self status:TEXTVIEW_EDIT_BEGIN changed:textView.text];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.isShowHolder = YES;
        textView.text = self.placeholdText;
        textView.textColor = self.placeholdColor;
    }
    else{
        self.isShowHolder = NO;
    }
    if ([self.myDelegate respondsToSelector:@selector(textView:status:changed:)]) {
        [self.myDelegate textView:self status:TEXTVIEW_EDIT_END changed:textView.text];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.myDelegate respondsToSelector:@selector(textView:status:changed:)]) {
        [self.myDelegate textView:self status:TEXTVIEW_EDIT_ING changed:textView.text];
    }
}

- (NSString*)getCurrentText
{
    if ([self.text isEqualToString:self.placeholdText]) {
        return @"";
    }
    return self.text;
}
@end
