//
//  HTTPModel.h
//  WKDoctor
//  网络数据基类
//  Created by Helen on 15/11/10.
//  Copyright © 2015年 NXAristotle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface HTTPModel : NSObject

@property (nonatomic, assign)NSInteger code;
@property (nonatomic, strong)NSString  *msg;
@property (nonatomic, strong)id        data;
@property (nonatomic, assign)BOOL      isSuccess;
@property (nonatomic, strong)NSError   *error;

 /**
 *  数据解析函数
 *
 *  @param data 网络返回数据
 *
 *  @return 解析后结果
 */
- (void)parserResponse:(id)data;

@end
