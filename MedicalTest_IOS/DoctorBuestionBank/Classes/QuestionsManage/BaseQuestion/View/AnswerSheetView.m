//
//  AnswerSheetView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "AnswerSheetView.h"
#import "AnswerSheeCell.h"

#import "AnswerSheeSectionView.h"



#define AnswerSheetViewIdentifer @"AnswerSheetViewIdentifer"
#define AnswerSheetViewIdentifeHeaderSection  @"AnswerSheetViewIdentifeHeaderSection"


@interface AnswerSheetView ()<UICollectionViewDelegate, UICollectionViewDataSource , AnswerSheeSectionViewDelegate>

@property(nonatomic , strong) UICollectionView * collectionView;

@property (nonatomic,strong) NSArray  <QuestionInfo *> * DateArr;

@property(nonatomic , assign) NSInteger completeCount;
@property(nonatomic , assign) NSInteger NoCompleteCount;

@property(nonatomic , strong) NSMutableDictionary  *IndexPathDic;
@property(nonatomic , strong) NSMutableDictionary  *orderDic;




@end


@implementation AnswerSheetView



- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupCollectionView];
    }
    
    
    self.isShowSectionHeader = TRUE;
  
    
    self.backgroundColor = [UIColor colorFromHexRGB:@"fafafa"];
    
    
    return self;
}


- (void)setupCollectionView
{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = self.width/5.0;
    layOut.itemSize = CGSizeMake(width, width);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumInteritemSpacing = 0.0;
    layOut.minimumLineSpacing = 0.0;
    layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height ) collectionViewLayout:layOut];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerNib:[UINib nibWithNibName:@"AnswerSheeCell" bundle:nil] forCellWithReuseIdentifier:AnswerSheetViewIdentifer];
    collectionView.pagingEnabled = YES;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    
    
     [collectionView registerNib:[UINib nibWithNibName:@"AnswerSheeSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AnswerSheetViewIdentifeHeaderSection];
    
    
    
    [self addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    
    
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.DateArr.count;
}

-(CollectionViewCellColorType) colourTypeWithModel:(QuestionInfo *) model  IndexPath:(NSIndexPath *)indexPath
{
    
    
    BOOL choose = false;
    BOOL right = true;
    
    Question *q = model.QuestionArr.firstObject;
    if (model.QuestionArr.count > 1) {
        
        NSString * key = [NSString stringWithFormat:@"%ld" , indexPath.item ];
        
        if ([self.orderDic.allKeys containsObject:key]) {
            
            NSInteger order = [self.orderDic[key] integerValue];
            q = model.QuestionArr[order];
            
        }
        
    }
    
    if (q.User_SelectSet.count > 0) {
        choose = true;
    }
    
    if (q.User_SelectStatus != UserSelectCorrect) {
        right = false;
    }
    
    if (self.questionType == QuestionResultPractice) {
        
        if (q.isMakeSure) {
            if(choose){
                if (right) {
                    return UCollectionViewCellColorRight;
                    
                }else{
                    return UCollectionViewCellColorWrong;
                    
                }
                
                
            }else{// 未选择
                return  UCollectionViewCellColorNone;
            }
            
        }else{
            return  UCollectionViewCellColorNone;

        
        }
        
    
        
        
    }else if(self.questionType == QuestionResultExamination){
    
        if (self.isExamination) {
            if (right) {
                return UCollectionViewCellColorRight;
                
            }else{
                return UCollectionViewCellColorWrong;
                
            }
        }else
        {
            if (choose) {
                return UCollectionViewCellColorSelect;
                
            }else{
                return UCollectionViewCellColorNone;
                
            }
            
        
        }
    
    }
    


    return 0;
    
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    QuestionInfo * model = self.DateArr[indexPath.item];


    CollectionViewCellColorType type = [self colourTypeWithModel:model IndexPath:indexPath];
    
    
    AnswerSheeCell * cell = (AnswerSheeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:AnswerSheetViewIdentifer forIndexPath:indexPath];
    
    cell.item = model.order;

    cell.colorType = type;
    
    
    
    return cell;

}


-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    
    
     AnswerSheeSectionView * view =   [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier: AnswerSheetViewIdentifeHeaderSection forIndexPath:indexPath];
    
    view.delegate = self;
    
    view.completeCount = self.completeCount;
    view.NoCompleteCount = self.NoCompleteCount;
    
    return view;
    

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (self.isShowSectionHeader) {
        return CGSizeMake(self.width, 44);

    }else{
        return CGSizeMake(0, 0);

    
    }

    

}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    
    if ([self.SheetViewDelegate respondsToSelector:@selector(AnswerSheetView:isSection:IndexPath:)]) {
        
        NSString * key = [NSString stringWithFormat:@"%ld" , indexPath.item];
        
        NSIndexPath * newIndexPath = self.IndexPathDic[key];
        
        [self.SheetViewDelegate AnswerSheetView:self isSection:NO IndexPath:newIndexPath];
    }
    
}



-(void) setDataSource:(NSArray<NSArray<QuestionInfo *> *> *)dataSource
{

    NSMutableArray * mArr = [NSMutableArray array];
    self.completeCount = 0;
    self.NoCompleteCount = 0;
    [self.orderDic removeAllObjects];
    

    
    NSInteger total = 0;
    
    NSInteger section = 0;
    
    
    for (NSArray * modeArr in dataSource) {
        
        NSInteger item = 0;

        
        for ( QuestionInfo * model in modeArr) {
           
            
            BOOL isComplete = true;
            for (Question * q in model.QuestionArr) {
                
                if (q.User_SelectSet.count == 0) {
                    isComplete   = false;
                    break;
                    
                }
            }
            
            if (isComplete) {
                self.completeCount++;
                
            }else{
                self.NoCompleteCount++;
            }
            
            for (NSInteger i = 0; i < model.QuestionArr.count; i++) {
                
                [mArr addObject:model];
                
                NSString * key = [NSString stringWithFormat:@"%ld" , total];
                
                NSIndexPath * path = [NSIndexPath indexPathForRow:item inSection:section];
                
                self.IndexPathDic[key] = path;
                
                total++;
                if (i > 0) {
                 
                    NSString   * order = [NSString stringWithFormat:@"%ld" , i];
                    self.orderDic[key] = order;
                    
                }


            }
            
           
            
            item++;

            
            
            
        }
        section++;
        
        
    }
    
    _DateArr = [mArr copy];
    
    [self.collectionView reloadData];
    
    
}



-(void ) didClickAnswerSheeSectionView
{

    if ([self.SheetViewDelegate respondsToSelector:@selector(AnswerSheetView:isSection:IndexPath:)]) {
        
        [self.SheetViewDelegate AnswerSheetView:self isSection:YES IndexPath:nil];
        
    }
    

}


-(NSMutableDictionary *) IndexPathDic
{
    if (!_IndexPathDic) {
        _IndexPathDic = [NSMutableDictionary dictionary ];
    }
    
    return _IndexPathDic;
    

}

//c

-(NSMutableDictionary *) orderDic
{
    if (!_orderDic) {
        _orderDic = [NSMutableDictionary dictionary ];
    }
    
    return _orderDic;
    
    
}


@end
