//
//  NXShareView.h
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NXShareView;

@protocol NXShareViewDelegate <NSObject>

@optional

- (void)NXShareView:(NXShareView *)shareView didSelectedItem:(NSInteger)item thumbImage:(UIImage *)thumbImage shareImage:(UIImage *)shareImage;

@end

@interface NXShareView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;  /**< 数据模型 */
@property (nonatomic, strong) UIImage *thumbImage;        /**< 要分享图片的缩略图 */
@property (nonatomic, strong) UIImage *shareImage;        /**< 要分享的图片 */

//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView;

@property (nonatomic, weak) id<NXShareViewDelegate> delegate;


@end
