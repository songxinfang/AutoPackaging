//
//  ExaminationResults.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/21.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ExaminationResults.h"
#import "ResultsModel.h"



@interface ExaminationResults ()

@property (weak, nonatomic) IBOutlet UILabel *rankingLable;
@property (weak, nonatomic) IBOutlet UILabel *topicCountLable;
@property (weak, nonatomic) IBOutlet UILabel *WrongCountLable;
@property (weak, nonatomic) IBOutlet UIButton *practiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UILabel *scoreLable;
@property (weak, nonatomic) IBOutlet UIButton *examinationAgainBtn;  /**< 再来一次 */

@end

@implementation ExaminationResults


+(instancetype)ResultsView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.topicCountLable.layer.cornerRadius = 5.0;
    self.topicCountLable.clipsToBounds = YES;
    self.WrongCountLable.layer.cornerRadius = 5.0;
    self.WrongCountLable.clipsToBounds = YES;
    

}


- (IBAction)clickPracticeBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ExaminationResults:didClickType:)]) {
        
        [self.delegate ExaminationResults:self didClickType:ExaminationResultseGoToWrong];
        
    }
    
}

//  再来一次
- (IBAction)clickexaminationAgainBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ExaminationResults:didClickType:)]) {
        [self.delegate ExaminationResults:self didClickType:ExaminationResultseGoToAgain];
    }
}

- (IBAction)clickHomeBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ExaminationResults:didClickType:)]) {
        
        [self.delegate ExaminationResults:self didClickType:ExaminationResultseGoToHome];
        
    }
}

-(void) setModel:(ResultsModel *)model
{
    
    self.rankingLable.text = [NSString stringWithFormat:@"%ld" , model.Rank];
    self.topicCountLable.text =[NSString stringWithFormat:@"本次考试获得 %ld 分" , model.Scores];
    self.WrongCountLable.text =[NSString stringWithFormat:@"共 %ld 道题, 错题 %ld 道题" , model.TotalNum , model.errNum];
    self.scoreLable.text =[NSString stringWithFormat:@"%ld" , model.Scores];


}

@end
