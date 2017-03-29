//
//  HttpTools.m
//  XYWYComponents
//
//  Created by 王辉 on 16/4/26.
//  Copyright © 2016年 xywy. All rights reserved.
//

#import "HttpTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkReachabilityManager.h"

@implementation HttpTools
+ (NSString *)generateURLPathWithGetParameters:(NSDictionary *)getParams
{
    if (getParams.count > 0)
    {
        NSMutableString *buffer = [NSMutableString stringWithString:@""];
        NSArray *keyArray = getParams.allKeys;
        for (NSString *key in keyArray)
        {
            if ([key isEqualToString:@"sign"] ||
                [key isEqualToString:@"file"] ||
                [key isEqualToString:@"files"])
            {
                
                break;
            }
            id value = getParams[key];
            
            if ([value isEqual:[NSNull null]])
            {
                value = @"";
            }
            
            if (![value isKindOfClass:[NSString class]])
            {
                value = [NSString stringWithFormat:@"%@", value];
            }
            
            //须对value进行URLEncode。
            NSString *strForKey = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            strForKey = [HttpTools URLEncodeString:strForKey];
            if ([key isEqual:keyArray.lastObject])
            {
                [buffer appendFormat:@"%@=%@",key, strForKey];
            }
            else
            {
                [buffer appendFormat:@"%@=%@&",key, strForKey];
            }
        }
        return buffer;
    }
    else
    {
        return @"";
    }
}

+ (NSString *)signWithGetParameters:(NSDictionary *)getParams
                     postParameters:(NSDictionary *)postParams
                                key:(NSString *)key
{
    
    /*!
     *  @brief  签名规则:将get参数以及post参数合并，若出现key重复，则post参数对应的value覆盖get参数的value，key只保留一个，同时value进行URLEncode，然后对合并后生成的集合中的key进行排序并按照('key=value' + '&key1=value1' + 'private key')规则拼接后md5。key中不应包含sign以及file。
     */
    
    //进行字典合并。
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:getParams];
    if (postParams && ![postParams isEqual:[NSNull null]]) {
        [params addEntriesFromDictionary:postParams];
    }
    
    NSMutableString *buffer = [NSMutableString string];
    if (params.count > 0)
    {
        //根据key排序并拼接。
        NSArray *resultArray = [params.allKeys sortedArrayUsingComparator:
                                ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
                                {
                                    return [obj1 compare:obj2 options:NSLiteralSearch];
                                }];
        
        for (NSString *key in resultArray)
        {
            if ([key isEqualToString:@"sign"] ||
                [key isEqualToString:@"file"] ||
                [key isEqualToString:@"files"])
            {
                break;
            }
            
            id value = params[key];
            if ([value isEqual:[NSNull null]])
            {
                value = @"";
            }
            
            if (![value isKindOfClass:[NSString class]])
            {
                value = [NSString stringWithFormat:@"%@", value];
            }
            
            //须对value进行URLEncode。
            if ([key isEqual:resultArray.lastObject]) {
                [buffer appendFormat:@"%@=%@",key, [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            }
            else {
                
                [buffer appendFormat:@"%@=%@&",key, [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];//URLEncodeString
            }
        }
    }
    
    [buffer appendString:key];
    NSLog(@"~~~~~~~~~~~~~~~~~~~%@", buffer);
    
    return [HttpTools MD5Hash:buffer];
}

+ (NSString *)URLEncodeString:(NSString *)str
{
    return [str stringByAddingPercentEncodingWithAllowedCharacters:
            [NSCharacterSet URLHostAllowedCharacterSet]];
}

+ (NSString *)MD5Hash:(NSString *)str
{
    
    if(str == nil || [str length] == 0)
        return nil;
    
    const char *value = [str UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

// 检测网络连接状态
+ (BOOL)netStatus
{
    AFNetworkReachabilityStatus networkReachabilityStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable ||
        networkReachabilityStatus == AFNetworkReachabilityStatusUnknown)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
@end
