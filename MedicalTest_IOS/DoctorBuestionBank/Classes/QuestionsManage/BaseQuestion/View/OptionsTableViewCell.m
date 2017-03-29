//
//  OptionsTableViewCell.m
//  DoctorBuestionBank
//
//  Created by lc on 16/9/23.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "OptionsTableViewCell.h"
#import "QuestionsApi.h"
#import "QuestionDataHandleTool.h"


@interface OptionsTableViewCell ()


@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@end


@implementation OptionsTableViewCell

-(void) awakeFromNib
{
    [super awakeFromNib];
    self.optionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16 -24 -8 -8;
    

}


+(instancetype ) cellWithTableView:(UITableView *) tableView
{
    
    static NSString *cellId = @"TheTitleTableViewCellId";
    OptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    }
    
    return  cell;
    
    
}


- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}
- (void)setModel:(QuestionInfo *)model
{
    

    _model = model;
    
    
    Question * qModel = model.QuestionArr[self.index];
    
    
    NSArray * answerArray = [qModel.AnswerStr componentsSeparatedByString:@"|"];
    
    
    self.optionLabel.text = answerArray[self.indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"MedicalExaminationAnswer_%ld",_indexPath.row];
    [self.optionBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self layoutIfNeeded];
    
    
    // 计算高度
    CGFloat  cellHeight = self.optionLabel.frame.origin.y + self.optionLabel.frame.size.height + 16;
    NSString * cellHeightKey = [NSString stringWithFormat:@"%ld" , _indexPath.item];
    qModel.cellHeightDic[cellHeightKey] = @(cellHeight);
    
    // 设置被选中的背景色
    
    if (qModel.User_SelectSet.count > 0  ){

        for (NSString * str in qModel.User_SelectSet) {
            
            NSInteger item = [self changeToInt:str];
            
            if (item == self.indexPath.item) { // 选择了改选项
                self.backgroundColor = [UIColor colorFromHexRGB:@"ecf0f7"];
            }
        }
        
        // 判断是否正确
       // BOOL isRight = true;
        
        [QuestionDataHandleTool  isRingtWithModel:qModel];
        
        
//        if (qModel.User_SelectSet.count == qModel.CorrectSet.count) {
//            qModel.User_SelectStatus = UserSelectCorrect;
//            
//            
//            for (NSString * str in qModel.User_SelectSet) {
//                
//                if (![qModel.CorrectSet containsObject:str]) {
//                    
//                    isRight = false;
//                    qModel.User_SelectStatus = UserSelectWrong;
//                    break;
//                }
//            }
//            
//        }else{
//            qModel.User_SelectStatus = UserSelectWrong;
//            isRight = false;
//        }
        
        
        if(qModel.isMakeSure){ // 用户点击了确定
            
            
            for (NSString * str in qModel.User_SelectSet) { // 设置用户的选择
                
                NSInteger item = [self changeToInt:str];
                
                if (item == self.indexPath.item) { // 选择了改选项
                    if(qModel.User_SelectStatus == UserSelectCorrect){
                        [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"MedicalExaminationRight_1"] forState:UIControlStateNormal];
                        
                        
                    }else{
                        [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"MedicalExaminationRight_0"] forState:UIControlStateNormal];
                        
                    }
                    
                }
                
            }
            
            for (NSString * str in qModel.CorrectSet) { // 设置正确答案
                NSInteger item = [self changeToInt:str];
                
                if (item == self.indexPath.item) {
                    
                    [self.optionBtn setBackgroundImage:[UIImage imageNamed:@"MedicalExaminationRight_1"] forState:UIControlStateNormal];
                    
                }
            }
            
        }

        
    }else{
        qModel.User_SelectStatus = UserNoneSelect;

    }
    
    
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
