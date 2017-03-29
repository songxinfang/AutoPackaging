//
//  BaseQuestionView.m
//  DoctorBuestionBank
//
//  Created by lc on 16/9/23.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseQuestionView.h"
#import "BaseQuestionCell.h"
#import "CustomCollectionSectionView.h"
#import "CustomCollectionVIewLayout.h"


#define identifer @"BaseQuestionCell"
#define identiferHeaderSection @"identiferHeaderSection"
#define identiferFooterSection @"identiferFooterSection"




@interface BaseQuestionView ()<BaseQuestionCellDelegate , CustomCollectionVIewLayoutDelegage , UICollectionViewDataSourcePrefetching>

@property(nonatomic , assign) NSInteger  order;


// 上一次的偏移量
@property(nonatomic , assign) CGPoint LastTimeContentOffset;
// 上一页和下一页将要的偏移量
@property(nonatomic , assign) CGPoint proposedContentOffset;


@property(nonatomic , strong) NSIndexPath * LastTimeIndexPath;
@property(nonatomic , strong) NSIndexPath * currIndexPath;

@property(nonatomic , weak) BaseQuestionCell* currCell;

// 是否点击了上一页或下一页
@property(nonatomic , assign) BOOL isClickPreOrNextBtn;

// 控制偏移量
@property(nonatomic , assign) CGPoint contentOffset;

@property(nonatomic , strong) NSMutableDictionary * orderDic;

@property(nonatomic , assign) CollectionViewStatus CollectionStatus;
@property(nonatomic , assign) CollectionViewStatus LastCollectionStatus;

@property(nonatomic , weak)UICollectionView *collectionView;

// 是否显示题型介绍
@property(nonatomic , assign) BOOL isShowSectionHeader;

// 是否显示完成页面
@property(nonatomic , assign) BOOL isShowSectionFooter;

@property(nonatomic , assign) CGFloat x ;



@end




@implementation BaseQuestionView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createCollectionView];
    }
    
    self.CollectionStatus = CollectionViewNone;
    self.LastCollectionStatus =CollectionViewNone;

    self.LastTimeContentOffset = CGPointMake(0, 0);
    
    
    
    self.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
    
    self.x = 0;
    

    return self;
}

-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{

    _dataSource = dataSource;
    
}

- (void)createCollectionView
{
    CustomCollectionVIewLayout *layOut = [[CustomCollectionVIewLayout alloc] init];
    layOut.delegate = self;
    
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) collectionViewLayout:layOut];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    if (IOS_VERSION >= 10) {
        
        collectionView.prefetchDataSource = self;
        collectionView.prefetchingEnabled = NO;

    }
    
    
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerNib:[UINib nibWithNibName:@"BaseQuestionCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    collectionView.pagingEnabled = YES;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identiferHeaderSection];
    
    
    
    [collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identiferFooterSection];
    
    
    [self addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.dataSource[section] count];
}



- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0)
{
    
    return;
    

}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.CollectionStatus = CollectionViewNone;

    self.currIndexPath = indexPath;

    BaseQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    cell.delegate = self;
    _currCell = cell;
    
    NSArray <QuestionInfo *> *  modelArr = self.dataSource[indexPath.section];
    
    QuestionInfo *model = modelArr[indexPath.row];
    
    cell.questionNum = (int)indexPath.row+1;
    cell.model = model;
    


    if (self.isClickPreOrNextBtn) {
        
        [self CustomCollectionVIewLayout:nil ProposedContentOffset:self.proposedContentOffset];
    }

    

    return cell;
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionSectionView * sectionView  = nil;
    
    
    if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
      
      sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier: identiferHeaderSection forIndexPath:indexPath];
        
        
        NSArray <QuestionInfo *> *  modelArr = self.dataSource[indexPath.section];
        QuestionInfo *model = modelArr.firstObject;
        if (model.QuestionArr.count > 1) {
             sectionView.TopicTitle = @"A2型题（病例摘要型最佳选择题）试题结构是由1个简要病历作为题干、5个供选择的备选答案组成，备选答案中只有1个是最佳选择";
           
        }else{
             sectionView.TopicTitle = @" A1型题（单句型最佳选择题）每道试题由1个题干和5个供选择的备选答案组成。题干以叙述式单句出现，备选答案中只有1个是最佳选择，称为正确答案，其余4个均为干扰答案。干扰答案或是完全不正确，或是部分正确。";
           
        }
        
      
        self.CollectionStatus = CollectionViewHeader;
        

    }else
    {

    
        sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier: identiferFooterSection forIndexPath:indexPath];
        
        if (self.questionType == QuestionResultExamination) {
            sectionView.CenterTitle = @"考试完成啦";

        }else if(self.questionType == QuestionResultPractice){
            sectionView.CenterTitle = @"练习完成啦";

        }
        self.CollectionStatus = CollectionViewFooter;


    }
    
    self.currIndexPath = indexPath;
    

    
    if (self.isClickPreOrNextBtn) {
        
        [self CustomCollectionVIewLayout:nil ProposedContentOffset:self.proposedContentOffset];
        
    }
    
    return sectionView;
    
   
    

}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
 
    if (self.isShowSectionHeader) {
        
        return  CGSizeMake(self.width, self.height);
    }
    
    return CGSizeMake(0, 0);


}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (self.isShowSectionFooter) {
        if (section == (self.dataSource.count -1)) {
            
            return  CGSizeMake(self.width, self.height);
            
        }
        
    }
   
    
    return CGSizeMake(0, 0);

}


-(void) setIsShowSectionFooter:(BOOL)isShowSectionFooter
{
    
    _isShowSectionFooter = isShowSectionFooter;

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSArray <QuestionInfo *> *  modelArr = self.dataSource[indexPath.section];
    QuestionInfo *model = modelArr[indexPath.item];
    NSInteger count =model.QuestionArr.count;
    CGFloat width = self.frame.size.width * count;
    
    if (count > 1) {
        for (NSInteger i = 0; i < count; i++) {
            
            
            CGFloat w = 0;
            
            if (self.isShowSectionHeader) {
                w =SCREEN_WIDTH * (indexPath.section +1);
            }
            
            
            
            NSString * key = [NSString stringWithFormat:@"%f" ,self.x + w];
            
            [self.orderDic setObject:[NSNumber numberWithInteger:i] forKey:key];
            self.x = self.x + self.frame.size.width;
            
        }

        
    }else{
        self.x= self.x + self.frame.size.width;

    }
    
    
    
    
    return CGSizeMake(width, self.frame.size.height);
}





// cell的代理方法
-(void) BaseQuestionCellDidSelect
{
    
    if ([self.delegate respondsToSelector:@selector(BaseQuestionView:numberOfItemsInData:CollectionStatus:selectOrder:)]) {
      
       //  [self.delegate BaseQuestionView:self numberOfItemsInData:self.currIndexPath CollectionStatus:self.CollectionStatus selectOrder:self.order ];
        
        [self.delegate BaseQuestionView:self numberOfItemsInData:self.currIndexPath CollectionStatus:self.LastCollectionStatus selectOrder:self.order ];
    }
    


}


#pragma mark CustomCollectionVIewLayout 代理方法
-(void)  CustomCollectionVIewLayout:(CustomCollectionVIewLayout *) view ProposedContentOffset:(CGPoint)proposedContentOffset
{

    
    
    if (self.LastTimeContentOffset.x != proposedContentOffset.x) {
        
        
        NSString *  tongjiStr = nil;
        if (self.LastTimeContentOffset.x <  proposedContentOffset.x) {
            tongjiStr = TongJiToolAllSlideToNext;
        }else{
            tongjiStr = TongJiToolAllSlideToPre;
        
        }
        [TongJiTool XYWYClickEvent:tongjiStr attributes:nil ];
        
        self.LastCollectionStatus = self.CollectionStatus;
        
        @synchronized (self) {
            
            // 同步数据  无论滚动还是点击上一页和下一页都会走改方法
            
            if ((self.questionType != PracticeWrongReview) &&  (self.questionType != ExaminationWrongReview  ) ) { // 同步练习数据
                NSArray <QuestionInfo *> *  modelArr = self.dataSource[self.LastTimeIndexPath.section];
                QuestionInfo *model = modelArr[self.LastTimeIndexPath.row];
                if(model.needSync){
                    [[QuestionsApi share] updateQuestionsWithModel:model];
                    
                    model.needSync = false;
                    
                }
                
            }
            
            
            if (self.isClickPreOrNextBtn == false) { // 非点击上一页和下一页
                if (self.LastTimeContentOffset.x >  proposedContentOffset.x) {
                    _contentOffset = CGPointMake(_contentOffset.x - SCREEN_WIDTH, 0);
                    
                    
                }else{
                    _contentOffset = CGPointMake(_contentOffset.x + SCREEN_WIDTH, 0);
                    
                }
                
                
            }else{
                self.isClickPreOrNextBtn = false;
            }
        }
        
        self.LastTimeContentOffset =  proposedContentOffset;
        self.LastTimeIndexPath   = self.currIndexPath;
        
        
        NSString * key = [NSString stringWithFormat:@"%f" ,self.LastTimeContentOffset.x];
        
        
        if( [self.orderDic.allKeys containsObject:key])
        {
            self.CollectionStatus = CollectionViewNone;
            
        
        }
        
        
        
        if ([self.delegate respondsToSelector:@selector(BaseQuestionView:numberOfItemsInData:CollectionStatus:selectOrder:)]) {
            
            [self.delegate BaseQuestionView:self numberOfItemsInData:self.currIndexPath CollectionStatus:self.CollectionStatus selectOrder:self.order ];
        }
        
        
    
    }else{
        self.CollectionStatus = self.LastCollectionStatus;
        self.currIndexPath = self.LastTimeIndexPath;
        self.currIndexPath = self.LastTimeIndexPath;
    
    }
                                                       

}

// 控制上一道题和下一道题
-(void) ScrollViewWithDirection:(BOOL) direction
{
    self.isClickPreOrNextBtn = YES;
   
        
    if (direction ) { // UICollectionView由于有动画  当快速点击下一页时其contentOffset可能不是最终值，故而需要自己记
        _contentOffset = CGPointMake(_contentOffset.x + SCREEN_WIDTH, 0);
        
    }else{
        _contentOffset = CGPointMake(_contentOffset.x - SCREEN_WIDTH, 0);
    }

    self.proposedContentOffset = _contentOffset;
    [_collectionView setContentOffset:_contentOffset animated:YES];
    
    
    NSString * key = [NSString stringWithFormat:@"%f" ,self.proposedContentOffset.x];
    
    if( [self.orderDic.allKeys containsObject:key])
    {
        self.CollectionStatus = CollectionViewNone;
        
        [self CustomCollectionVIewLayout:nil ProposedContentOffset:self.proposedContentOffset];
    }
    

    
}



-(void) setScrollToIndexPath:(NSIndexPath *)scrollToIndexPath
{
    _scrollToIndexPath = scrollToIndexPath;
    
    [_collectionView scrollToItemAtIndexPath:scrollToIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    self.currIndexPath = scrollToIndexPath;
    
    if ([self.delegate respondsToSelector:@selector(BaseQuestionView:numberOfItemsInData:CollectionStatus:selectOrder:)]) {
        
        [self.delegate BaseQuestionView:self numberOfItemsInData:self.currIndexPath CollectionStatus:CollectionViewNone selectOrder:0];
    }
    
    // 这个地方需要优化
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _contentOffset = _collectionView.contentOffset;
        _LastTimeContentOffset = _contentOffset;
        
    });
    
}


-(NSInteger) order
{
    NSInteger total = self.currCell.frame.size.width/self.frame.size.width;
    
    if (total == 1) {
        
        return 0;
    }
    
    NSString * key = [NSString stringWithFormat:@"%f" ,self.LastTimeContentOffset.x];
    
    NSInteger i = [self.orderDic[key] integerValue];
    
    return i;

}


-(void) setQuestionType:(QuestionResultType)questionType
{
    _questionType = questionType;
    
    // 设置题型设置和完成页面的控制
    
    self.isShowSectionHeader  = YES;
    self.isShowSectionFooter = NO;
    
    if((self.questionType == QuestionResultExamination ) )
    {
        self.isShowSectionFooter = YES;

        
    }

}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.00;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.00;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



-(void) reloadData
{
    [self.currCell reloadData];
}


-(NSMutableDictionary *) orderDic
{
    if (!_orderDic) {
        _orderDic = [NSMutableDictionary  dictionary];
    }
    
    return _orderDic;
    

}





@end
