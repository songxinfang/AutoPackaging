//
//  CustomCollectionVIewLayout.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCollectionVIewLayout;


@protocol CustomCollectionVIewLayoutDelegage <NSObject>


@optional

-(void)  CustomCollectionVIewLayout:(CustomCollectionVIewLayout *) view ProposedContentOffset:(CGPoint)proposedContentOffset;



@end


@interface CustomCollectionVIewLayout : UICollectionViewFlowLayout

@property(nonatomic , weak) id<CustomCollectionVIewLayoutDelegage> delegate;


@end
