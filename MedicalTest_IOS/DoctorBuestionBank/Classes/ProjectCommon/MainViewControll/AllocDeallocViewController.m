//
//  AllocDeallocViewController.m
//  DoctorPlatForm
//
//  Created by 宋志明 on 15-4-15.
//  Copyright (c) 2015年 songzm. All rights reserved.
//

#import "AllocDeallocViewController.h"

@interface AllocDeallocViewController ()

@end

@implementation AllocDeallocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#ifdef DEBUG
static NSMutableDictionary *s_allocInfo;
#endif

#pragma mark - init and dealloc
- (id)init {
    if (self = [super init]) {
        [self doctorInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self doctorInit];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self doctorInit];
    }
    return self;
}

- (void)doctorInit {
#ifdef DEBUG
    NSLog(@"----------------创建类----------------%@", NSStringFromClass([self class]));
    
    if (!s_allocInfo) {
        s_allocInfo = [NSMutableDictionary dictionary];
    }
    
    s_allocInfo[NSStringFromClass([self class])] = @([s_allocInfo[NSStringFromClass([self class])] intValue] + 1);
    NSLog(@"%@", s_allocInfo);
#endif
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"----------------释放类----------------%@",  NSStringFromClass([self class]));
    s_allocInfo[NSStringFromClass([self class])] = @([s_allocInfo[NSStringFromClass([self class])] intValue] - 1);
    if ([s_allocInfo[NSStringFromClass([self class])] intValue] == 0) {
        [s_allocInfo removeObjectForKey:NSStringFromClass([self class])];
    }
    NSLog(@"%@", s_allocInfo);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}


@end
