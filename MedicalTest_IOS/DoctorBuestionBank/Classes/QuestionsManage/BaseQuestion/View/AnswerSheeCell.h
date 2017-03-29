//
//  AnswerSheeCell.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CollectionViewCellColorType) {
    UCollectionViewCellColorNone,
    UCollectionViewCellColorSelect,
    UCollectionViewCellColorRight,
    UCollectionViewCellColorWrong
};




@interface AnswerSheeCell : UICollectionViewCell

@property (nonatomic , assign) NSInteger item;



@property(nonatomic , assign)CollectionViewCellColorType  colorType;








@end
