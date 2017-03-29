//
//  HTTPModel.m
//  WKDoctor
//  网络数据基类
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import "HTTPModel.h"
#import "HTTPRequestErrorHandler.h"


NSString *const KKBusinessErrorDomain = @"KKBusinessErrorDomain";

@implementation HTTPModel

- (void)parserResponse:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        self.isSuccess = YES;
        if ([data objectForKey:@"code"])
        {
            self.code = [[data objectForKey:@"code"] integerValue];
           
        }
        self.msg = [data objectForKey:@"msg"];
        if([data objectForKey:@"data"])
        {
            self.data = [data objectForKey:@"data"];
            
            
//            if(self.code == ERR_CODE_SUCCESS){
//            
//                if ((![self.data isKindOfClass:[NSDictionary  class]]) && (![self.data isKindOfClass:[NSMutableDictionary class]])) {
//                    self.code = ERR_CODE_FATAL_Format;
//                    
//                }
//            }
            
        }
        else
        {
            self.data = data;
        }
    }
    else
    {
        self.code = ERR_CODE_FATAL_Format;

        self.data = data;
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%@", key);
}


-(void) setValue:(id)value forKey:(NSString *)key
{
    id newValue = nil;
    if(value)
    {
        newValue = value;
    }
    
    [super setValue:newValue forKey:key];
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"code : %d msg: %@ ",
            (int) _code,_msg];
    
}

- (instancetype) init
{
    if (self = [super init ]) {
        self.isSuccess = true;
    };
    
    return self;
}

@end
