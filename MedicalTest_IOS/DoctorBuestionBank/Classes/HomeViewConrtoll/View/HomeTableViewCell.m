//
//  HomeTableViewCell.m
//  DoctorBuestionBank
//
//  Created by lc on 16/10/8.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "GradeTabView.h"
#import "QuestionModel.h"
#import <POPBasicAnimation.h>
#import <POPSpringAnimation.h>

@interface HomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLable;
@property (weak, nonatomic) IBOutlet UIView *gradBackView;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype ) cellWithTableView:(UITableView *) tableView
{
    static NSString *cellId = @"HomeTableViewCellId";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    }
    
    return  cell;
}

-(void) setModel:(QuestionTopicModel *)model
{
    _model = model;
    
    _titleLabel.text = _model.TopicName;
    
    self.numLable.text = [NSString stringWithFormat:@"%ld/%ld" , model.CompleteCount , model.AllCount];
    
    GradeTabView *gradView = [[GradeTabView alloc] initWithGrade:GradeTypeSmall GradeTabType:GradeTabType_Right Point:CGPointMake(0,0) Width:20];
    [self.gradBackView addSubview:gradView];
    
    if (model.isSelect)
    {
        [gradView chageType:GradeTabType_Right];
        self.backgroundColor = [UIColor colorFromHexRGB:@"ecf1f7"];
    }
    else
    {
        
        [gradView chageType:model.type];
        self.backgroundColor = [UIColor whiteColor];

    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (self.selected) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.titleLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.95, 0.95)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 20.f;
        [self.titleLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }

    // Configure the view for the selected state
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
 


}


@end
