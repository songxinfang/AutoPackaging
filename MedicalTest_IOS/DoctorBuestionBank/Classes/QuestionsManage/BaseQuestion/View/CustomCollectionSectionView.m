//
//  CustomCollectionSectionView.m
//  DoctorBuestionBank
//
//  Created by 杨强 on 16/10/11.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "CustomCollectionSectionView.h"



//#define MAS_SHORTHAND

#define MAS_SHORTHAND_GLOBALS

#import <Masonry.h>
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "NXBaiduMobAdView.h"
#import "UIView+NX.h"

@interface CustomCollectionSectionView ()<BaiduMobAdViewDelegate>
{
    NXBaiduMobAdView* sharedAdView;
}

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *TopicLable;
@property (weak, nonatomic) IBOutlet UILabel *centerLable;
@property (weak, nonatomic) IBOutlet UIView *adView;

@end


@implementation CustomCollectionSectionView

-(void)dealloc
{
    if (sharedAdView.delegate) {
        sharedAdView.delegate = nil;
        [sharedAdView removeFromSuperview];
        sharedAdView = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.TopicLable.preferredMaxLayoutWidth = SCREEN_WIDTH - 32;
    
    [self setupBaiduMobadsView];
   
}


//  1. 初始广告视图:
- (void)setupBaiduMobadsView {
    //使用嵌入干告的方法实例。
    sharedAdView = [NXBaiduMobAdView shareNXBaiduMobAdView]; //把在mssp.baidu.com上创建后获得的代码位id写到这里
    
    NSLog(@"%p", &sharedAdView);
    NSLog(@"%@" , sharedAdView);
    
    
    sharedAdView.AdUnitTag = BaiduMobAdsID;  /**< 代码位id */
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;

    CGSize adViewSize = self.adView.size;
    sharedAdView.frame = CGRectMake(0, 0 , adViewSize.width, adViewSize.height);
    sharedAdView.delegate = self;
    [self.adView addSubview:sharedAdView];
    [sharedAdView start];
}

//  2.设置信息

- (NSString *)publisherId {
    return BaiduMobAdsAPPID; //@"your_own_app_id";
}

//  3.可选 delegate 接口 (根据新广告法, 横幅添加了关闭按钮, 并有相关回调) 其他相关回调函数请参见 BaiduMobAdDelegateProtocol.h.

-(void) willDisplayAd:(BaiduMobAdView*) adview {
    NSLog(@"delegate: will display ad");
}

/*
 
 获取地理位置信息的可选接口 enableLocation. 对于 iOS8 及以后如果获取地理位置时需
 要进行适配。
 可以根据自己需要进行权限的控制，使用requestWhenInUseAuthorization或者 requestAlwaysAuthorization。获取方式可参照 demo 里的 plist 文件
 */
-(BOOL) enableLocation {
    //启用location会有一次alert提示,请根据系统进行相关配置
    return NO;
}


-(void) setTopicTitle:(NSString *)TopicTitle
{
    self.TopicLable.text = TopicTitle  ;
    
    self.TopicLable.hidden = NO;
    self.topicImageView.hidden = NO;
    self.centerLable.hidden = YES;
    
    


}

-(void) setCenterTitle:(NSString *)CenterTitle
{
    self.centerLable.text = CenterTitle;
    self.TopicLable.hidden = YES;
    self.topicImageView.hidden = YES;
    self.centerLable.hidden = NO;
    
    
}


-(void) layoutSubviews
{
    [super layoutSubviews];    

}





@end
