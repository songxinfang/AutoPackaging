//
//  BaseQuestionFootMakeSureView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/11.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseQuestionFootMakeSureViewDelegate <NSObject>

@optional
-(void)BaseQuestionFootMakeSureViewDidSelect;


@end

@interface BaseQuestionFootMakeSureView : UIView

+(instancetype) FootMakeSureView;

@property(nonatomic , strong) NSString * title;

@property(nonatomic , assign) BOOL HiddenPoint;



@property(nonatomic , weak) id<BaseQuestionFootMakeSureViewDelegate> delegate;



@end
