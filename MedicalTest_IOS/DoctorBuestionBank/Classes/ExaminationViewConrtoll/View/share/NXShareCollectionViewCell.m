//
//  NXShareCollectionViewCell.m
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/10/20.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NXShareCollectionViewCell.h"

@interface NXShareCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;   /**< icon */
@property (weak, nonatomic) IBOutlet UILabel *describe;   /**< 描述 */

@end

@implementation NXShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShareModel:(NXShareModel *)shareModel {
    _shareModel = shareModel;
    self.icon.image = [UIImage imageNamed:_shareModel.iconName];
    self.describe.text = _shareModel.describe;
    
}

@end
