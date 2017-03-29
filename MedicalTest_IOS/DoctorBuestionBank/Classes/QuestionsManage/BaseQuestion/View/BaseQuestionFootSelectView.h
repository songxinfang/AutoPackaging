//
//  BaseQuestionFootSelectView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/11.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BaseQuestionFootSelectView;

@protocol BaseQuestionFootSelectViewDelegate <NSObject>


-(void)BaseQuestionFootSelectView :(BaseQuestionFootSelectView *) view direction:(BOOL) direction;




@end

@interface BaseQuestionFootSelectView : UIView

+(instancetype) FootSelectView;

@property(nonatomic , weak) id<BaseQuestionFootSelectViewDelegate> delegate;

@property(nonatomic , assign) BOOL PreEnabled;
@property(nonatomic , assign) BOOL NextEnabled;



@property(nonatomic , strong) NSString * netTitle;



@end
