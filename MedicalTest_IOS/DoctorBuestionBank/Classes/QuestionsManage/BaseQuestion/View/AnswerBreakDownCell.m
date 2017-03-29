//
//  AnswerBreakDownCell.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AnswerBreakDownCell.h"
#import "QuestionModel.h"



@implementation AnswerBreakDownModel



@end




@interface AnswerBreakDownCell ()


@property (weak, nonatomic) IBOutlet UIImageView *answerImageView;
@property (weak, nonatomic) IBOutlet UILabel *answerLable;
@property (weak, nonatomic) IBOutlet UILabel *SolutionLable;

@end

@implementation AnswerBreakDownCell
{
    CGFloat _cellHeight;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.answerLable.preferredMaxLayoutWidth = SCREEN_WIDTH  - 16*2 - 8 - 4 -17 - 48;
    self.SolutionLable.preferredMaxLayoutWidth = SCREEN_WIDTH - 16*2;
    

    
   
}


+(instancetype)cellWithTableView:(UITableView *) tableView
{

    static NSString *  AnswerBreakDownCellIdentifier = @"AnswerBreakDownCellIdentifier";
    
    AnswerBreakDownCell * cell = [tableView dequeueReusableCellWithIdentifier:AnswerBreakDownCellIdentifier];
    
    if(!cell){
    
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject ;
        
    }
    
    return cell;
    

}




-(void) setModel:(Question *)model
{
    
    // 设置图片
    NSString * imageStr = nil;
    
    
    int i = 0;
    for (NSString * str in model.CorrectSet) {
        if (i == _indexPath.item) {
            imageStr = str;
            break;
            
        }
        
    }
    
    if (!imageStr) {
        imageStr = @"A";
        
    }
    
    int order = [self changeToInt:imageStr];
    NSString *imageName = [NSString stringWithFormat:@"MedicalExaminationAnswer_%d",order];
    
    self.answerImageView.image = [UIImage imageNamed:imageName  ];
    
    NSArray * answerArray = [model.AnswerStr componentsSeparatedByString:@"|"];
    
    
    self.answerLable.text = answerArray[order];
    self.SolutionLable.text = model.Solution;

    
    [self layoutIfNeeded ];
    
    CGFloat h =  self.SolutionLable.frame.origin.y + self.SolutionLable.frame.size.height + 16;
    NSString * cellHeightKey = [NSString stringWithFormat:@"%ld" , _indexPath.item];
    
    
    model.cellHeightDic[cellHeightKey] = @(h);

    

    
    
    
    

}


- (int)changeToInt:(NSString *)str{
    
    if (!str)
    {
        return 0;
    }
    const char *newChar = [str UTF8String];
    
    char c = newChar[0];//一共一个字母，取首字母
    
    return c-65;
}


@end
