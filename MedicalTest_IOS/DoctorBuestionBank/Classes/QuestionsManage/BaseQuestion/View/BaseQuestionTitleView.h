//
//  BaseQuestionTitleView.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/27.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BaseQuestionTitleClickStatus ) {
    
    ClickBactBtn ,           //点击返回
    ClickCollectBtn ,       //点击收藏
    ClickShareBtn          //点击分享
    
    
};


@interface BaseQuestionTitleView : UIView

@end
