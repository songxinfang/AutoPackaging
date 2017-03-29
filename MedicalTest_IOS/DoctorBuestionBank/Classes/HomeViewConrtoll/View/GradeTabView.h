//
//  GradeTabView.h
//  GradeTabDemo
//
//  Created by A053 on 16/10/8.
//  Copyright © 2016年 Yvan. All rights reserved.
//

/*
 GradeTabView *view = [[GradeTabView alloc]initWithGrade:GradeTypeBig GradeTabType:GradeTabType_A_Sub Point:CGPointMake(100, 100) Width:67];
 
 [self.view addSubview:view];
 //按下时调用
 [view touchBig];
 //结束按下时调用
 [view touchEnd];



 */

#import <UIKit/UIKit.h>

#define FONT(x)         [UIFont systemFontOfSize:(x*([UIScreen mainScreen].bounds.size.width/375.0))]
#define LENGTH(x)       (x*([UIScreen mainScreen].bounds.size.width/375.0))
#define RGB(r,g,b)      [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]

#define COLOR_N_BOLDER  RGB(142,157,243)
#define COLOR_N         RGB(142,157,243)
#define COLOR_S         RGB(182,249,160)
#define COLOR_A         RGB(218,252,174)
#define COLOR_B         RGB(251,248,163)
#define COLOR_C         RGB(254,211,160)
#define COLOR_D         RGB(254,167,160)
#define COLOR_R         RGB(111,128,200)
#define COLOR_SMALL     RGB(148,162,224)

/**
 *  界别类型
 */
typedef NS_ENUM(NSUInteger, GradeTabType) {
    GradeTabType_Sub = 0,
    GradeTabType_A_Add,
    GradeTabType_A,
    GradeTabType_A_Sub,
    GradeTabType_B_Add,
    GradeTabType_B,
    GradeTabType_B_Sub,
    GradeTabType_C_Add,
    GradeTabType_C,
    GradeTabType_C_Sub,
    GradeTabType_D_Add,
    GradeTabType_D,
    GradeTabType_S,
    GradeTabType_Right
};
/**
 *  大图还是小图
 */
typedef NS_ENUM(NSUInteger, GradeType) {
    /**
     *  上面用的大图
     */
    GradeTypeBig,
    /**
     *  tableView用的小图标
     */
    GradeTypeSmall
};


@interface GradeTabView : UIView

/**
 *  实例化
 *
 *  @param gradeType 是上面的大图还是小图
 *  @param tabType   级别类型 A A+ A- ...
 *  @param point     开始位置
 *  @param width     最大直径
 *
 */
- (instancetype)initWithGrade:(GradeType)gradeType GradeTabType:(GradeTabType)tabType Point:(CGPoint)point Width:(CGFloat)width;

// 设置所有线条颜色
- (void)setLineColor:(UIColor *)wholeColor;

// 设置上部、中下部
- (void)setLineTopColor:(UIColor *)topColor other:(UIColor *)otherColor;

// 设置下部、上中部
- (void)setLineBottomColor:(UIColor *)bottomColor other:(UIColor *)otherColor;

// 设置上部、中部、下部
- (void)setLineTopColor:(UIColor *)topColor middle:(UIColor *)middleColor  bottom:(UIColor *)bottomColor;

/**
 *  按下后效果
 */
- (void)touchBig;
/**
 *  结束按下
 */
- (void)touchEnd;
- (void)chageType:(GradeTabType)gradeTabType;
@end
