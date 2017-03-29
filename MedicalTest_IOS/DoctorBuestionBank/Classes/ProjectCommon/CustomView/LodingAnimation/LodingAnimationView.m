//
//  LodingAnimationView.m
//  TestKvc
//
//  Created by 杨强 on 16/10/8.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "LodingAnimationView.h"
#import "LoadingImageCell.h"

#define LoadViewCellCount 1000
#define LoadViewCellHeight 115

#define LoadViewTimeInterval  0.1

#define ContentOffsetSpace  6








@interface LodingAnimationView ()<UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UITableView *imageTableView;



@property(nonatomic , assign) NSTimer *AnimationTimer;

@property(nonatomic , assign) BOOL isRun;

@property(nonatomic , assign) CGFloat userTimer;







@end



@implementation LodingAnimationView


+(instancetype)AnimationView
{

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    
}



-(void)awakeFromNib
{
    
    [super awakeFromNib];
    

    self.imageTableView.userInteractionEnabled = NO;
    self.frame = CGRectMake(0 , 64  ,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height -64);
    
    

    _isRun = false;
    
    [self.imageTableView reloadData];
    
    self.hidden = YES;
    
    self.progressView.layer.cornerRadius =5;
    self.progressView.clipsToBounds = YES;
    self.progressView.progress = 0;
    
    
    
    
    
    

}


-(void) start
{
    self.hidden = NO;

    [self.superview bringSubviewToFront:self];
    
    if (_isRun ) {
        return;
    }
    _isRun = true;
    
    self.userTimer = 0.00;
    
    

    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:LoadViewTimeInterval target:self selector:@selector(handleOffert) userInfo:nil repeats:YES];
    self.AnimationTimer = timer;
    
    
    
    
}

-(void) handleOffert
{
    
    
    CGPoint  point = CGPointMake(0, self.imageTableView.contentOffset.y - ContentOffsetSpace);

    [UIView animateWithDuration: LoadViewTimeInterval animations:^{
        [self.imageTableView setContentOffset:point];

        
    } completion:^(BOOL finished) {
        
        self.userTimer = self.userTimer +LoadViewTimeInterval;
        self.progressView.progress = self.userTimer /self.allTimer;
    }];
    
 



}


-(void) stop
{

    [self.AnimationTimer invalidate];
    self.AnimationTimer = nil;
    
    _isRun = false;
    
    self.hidden = YES;
    
    
    

}



-(void)willMoveToSuperview:(UIView *)newSuperview
{
   
    NSIndexPath *  BottomPath =  [ NSIndexPath indexPathForRow:LoadViewCellCount -1 inSection:0];

    [self.imageTableView scrollToRowAtIndexPath:BottomPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];


}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return LoadViewCellCount;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    LoadingImageCell * cell = [LoadingImageCell loadingCellWithTableView:tableView];

    return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return LoadViewCellHeight;

}





@end
