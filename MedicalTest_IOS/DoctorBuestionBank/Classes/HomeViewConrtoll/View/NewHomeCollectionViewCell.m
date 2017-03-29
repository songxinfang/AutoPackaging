//
//  NewHomeCollectionViewCell.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/18.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NewHomeCollectionViewCell.h"
#import "GradeTabView.h"

#define HomeCollectionViewCellBaseWidth 73.75


@interface NewHomeCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *gardeBackView;

@property(nonatomic , weak) GradeTabView *gradeView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GradeViewWidthConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GradeViewTopConstraint;

@property(nonatomic , assign) CGFloat GradeViewWidth;



@end



@implementation NewHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizingMask = NO;
    
    self.backImageView.image = [UIImage imageNamed:@"homeCellBackImage"];

    
    self.backgroundColor = [UIColor clearColor];
    
    self.GradeViewWidth = HomeCellWidth*22.0/HomeCollectionViewCellBaseWidth;
    
    
    
    
    [self.gardeBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        
        self.GradeViewWidthConstraint.constant =self.GradeViewWidth;
        
        self.GradeViewTopConstraint.constant =-self.GradeViewWidth/2 -2;
        
        
        
        
    }];
    
    
    [self layoutIfNeeded];

    
    [self setupGradeView];
    

        
}



-(void ) setupGradeView
{
    
    GradeTabView *gradeView = [[GradeTabView alloc] initWithGrade:GradeTypeBig GradeTabType:GradeTabType_S Point:CGPointMake(0, 0) Width:self.GradeViewWidth];
    
    [self.gardeBackView   addSubview:gradeView];
    gradeView.userInteractionEnabled = YES;
    
    self.gradeView = gradeView;
   
    
}

-(void) setModel:(QuestionLevelModel *)model
{
    
    CGFloat fontSize =HomeCellWidth*13.0/HomeCollectionViewCellBaseWidth;
    
    if (model.levelType == 1) {
        fontSize = fontSize*2;
    }
    
    
    [self.contentLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    _contentLabel.text = model.LevelName;
    
    
    
    [self.gradeView chageType:model.type];
    
}

-(void) setDuTime:(CGFloat)duTime
{
    _duTime     = duTime    ;
    
    
    self.backImageView.image = [UIImage imageNamed:@"homeCellBackImageSelect"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.backImageView.image = [UIImage imageNamed:@"homeCellBackImage"];


    });
    

}



@end
