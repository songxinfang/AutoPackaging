//
//  QuestionResultVC.h
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/25.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "BaseController.h"




@interface QuestionResultVC : BaseController



@property (nonatomic,strong)NSArray < NSArray <QuestionInfo *> *> * dataSource;


@property(nonatomic , strong) ExaminationProperty * paperModel;


-(instancetype) initWithType: (QuestionResultType ) type;



@end
