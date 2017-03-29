//
//  QuestionTitleView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/12.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTitleView : UIView


+(instancetype)TitleView ;

@property(nonatomic , strong) NSString * title ;


@property(nonatomic , readonly , assign) CGFloat viewHeight;



@end
