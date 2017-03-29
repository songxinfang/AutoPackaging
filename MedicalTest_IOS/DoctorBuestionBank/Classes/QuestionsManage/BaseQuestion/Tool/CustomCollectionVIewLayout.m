//
//  CustomCollectionVIewLayout.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/17.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "CustomCollectionVIewLayout.h"

@implementation CustomCollectionVIewLayout





- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
   
    
    
    if (velocity.x > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotificationCentersliding object:nil];
        
    }
    
    [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
   

    if ([self.delegate respondsToSelector:@selector(CustomCollectionVIewLayout:ProposedContentOffset:)]) {
        [self.delegate CustomCollectionVIewLayout:self ProposedContentOffset:proposedContentOffset];
    }
    
    
    return proposedContentOffset;
    

}




- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    
    
    
    if ([self.delegate respondsToSelector:@selector(CustomCollectionVIewLayout:ProposedContentOffset:)]) {
        
        [self.delegate CustomCollectionVIewLayout:self ProposedContentOffset:proposedContentOffset];
        
    }
    return proposedContentOffset;
    

}

@end
