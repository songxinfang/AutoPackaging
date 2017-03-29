//
//  UserInfo.m
//  DoctorBuestionBank
//
//  Created by 宋欣芳 on 2016/9/22.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "UserInfo.h"

//static NSString* const kUserImage = @"userImage";
//static NSString* const kUserName = @"userName";
static NSString* const kFirstGuide = @"app_first_guide_key";

@implementation UserInfo

//// 昵称的存取
//+ (NSString *)getUserName
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
//}
//
//+ (NSString *)getUserNameWithDefault:(NSString *)str
//{
//    NSString *name = [self getUserName];
//    
//    if (name == nil) {
//        return str;
//    }
//    
//    return name;
//}
//
//+ (void)setUserName:(NSString *)name
//{
//    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kUserName];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//// 头像路径的存取
//+ (NSString *)getUserHeadImagePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:@"userhead"];
//    NSString *filePath = [myDirectory stringByAppendingPathComponent:@"userheadpic.png"];
//
//    return filePath;
//}

+ (void)setFirstGuideStatus:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:kFirstGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getGuideStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstGuide];
}

@end
