//
//  NXShareBottomView.m
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/11/2.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NXShareBottomView.h"

@interface NXShareBottomView ()

@property (weak, nonatomic) IBOutlet UIImageView *QRcode;  /**< 二维码 */

@property (weak, nonatomic) IBOutlet UILabel *version; /**< 版本号 */
@property (weak, nonatomic) IBOutlet UILabel *appName; /**< app名字 */
@property (weak, nonatomic) IBOutlet UILabel *appDescribe; /**< app介绍 */
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionContainerHeight;  /**< 版本label容器的高度 */
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionContainerWidth;   /**< 版本label容器的宽度 */


@end

@implementation NXShareBottomView



- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.QRcode.layer.borderWidth = 1;
    self.QRcode.layer.borderColor = [UIColor colorWithHexString:@"A8ADD0"].CGColor;
    self.version.text = [self getCurrentVersion];
    
    if (SCREEN_WIDTH < 375) {
        [self.appName setFont:[UIFont systemFontOfSize:12]];
        [self.appDescribe setFont:[UIFont systemFontOfSize:9]];
//        self.versionContainerWidth.constant = 24;
//        self.versionContainerHeight.constant = 8;
    }
    NSLog(@"appName - %@ ; appDescribe - %@",self.appName,self.appDescribe);
    
}

- (NSString *)getCurrentVersion {
    // 获得当前软件的版本号
    //    NSString *key = @"CFBundleVersion";   //  build号
    NSString *key = @"CFBundleShortVersionString";   // app版本号
    NSString *build = [NSBundle mainBundle].infoDictionary[key];
    NSString *version = [NSString stringWithFormat:@"V%@",build];
    return version;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
