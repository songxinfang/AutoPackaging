//
//  ExaminationRequirementsConfig.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/9/14.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "ExaminationRequirementsConfig.h"

@implementation PracticeRequirementsConfig



@end

@implementation ExaminationRequirementsConfig

-(NSInteger )MaxGenerationNum
{
    if(_MaxGenerationNum == 0   ){
        
        return 3;
    }
    
    return _MaxGenerationNum;
    
    
}

-(NSInteger) GenerationGroupCount
{
    if (_GenerationGroupCount == 0) {
        _GenerationGroupCount = 4;
    }
    
    return _GenerationGroupCount;
    
    
}



@end
