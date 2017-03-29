//
//  HomeTipView.m
//  DoctorBuestionBank
//
//  Created by  on 2016/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeTipView.h"

@implementation HomeTipView

+ (void)showTipViewWithIconFrame:(CGRect)rect
{
    // 将整个蒙层视图加在window上
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (!keywindow)
        keywindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    HomeTipView *bg = [[HomeTipView alloc] initWithFrame:keywindow.bounds];
    [bg buildViewWithIconFrame:rect];
    [keywindow addSubview:bg];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    }
    
    return self;
}

- (void)buildViewWithIconFrame:(CGRect)rect
{
    // 右上角icon
    UIImage *iconImage = [UIImage imageNamed:@"tippage_icon"];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x + (rect.size.width - iconImage.size.width)/2,
                                                                      UI_STATUS_BAR_HEIGHT + rect.origin.y + + (rect.size.height - iconImage.size.height)/2,
                                                                      iconImage.size.width,
                                                                      iconImage.size.height)];
    icon.image = iconImage;
    icon.userInteractionEnabled = YES;
    [self addSubview:icon];
    
    // 核心内容
    UIImage *contentImage = [UIImage imageNamed:@"tipcontent_content"];
    UIImageView *content = [[UIImageView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(icon.frame)+42, SCREEN_WIDTH - 32, (SCREEN_WIDTH - 32) * contentImage.size.height/contentImage.size.width)];
    content.image = contentImage;
    [self addSubview:content];
    
    // 关闭按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 154)/2, CGRectGetMaxY(content.frame)+133, 156, 44)];
    [btn setTitle:@"知道了，开始吧!" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(closeTipPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [icon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTipPage)] ];
    
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, btn.width, btn.height);
    borderLayer.position = CGPointMake(CGRectGetMidX(btn.bounds), CGRectGetMidY(btn.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:5.0].CGPath;
    borderLayer.lineWidth = 1.0 / [[UIScreen mainScreen] scale];
    //虚线边框
    borderLayer.lineDashPattern = @[@2, @1];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    [btn.layer addSublayer:borderLayer];
    
    // 适配小尺寸
    if (IS_IPHONE5)
        btn.y = SCREEN_HEIGHT - 120;
    else if (IS_IPHONE4)
        btn.y = SCREEN_HEIGHT - 60;
}

- (void)closeTipPage
{
    [self removeFromSuperview];
}


@end
