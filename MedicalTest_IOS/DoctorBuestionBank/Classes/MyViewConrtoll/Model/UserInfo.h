//
//  UserInfo.h
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//// 昵称的存取
//+ (NSString *)getUserName;
//+ (NSString *)getUserNameWithDefault:(NSString *)str;
//+ (void)setUserName:(NSString *)name;
//
//// 头像路径的存取
//+ (NSString *)getUserHeadImagePath;


+ (void)setFirstGuideStatus:(BOOL)status;
+ (BOOL)getGuideStatus;


@end
