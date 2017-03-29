//
//  HomeContentView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "HomeContentView.h"
#import "HomeContentViewCell.h"
#import "CustomCollectionVIewLayout.h"

#define MAS_SHORTHAND_GLOBALS

#import <Masonry.h>


#define HomeContentViewIdentifer @"HomeContentViewIdentifer"


@interface HomeContentView ()<UICollectionViewDelegate , UICollectionViewDataSource , CustomCollectionVIewLayoutDelegage >


@property(nonatomic , weak) UICollectionView * collectionView;

@property(nonatomic ,assign) NSInteger currItem;

@property (weak, nonatomic) IBOutlet UIButton *praticeBtn;

@property (weak, nonatomic) IBOutlet UIButton *ExaminationBtn;



@end

@implementation HomeContentView


+(instancetype)ContentView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    

}

-(void) awakeFromNib
{
    
    [super awakeFromNib];
    
    _animatedFlag = true;

    self.autoresizingMask = NO;
    
    UIColor * colour = [UIColor colorFromHexRGB:@"f6b241"];
    
    [self.praticeBtn setBackgroundImage:[UIImage imageWithColor:colour] forState:UIControlStateHighlighted];
    [self.praticeBtn setBackgroundImage:[UIImage imageWithColor:colour] forState:UIControlStateSelected];

    [self.praticeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UIColor * ExaminationBtnColour = [UIColor colorFromHexRGB:@"48cf84"];

    [self.ExaminationBtn setBackgroundImage:[UIImage imageWithColor:ExaminationBtnColour] forState:UIControlStateSelected];
    [self.ExaminationBtn setBackgroundImage:[UIImage imageWithColor:ExaminationBtnColour] forState:UIControlStateHighlighted];

    [self.ExaminationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    
    
    self.praticeBtn.layer.cornerRadius = 5;
    self.praticeBtn.clipsToBounds = YES;
    self.ExaminationBtn.layer.cornerRadius = 5;
    self.ExaminationBtn.clipsToBounds = YES;
    
    CustomCollectionVIewLayout *layOut = [[CustomCollectionVIewLayout alloc] init];
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = 0.0;
    layOut.minimumInteritemSpacing = 0;
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layOut.delegate = self;
    

    CGFloat height =SCREEN_HEIGHT - FootViewHeight -HomeCellHeight -HomeCellLineSpace -NAVIGATION_HEIGH;
    layOut.itemSize = CGSizeMake(SCREEN_WIDTH, height);
    
    
    UICollectionView  *collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:layOut];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.scrollEnabled = YES;
    [collectionView registerNib:[UINib nibWithNibName:@"HomeContentViewCell" bundle:nil] forCellWithReuseIdentifier:HomeContentViewIdentifer];
    
    
    [self addSubview:collectionView];
    
    self.collectionView = collectionView;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.singleItem) {
        return 1;
    }else{
        return self.levelArr.count;

    }
    

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HomeContentViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeContentViewIdentifer forIndexPath:indexPath];
    
    NSArray <QuestionTopicModel *> * arr = nil;
    
    if (self.singleItem) {
        arr = self.TopicModelArr[self.currItem];
    }else{
        arr = self.TopicModelArr[indexPath.item];
    
    }
    
    cell.ChapterNum = indexPath.item;
    
    
    cell.modelArr =arr;
    
    
    
    return cell;
    



}

-(void)setLevelArr:(NSArray<QuestionLevelModel *> *)levelArr
{
    if (!self.singleItem) {
        
        _levelArr = levelArr;
        
        [self.collectionView reloadData];
        

    }
    

}

-(void) setTopicModelArr:(NSArray<NSArray<QuestionTopicModel *> *> *)TopicModelArr
{
    if (!self.singleItem) {
        
        _TopicModelArr = TopicModelArr ;
        
        [self.collectionView reloadData];
        
    }

    

}


-(void) setItem:(NSInteger)item
{
    
    _item = item;
    _currItem = item;
    
    if (!self.singleItem) {
        
        NSIndexPath * path = [NSIndexPath indexPathForRow:item inSection:0];
        [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:self.animatedFlag];
        
    }else
    {
        [self.collectionView reloadData];

    
    }
    

}



- (IBAction)clickPractice {
    
    
    
    
    if([self.delegate respondsToSelector:@selector(HomeContentView:didType:)]){
    
        [self.delegate HomeContentView:self didType:HomeContentViewClickPractice];
        
    
    }
    
    
    
}

- (IBAction)clickExamination {
    
  

    if([self.delegate respondsToSelector:@selector(HomeContentView:didType:)]){
        
        [self.delegate HomeContentView:self didType:HomeContentViewClickExamination];
        
        
    }

    
}

-(void)  CustomCollectionVIewLayout:(CustomCollectionVIewLayout *) view ProposedContentOffset:(CGPoint)proposedContentOffset
{
    
    
    NSInteger i = proposedContentOffset.x/SCREEN_WIDTH ;
    
    
    
    
    if (i != self.currItem) {
        
        if ([self.delegate respondsToSelector:@selector(HomeContentView:ScrollViewFromItem:toItem:)]) {
            
            [self.delegate HomeContentView:self ScrollViewFromItem:self.currItem toItem:i];
        }
        
        
        self.currItem = i;
        

    }
    
    
    

}


-(void) reloadAtIndexPath:(NSIndexPath *) indexPath
{
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    


}

//  再来一次
- (void)didAgainWith:(HomeContentViewClickType)clickType {
    if ([self.delegate respondsToSelector:@selector(HomeContentView:didAgainType:)]) {
        [self.delegate HomeContentView:self didAgainType:clickType];
    }
}

@end
