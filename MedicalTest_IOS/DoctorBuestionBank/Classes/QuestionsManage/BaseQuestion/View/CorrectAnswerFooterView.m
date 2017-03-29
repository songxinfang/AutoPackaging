//
//  CorrectAnswerFooterView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/30.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "CorrectAnswerFooterView.h"


@interface CorrectAnswerFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *resultLable;

@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end


@implementation CorrectAnswerFooterView


+(instancetype)AnswerFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}


-(void) setSelectStatus:(UserSelectStatus)SelectStatus
{
    _SelectStatus = SelectStatus;
    
    if (SelectStatus == UserSelectCorrect) {
        self.resultImageView.image = [UIImage imageNamed:@"AnsterIdentifierRight"];
        self.resultLable.text = @"回答正确";
        
    }else{
        self.resultImageView.image = [UIImage imageNamed:@"AnsterIdentifierWrong"];
        self.resultLable.text = @"回答错误";
    
    }

}




@end
