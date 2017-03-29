//
//  CustomHomeNavigationItem.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/31.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomHomeNavigationItemClickType) {
    CustomHomeNavigationItemClickMy,
    CustomHomeNavigationItemClickInstructions,
    CustomHomeNavigationItemClickExamination,
    CustomHomeNavigationItemClickPractice

};


@class CustomHomeNavigationItem;



@protocol CustomHomeNavigationItemDelegate <NSObject>


-(void) CustomHomeNavigationItem:(CustomHomeNavigationItem *) view didClickType:(CustomHomeNavigationItemClickType) clickType;



@end

@interface CustomHomeNavigationItem : UIView

+(instancetype) HomeNavigationItem;

@property(nonatomic , weak) id<CustomHomeNavigationItemDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;

@property(nonatomic , assign) BOOL hiddenBackImage;




@end
