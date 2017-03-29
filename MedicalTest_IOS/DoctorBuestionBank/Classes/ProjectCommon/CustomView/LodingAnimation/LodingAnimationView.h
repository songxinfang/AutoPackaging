//
//  LodingAnimationView.h
//  TestKvc
//
//  Created by 杨强 on 16/10/8.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LodingAnimationView : UIView


/**
 *  动画持续的时间
 */
@property(nonatomic , assign) CGFloat allTimer;


+(instancetype)AnimationView;



-(void) start;
-(void) stop;





@end
