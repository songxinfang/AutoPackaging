//
//  LoadingImageCell.m
//  TestKvc
//
//  Created by 杨强 on 16/10/8.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "LoadingImageCell.h"




@interface LoadingImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *AnimationImage;

@end





@implementation LoadingImageCell


+(instancetype) loadingCellWithTableView:(UITableView *) tableview
{
    
    static NSString * loadingCellIdentifier = @"loadingCellIdentifier";
    
    LoadingImageCell * cell = [tableview     dequeueReusableCellWithIdentifier:loadingCellIdentifier];
    
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil   options:nil].lastObject ;
    }
    
    return cell;
    
    

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userInteractionEnabled = NO;
    
    self.AnimationImage.image = [UIImage imageNamed:@"Printer"];
    
    
    
}





@end
