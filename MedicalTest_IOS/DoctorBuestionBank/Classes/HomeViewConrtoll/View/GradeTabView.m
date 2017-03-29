//
//  GradeTabView.m
//  GradeTabDemo
//
//  Created by A053 on 16/10/8.
//  Copyright © 2016年 Yvan. All rights reserved.
//

#import "GradeTabView.h"


typedef NS_ENUM(NSUInteger,LevelType) {
    LevelTypeAdd,
    LevelTypeNormal,
    LevelTypeSub,
};

@interface GradeTabView () {
    float border_w;
    float width_;
    
    float radar_l;
    float center_w;
    float center_h;
    float radius;
}
@property (assign, nonatomic) GradeType gradeType;
@property (assign, nonatomic) GradeTabType tabType;
@property (assign, nonatomic) LevelType levelType;
@property (assign, nonatomic) BOOL touched;

@property(nonatomic , weak) UILabel * SLabel;
@property(nonatomic , weak) UILabel * ALabel;

@property(nonatomic , strong) UIColor *topColor;
@property(nonatomic , strong) UIColor *middleColor;
@property(nonatomic , strong) UIColor *bottomColor;

@end

@implementation GradeTabView

#pragma mark - 有颜色变化的级别图标

- (void)drawBodyBig {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _topColor.CGColor);
    CGContextSetLineWidth(context, border_w);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextSetMiterLimit(context,20.0);


    radar_l = width_/2-border_w/2;
    radius  = 2.0f;
    float x   = 0;
    float y   = 0;
    double pi = M_PI/(3.0f);

    { // 先画一个圈圈完整的
        //第一条线
        CGContextMoveToPoint(context, center_w, center_h-radar_l);
        Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);

        //第2条线
        Coordinate_3(pi*2,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);

        //第3条线
        Coordinate_3(pi*3,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第4条线
        Coordinate_3(pi*4,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第五条线
        Coordinate_3(pi*5,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第六条线
        CGContextAddLineToPoint(context, center_w, center_h-radar_l);
        
        // 重画第一根线 使闭合
        Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        CGContextStrokePath(context);
    }
    
    // 将不同颜色绘制
    if (![_middleColor isEqual:_topColor])
    {
        // 重画2345
        CGContextSetStrokeColorWithColor(context, _middleColor.CGColor);
        Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
        CGContextMoveToPoint(context, x, y+0.5);
        
        //第2条线
        Coordinate_3(pi*2,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第3条线
        Coordinate_3(pi*3,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第4条线
        Coordinate_3(pi*4,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第5条线
        Coordinate_3(pi*5,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y+0.5);
   
        CGContextStrokePath(context);
    }

    if (![_middleColor isEqual:_bottomColor])
    {
        // 重画34
        CGContextSetStrokeColorWithColor(context, _bottomColor.CGColor);
        Coordinate_3(pi*2,radar_l, center_w, center_h,&x, &y);
        CGContextMoveToPoint(context, x, y);
        
        //第3条线
        Coordinate_3(pi*3,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        //第4条线
        Coordinate_3(pi*4,radar_l, center_w, center_h,&x, &y);
        CGContextAddLineToPoint(context, x, y);
        
        CGContextStrokePath(context);
    }

    // 添加级别文本
    [self setLabel];
}

#pragma mark - 小图标画法

- (void)drawBodySmall {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, border_w);
    CGContextSetStrokeColorWithColor(context, COLOR_SMALL.CGColor);
    radar_l = width_/2-border_w/2;
    for (int i = 1; i<=6; i++) {
        float x   = 0;
        float y   = 0;
        double pi = (M_PI/3.0f)*i;
        Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
        
        if (i == 1) {
            CGContextMoveToPoint(context, center_w, center_h -radar_l);
        }
        if (i == 6) {
            CGContextAddLineToPoint(context, center_w, center_h -radar_l);
        } else {
            CGContextAddLineToPoint(context, x, y);
        }
    }
    if (self.tabType == GradeTabType_Right) {
        CGContextSetFillColorWithColor(context, COLOR_R.CGColor);
        CGContextFillPath(context);
        
    }
    CGContextStrokePath(context);
    if (self.tabType == GradeTabType_Right) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, border_w*1.5);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, center_w/2+center_w/4, center_h+center_h/10);
        CGContextAddLineToPoint(context, center_w, center_h+center_h/4);
        CGContextAddLineToPoint(context, center_w+center_w/3, center_h-center_h/4);
        CGContextStrokePath(context);
    }
    
    [self setLabel];
}

#pragma mark - 按下效果

- (void)drawTouch {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, COLOR_N_BOLDER.CGColor);
    radar_l = width_/2;
    radius  = 2.0f;
    float x   = 0;
    float y   = 0;
    double pi = M_PI/(3.0f);
    
    //第一条线
    CGContextMoveToPoint(context, center_w, center_h-radar_l);
    Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x-radius, y-radius);
    CGContextAddArcToPoint(context, x, y, x, y+radius, radius);
    //第二条线
    Coordinate_3(pi*2,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x, y-radius);
    //第三条线
    CGContextMoveToPoint(context, x, y-radius);
    CGContextAddArcToPoint(context, x, y, x-radius, y+radius, radius);
    Coordinate_3(pi*3,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x+radius, y);
    //第四条线
    CGContextAddArcToPoint(context, x, y, x-radius, y-radius, radius);
    Coordinate_3(pi*4,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x+radius, y+radius);
    //第五条线
    CGContextAddArcToPoint(context, x, y, x, y-radius, radius);
    Coordinate_3(pi*5,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x, y+radius);
    //第六条线
    CGContextAddArcToPoint(context, x, y, x+radius, y-radius, radius);
    CGContextAddLineToPoint(context,  center_w-radius, center_h-radar_l);
    CGContextAddArcToPoint(context, center_w, center_h-radar_l,center_w+radius, center_h-radar_l+radius, radius);
    switch (self.tabType) {
        case GradeTabType_S:{
            CGContextSetFillColorWithColor(context, COLOR_S.CGColor);
        }break;
        case GradeTabType_A:
        case GradeTabType_A_Add:
        case GradeTabType_A_Sub:{
            CGContextSetFillColorWithColor(context, COLOR_A.CGColor);
        }break;
        case GradeTabType_B:
        case GradeTabType_B_Add:
        case GradeTabType_B_Sub:{
            CGContextSetFillColorWithColor(context, COLOR_B.CGColor);
        }break;
        case GradeTabType_C:
        case GradeTabType_C_Add:
        case GradeTabType_C_Sub:{
            CGContextSetFillColorWithColor(context, COLOR_C.CGColor);
        }break;
        case GradeTabType_D:
        case GradeTabType_D_Add: {
            CGContextSetFillColorWithColor(context, COLOR_D.CGColor);
        }break;
        default:{
            CGContextSetFillColorWithColor(context, COLOR_N.CGColor);
        }break;
    }
    CGContextFillPath(context);
    x   = 0;
    y   = 0;
    //第一条线
    CGContextMoveToPoint(context, center_w, center_h-radar_l);
    Coordinate_3(pi,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x-radius, y-radius);
    CGContextAddArcToPoint(context, x, y, x, y+radius, radius);
    //第二条线
    Coordinate_3(pi*2,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x, y-radius);
    //第三条线
    CGContextMoveToPoint(context, x, y-radius);
    CGContextAddArcToPoint(context, x, y, x-radius, y+radius, radius);
    Coordinate_3(pi*3,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x+radius, y);
    //第四条线
    CGContextAddArcToPoint(context, x, y, x-radius, y-radius, radius);
    Coordinate_3(pi*4,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x+radius, y+radius);
    //第五条线
    CGContextAddArcToPoint(context, x, y, x, y-radius, radius);
    Coordinate_3(pi*5,radar_l, center_w, center_h,&x, &y);
    CGContextAddLineToPoint(context, x, y+radius);
    //第六条线
    CGContextAddArcToPoint(context, x, y, x+radius, y-radius, radius);
    CGContextAddLineToPoint(context,  center_w-radius, center_h-radar_l);
    CGContextAddArcToPoint(context, center_w, center_h-radar_l,center_w+radius, center_h-radar_l+radius, radius);
    CGContextStrokePath(context);

    [self setLabel];

}

#pragma mark - 添加级别文本

- (void)setLabel {
    
    float fontSize  = self.gradeType==GradeTypeBig?10.0f:10.0f;
    float sFontSize = self.gradeType==GradeTypeBig?7.0f:7.0f;
    UILabel *ALabel = [[UILabel alloc]initWithFrame:CGRectMake(center_w-fontSize/2, center_w-fontSize/2, fontSize, fontSize)];
    ALabel.font = [UIFont boldSystemFontOfSize:fontSize];
    ALabel.textAlignment = NSTextAlignmentCenter;

    NSDictionary *strokeTextAttributes;
    [self addSubview:ALabel];
    UILabel *SLabel = [[UILabel alloc]initWithFrame:CGRectMake(center_w+sFontSize/4, center_w-(fontSize-sFontSize/2), sFontSize, sFontSize)];
    self.SLabel = SLabel  ;
    SLabel.font = [UIFont boldSystemFontOfSize:sFontSize];
    SLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.gradeType == GradeTypeBig) {
        strokeTextAttributes = @{
                                 NSStrokeColorAttributeName : COLOR_N_BOLDER,
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSStrokeWidthAttributeName : [NSNumber numberWithDouble:-1.0],
                                 };
    } else {
        ALabel.textColor = COLOR_SMALL;
        SLabel.textColor = COLOR_SMALL;
        strokeTextAttributes = @{
                                 NSStrokeColorAttributeName : COLOR_N_BOLDER,
                                 NSForegroundColorAttributeName : COLOR_SMALL,
                                 NSStrokeWidthAttributeName : [NSNumber numberWithDouble:-1.0],
                                 };
    }
    [self addSubview:SLabel];
    switch (self.tabType) {
        case GradeTabType_S:
        case GradeTabType_A:
        case GradeTabType_B:
        case GradeTabType_C:
        case GradeTabType_D:
        case GradeTabType_Sub:{
//            ALabel.frame = CGRectMake(center_w-fontSize/2, center_w-fontSize/2, fontSize, fontSize);
            ALabel.center = CGPointMake(center_w, center_h);
        } break;
        default:{
            ALabel.frame = CGRectMake(center_w-fontSize/2-sFontSize/4, center_w-fontSize/2, fontSize, fontSize);
            SLabel.frame = CGRectMake(center_w, center_w-(fontSize-sFontSize/2), sFontSize, sFontSize);
            ALabel.centerY = center_h;

        }break;
    }
    switch (self.tabType) {
        case GradeTabType_S:{
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"S" attributes:strokeTextAttributes];
        }break;
        case GradeTabType_A:
        case GradeTabType_A_Add:
        case GradeTabType_A_Sub:{
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"A" attributes:strokeTextAttributes];
        }break;
        case GradeTabType_B:
        case GradeTabType_B_Add:
        case GradeTabType_B_Sub:{
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"B" attributes:strokeTextAttributes];
        }break;
        case GradeTabType_C:
        case GradeTabType_C_Add:
        case GradeTabType_C_Sub:{
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"C" attributes:strokeTextAttributes];
        }break;
        case GradeTabType_D:
        case GradeTabType_D_Add: {
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"D" attributes:strokeTextAttributes];
        }break;
        case GradeTabType_Sub: {
            strokeTextAttributes = @{
                                     NSStrokeColorAttributeName : COLOR_N_BOLDER,
                                     NSForegroundColorAttributeName : COLOR_N_BOLDER,
                                     NSStrokeWidthAttributeName : [NSNumber numberWithDouble:-1.0],
                                     };
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"一" attributes:strokeTextAttributes];
        }break;
        default:{
            ALabel.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:strokeTextAttributes];
        }break;
    }
    switch (self.tabType) {
        case GradeTabType_A_Add:
        case GradeTabType_B_Add:
        case GradeTabType_C_Add:
        case GradeTabType_D_Add:{
            SLabel.attributedText = [[NSAttributedString alloc]initWithString:@"+" attributes:strokeTextAttributes];
        } break;
        case GradeTabType_A_Sub:
        case GradeTabType_B_Sub:
        case GradeTabType_C_Sub:{
            SLabel.attributedText = [[NSAttributedString alloc]initWithString:@"-" attributes:strokeTextAttributes];
        }break;
            
        default:{
            SLabel.attributedText = [[NSAttributedString alloc]initWithString:@"" attributes:strokeTextAttributes];
        }break;
    }
}

#pragma mark - 每个级别的颜色

- (void)contextSetStrokeColorWith:(CGContextRef)context {
    
    switch (self.tabType) {
        case GradeTabType_S:{
            CGContextSetStrokeColorWithColor(context, COLOR_S.CGColor);
        }break;
        case GradeTabType_A:
        case GradeTabType_A_Add:
        case GradeTabType_A_Sub:{
            CGContextSetStrokeColorWithColor(context, COLOR_A.CGColor);
        }break;
        case GradeTabType_B:
        case GradeTabType_B_Add:
        case GradeTabType_B_Sub:{
            CGContextSetStrokeColorWithColor(context, COLOR_B.CGColor);
        }break;
        case GradeTabType_C:
        case GradeTabType_C_Add:
        case GradeTabType_C_Sub:{
            CGContextSetStrokeColorWithColor(context, COLOR_C.CGColor);
        }break;
        case GradeTabType_D:
        case GradeTabType_D_Add: {
            CGContextSetStrokeColorWithColor(context, COLOR_D.CGColor);
        }break;
        default:{
            CGContextSetStrokeColorWithColor(context, COLOR_N.CGColor);
        }break;
    }
    
}

#pragma mark - 算落点坐标

void Coordinate_3 (double pi, float l, float c_w , float c_h, float *x, float *y) {
    *x = c_w + sin(pi)*l;
    *y = c_h - cos(pi)*l;
}

- (instancetype)initWithGrade:(GradeType)gradeType GradeTabType:(GradeTabType)tabType Point:(CGPoint)point Width:(CGFloat)width {
    if (self = [super init]) {
        self.frame = CGRectMake(point.x, point.y, width, width);
        self.backgroundColor = [UIColor clearColor];
        
        [self setLineColor:COLOR_S];
        
        self.gradeType = gradeType;
        self.tabType   = tabType;
        
        width_   = width;
        border_w = gradeType==GradeTypeBig?2:1;
        center_w = width_/2;
        center_h = width_/2;
       
        switch (tabType) {
            case GradeTabType_S:
            case GradeTabType_A_Add:
            case GradeTabType_B_Add:
            case GradeTabType_C_Add:
            case GradeTabType_D_Add:
            case GradeTabType_Sub:
            case GradeTabType_Right:
                self.levelType = LevelTypeAdd;break;
            case GradeTabType_A:
            case GradeTabType_B:
            case GradeTabType_C:
            case GradeTabType_D:
                self.levelType = LevelTypeNormal;break;
            default:
                self.levelType = LevelTypeSub;break;
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    if (self.gradeType == GradeTypeBig){
//        if (self.touched){
//            [self drawTouch];
//        } else {
            [self drawBodyBig];
//        }
    } else {
        [self drawBodySmall];
    }
    
    
//    self.layer.borderWidth = 5;
//    self.layer.borderColor = [[UIColor redColor] CGColor];
}

- (void)setTouched:(BOOL)touched {
    _touched = touched;
    [self setNeedsDisplay];
}

#pragma mark - 线条颜色
// 设置所有线条颜色
- (void)setLineColor:(UIColor *)wholeColor
{
    [self setLineTopColor:wholeColor middle:wholeColor bottom:wholeColor];
}

// 设置上部、中下部
- (void)setLineTopColor:(UIColor *)topColor other:(UIColor *)otherColor
{
    [self setLineTopColor:topColor middle:otherColor bottom:otherColor];
}

// 设置下部、上中部
- (void)setLineBottomColor:(UIColor *)bottomColor other:(UIColor *)otherColor
{
    [self setLineTopColor:otherColor middle:otherColor bottom:bottomColor];
}

// 设置上部、中部、下部
- (void)setLineTopColor:(UIColor *)topColor middle:(UIColor *)middleColor  bottom:(UIColor *)bottomColor
{
    self.topColor = topColor;
    self.middleColor = middleColor;
    self.bottomColor = bottomColor;
}

#pragma mark - 按下效果

- (void)touchBig {
    self.touched = YES;
}

#pragma mark - 结束按压效果

- (void)touchEnd {
    self.touched = NO;
}

- (void)chageType:(GradeTabType)gradeTabType
{
    if (self.tabType != gradeTabType) {
        
        
        for (UIView * view in self.subviews) {
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                [view removeFromSuperview];
            }
            
        }
        
        self.tabType = gradeTabType;
        [self setNeedsDisplay];
    }
}

-(void)setTabType:(GradeTabType)tabType
{
    if (_tabType != tabType)
    {
        if (self.gradeType == GradeTypeBig)
        {
            switch (tabType) {
                case GradeTabType_S:
                    [self setLineColor:COLOR_S];
                    break;
                case GradeTabType_A_Add:
                    [self setLineColor:COLOR_A];
                    break;
                case GradeTabType_A:
                    [self setLineTopColor:COLOR_N other:COLOR_A];
                    break;
                case GradeTabType_A_Sub:
                    [self setLineBottomColor:COLOR_A other:COLOR_N];
                    break;
                case GradeTabType_B_Add:
                    [self setLineColor:COLOR_B];
                    break;
                case GradeTabType_B:
                    [self setLineTopColor:COLOR_N other:COLOR_B];
                    break;
                case GradeTabType_B_Sub:
                    [self setLineBottomColor:COLOR_B other:COLOR_N];
                    break;
                case GradeTabType_C_Add:
                    [self setLineColor:COLOR_C];
                    break;
                case GradeTabType_C:
                    [self setLineTopColor:COLOR_N other:COLOR_C];
                    break;
                case GradeTabType_C_Sub:
                    [self setLineBottomColor:COLOR_C other:COLOR_N];
                    break;
                case GradeTabType_D_Add:
                    [self setLineColor:COLOR_D];
                    break;
                case GradeTabType_D:
                    [self setLineTopColor:COLOR_N other:COLOR_D];
                    break;
                case GradeTabType_Sub:
                    [self setLineColor:COLOR_N];
                    break;
                    
                case GradeTabType_Right:
                default:
                {
                    if (_bottomColor)
                        [self setLineColor:_bottomColor];
                    else
                        [self setLineColor:COLOR_N];
                }
                    break;
            }
        }
        
        _tabType = tabType;
    }
}

@end
