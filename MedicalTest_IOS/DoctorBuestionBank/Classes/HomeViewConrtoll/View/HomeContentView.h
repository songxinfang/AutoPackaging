//
//  HomeContentView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionLevelModel;
@class HomeContentView;



typedef NS_ENUM(NSInteger, HomeContentViewClickType) {
    HomeContentViewClickPractice,
    HomeContentViewClickExamination
};

@protocol HomeContentViewDelegate <NSObject>


@optional

-(void ) HomeContentView:(HomeContentView *) view ScrollViewFromItem:(NSInteger) fromItem toItem:(NSInteger) toItem;



-(void ) HomeContentView:(HomeContentView *) view didType:(HomeContentViewClickType) type;


-(void ) HomeContentView:(HomeContentView *) view didAgainType:(HomeContentViewClickType) type;




@end


@interface HomeContentView : UIView


+(instancetype)ContentView;

@property(nonatomic , strong) NSArray<QuestionLevelModel *> * levelArr;

@property(nonatomic , strong) NSArray<NSArray <QuestionTopicModel *> * > * TopicModelArr;


@property(nonatomic , assign) NSInteger item;

// 默认有动画
@property(nonatomic , assign) BOOL animatedFlag ;


@property(nonatomic , weak) id<HomeContentViewDelegate> delegate;



// 专门为动画用 


@property(nonatomic , assign) BOOL singleItem;



-(void) reloadAtIndexPath:(NSIndexPath *) indexPath;

/**
 * 再来一次
 */
- (void)didAgainWith:(HomeContentViewClickType)clickType;


@end
