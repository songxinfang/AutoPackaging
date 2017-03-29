//
//  QuestionNavigationBar.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QuestionNavigationBar;


typedef NS_ENUM(NSInteger, QuestionNavigationBarClickType) {
    QuestionNavigationBarClickBack,
    QuestionNavigationBarClickCollection,
    QuestionNavigationBarClickShare,
    QuestionNavigationBarClickTitle
};


@protocol QuestionNavigationBarDelegate <NSObject>

@optional

-(void) QuestionNavigationBar:(QuestionNavigationBar *) view ClickType:(QuestionNavigationBarClickType) type;



@end

@interface QuestionNavigationBar : UIView


+(instancetype)NavigationBar;


@property(nonatomic , weak) id <QuestionNavigationBarDelegate> delegate;

@property(nonatomic , strong) NSString * title;

@property(nonatomic , assign) BOOL isHiddenShare;
@property(nonatomic , assign) BOOL isHiddenCollection;

@property(nonatomic , assign) BOOL isCollection;

@property(nonatomic , assign) BOOL isHiddenTitleImage;

@property(nonatomic , assign) BOOL isHiddenBack;



@property(nonatomic , strong) NSString * timestr;
@property(nonatomic , assign) BOOL isHiddenTime;










@end
