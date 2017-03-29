//
//  BaseQuestionView.h
//  DoctorBuestionBank
//
//  Created by lc on 16/9/23.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

@class BaseQuestionView;


@protocol BaseQuestionViewDelegate <NSObject>

@optional


-(void) BaseQuestionView :(BaseQuestionView *) view  numberOfItemsInData:(NSIndexPath * ) indexPath CollectionStatus:(CollectionViewStatus) status selectOrder:(NSInteger) order  ;


@end


@interface BaseQuestionView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic,strong)NSArray < NSArray <QuestionInfo *> *> * dataSource;;
@property(nonatomic , weak) id <BaseQuestionViewDelegate >   delegate;

-(void) reloadData;

-(void) ScrollViewWithDirection:(BOOL) direction;

@property(nonatomic , strong)NSIndexPath * scrollToIndexPath;
@property(nonatomic ,assign) QuestionResultType questionType;


@end
