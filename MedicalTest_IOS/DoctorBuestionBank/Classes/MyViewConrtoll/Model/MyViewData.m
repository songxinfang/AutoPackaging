//
//  MyViewData.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "MyViewData.h"

@implementation MyViewData

+ (instancetype)dataWith:(NSString *)icon title:(NSString *)title action:(NSInteger)index
{
    MyViewData *data = [[MyViewData alloc] init];
    
    data.m_Icon = icon;
    data.m_Title = title;
    data.m_ActionIndex = index;
    
    return data;
}


+ (instancetype)dataWith:(NSString *)icon title:(NSString *)title pushVC:(NSString *)vc
{
    MyViewData *data = [[MyViewData alloc] init];
    
    data.m_Icon = icon;
    data.m_Title = title;
    data.m_PushVC = vc;
    
    return data;
}

@end
