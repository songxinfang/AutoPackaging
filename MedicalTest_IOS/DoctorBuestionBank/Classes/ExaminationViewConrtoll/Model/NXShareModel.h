//
//  NXShareModel.h
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/10/20.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    NXShareTypeWeixinFriends = 0,   /**< 微信好友 */
    NXShareTypeWeixinCircle,        /**< 微信朋友圈 */
    NXShareTypeWeibo,               /**< 新浪微博 */
    NXShareTypeQQ,                  /**< QQ */
    NXShareTypeQzone,               /**< 空间 */
    NXShareTypeTengxunWeibo         /**< 腾讯微博 */
} NXShareType;  // 分享的类型

@interface NXShareModel : NSObject

@property (nonatomic, copy) NSString *iconName;  /**< 图片名称 */
@property (nonatomic, copy) NSString *describe;  /**< 描述 */
@property (nonatomic, assign) NXShareType shareType;  /**< 分享的类型 */

@end
