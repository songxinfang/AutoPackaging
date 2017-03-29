//
//  MyViewData.h
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyViewData : NSObject

@property (nonatomic, copy) NSString *m_Icon;
@property (nonatomic, copy) NSString *m_Title;
@property (nonatomic, copy) NSString *m_PushVC;
@property (nonatomic, assign) NSInteger m_ActionIndex;

+ (instancetype)dataWith:(NSString *)icon title:(NSString *)title action:(NSInteger)index;
+ (instancetype)dataWith:(NSString *)icon title:(NSString *)title pushVC:(NSString *)vc;

@end
