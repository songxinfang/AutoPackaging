//
//  HomeContentHeaderView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/31.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HomeContentHeaderViewDelegate <NSObject>

@optional
-(void) didClickSelectAllBtn;


@end

@interface HomeContentHeaderView : UIView



+(instancetype)ContentHeaderView;

@property(nonatomic , assign) NSInteger ChapterNum;

@property(nonatomic , weak) id<HomeContentHeaderViewDelegate> delegate;


@property(nonatomic , strong) NSString * title;



@end
