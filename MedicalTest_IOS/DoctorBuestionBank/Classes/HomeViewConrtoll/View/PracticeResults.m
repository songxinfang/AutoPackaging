//
//  PracticeResults.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/21.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "PracticeResults.h"
#import "ResultsModel.h"


@interface PracticeResults ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OverTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *topicCountLable;
@property (weak, nonatomic) IBOutlet UILabel *WrongCountLable;

@property (weak, nonatomic) IBOutlet UILabel *OverLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WrongBtnTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *WrongBtn;
@property (weak, nonatomic) IBOutlet UIButton *PracticeAgainBtn;   /**< 再来一次 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *backImageVIew;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topconstraint4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstranint5;


@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *resultBackImageView;
@property (weak, nonatomic) IBOutlet UILabel *allTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *errTitleLable;
@end



@implementation PracticeResults


+(instancetype) Results
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void) awakeFromNib
{
    
    [super awakeFromNib];
    
    self.topicCountLable.layer.cornerRadius = 5.0;
    self.topicCountLable.clipsToBounds = YES;
    self.WrongCountLable.layer.cornerRadius = 5.0;
    self.WrongCountLable.clipsToBounds = YES;
    
    CGFloat y = SCREEN_WIDTH*206.0/375.0;
    
    [self.OverLable mas_updateConstraints:^(MASConstraintMaker *make) {
        
        self.OverTopConstraint.constant = y;
        
        
    }];
    
    CGFloat h = SCREEN_HEIGHT*350.0/600.0;
    [self.backImageVIew mas_updateConstraints:^(MASConstraintMaker *make) {
        self.backViewHeight.constant = h;
        
        
    }];
    
    

    if (SCREEN_WIDTH == 320 && SCREEN_HEIGHT == 480) {
        
//        [self.backHomeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            self.topConstraint1.constant = 5;
//            
//        }];
        
        [self.allTitleLable   mas_updateConstraints:^(MASConstraintMaker *make) {
            self.topConstraint3.constant = 10;
            
        }];
        
        
        [self.WrongBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            self.topConstraint2.constant = 10;
            
        }];
        
        
        [self.backHomeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            self.topconstraint4.constant = 10;
        }];
        
        [self.errTitleLable mas_updateConstraints:^(MASConstraintMaker *make) {
            
            self.topConstranint5.constant = 5;
        }];
        
        
        
        
    }
    
    
    
}



- (IBAction)clickWrongBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(PracticeResults:didClickType:)]) {
        
        [self.delegate PracticeResults:self didClickType:PracticeResultsGoToWrong];
        
    }
}

// 再来一次
- (IBAction)clickPracticeAgainBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(PracticeResults:didClickType:)]) {
        [self.delegate PracticeResults:self didClickType:PracticeResultsGoToAgain];
    }
}


- (IBAction)clcikHomeBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(PracticeResults:didClickType:)]) {
        
        [self.delegate PracticeResults:self didClickType:PracticeResultsGoToHome];
        
    }
}

-(void) setModel:(ResultsModel *)model
{
    _model = model;
    
    
    self.topicCountLable.text =[NSString stringWithFormat:@"%ld" , model.TotalNum];
    self.WrongCountLable.text =[NSString stringWithFormat:@"%ld" , model.errNum];

}


@end
