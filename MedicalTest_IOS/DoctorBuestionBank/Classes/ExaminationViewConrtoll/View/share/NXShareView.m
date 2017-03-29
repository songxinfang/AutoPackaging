//
//  NXShareView.m
//  DoctorBuestionBank
//
//  Created by linyibin on 2016/10/19.
//  Copyright © 2016年 杨强. All rights reserved.
//

#import "NXShareView.h"
#import "NXShareCollectionViewCell.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import "Masonry.h"
#import "NXShareTopView.h"
#import "NXShareBottomView.h"

#define Kidentifier @"NXShareCollectionViewCell"

#define kCollectionCellWidth  ([UIScreen mainScreen].bounds.size.width - 44) / 3
#define kCollectionCellHeight 78
#define kShareViewH 305

@interface NXShareView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cancel;   /**< 取消按钮 */
@property (weak, nonatomic) IBOutlet UIView *shareView;  /**< 分享view的容器 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHeight;  /**< 分享view的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottom;  /**< 分享view的底部约束 */
@property (nonatomic, assign) CGFloat shareViewH;       /**< 分享view的高度 */


@end

@implementation NXShareView

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:6];
        [self allAppCanShare];
    }
    return _dataArray;
}


#pragma mark - 生命周期

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupCollectionView];
}


#pragma mark - 页面初始化

//  初始化Collectionview
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:Kidentifier bundle:nil] forCellWithReuseIdentifier:Kidentifier];
}

- (void)layoutSubviews {
    
     NSLog(@"---- %s",__func__);
    [self setupShareViewContainer];  /**< 重新布局 */
    [super layoutSubviews];
}

//  设置分享view的容器
- (void)setupShareViewContainer {
    
    CGFloat shareViewH;
    
    self.dataArray.count > 3 ? (shareViewH = kShareViewH + 2) : (shareViewH = kShareViewH - 78 - 22);
    self.shareViewHeight.constant = shareViewH;
//    self.shareViewBottom.constant = -shareViewH;  //  初始化时隐藏
    self.shareViewH = -shareViewH;
 
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NXShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Kidentifier forIndexPath:indexPath];
    cell.shareModel = self.dataArray[indexPath.row];
    return cell;
}


#pragma mrak - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self hide];
    NSInteger index = -1;
    NXShareModel *item = self.dataArray[indexPath.row];
    switch (item.shareType) {
        case 0:
            index = 1;   /**< 微信 */
            break;
        case 1:
            index = 2;   /**< 朋友圈 */
            break;
//        case 2:
//            index = 0;  
//            break;
//        case 3:
//            index = 4;
//            break;
//        case 4:
//            index = 5;
//            break;
//        case 5:
//            index = 6;
//            break;
        default:
            break;
    }
    if (index == -1) {
        NSLog(@"分享的类型有误");
        return;
    }
//    [self shareImageToPlatformType:index];
    if ([self.delegate respondsToSelector:@selector(NXShareView:didSelectedItem:thumbImage:shareImage:)]) {
        [self.delegate NXShareView:self didSelectedItem:index thumbImage:self.thumbImage shareImage:self.shareImage];
    }
    NSLog(@"选择了第%zd个cell",indexPath.row);
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCollectionCellWidth, kCollectionCellHeight);
}


//  设置cell的行间隙（margin）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 24;
}

//  设置每行cell间的间隙
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

//定义整个UICollectionView 的 margin（整体）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,15,0,15);
}


#pragma mark - action

//  弹出动画
- (void)show {
    
    self.shareViewBottom.constant = 300;
    [UIView animateWithDuration:1.0f animations:^{
        [self layoutIfNeeded];
    }];
}

//  隐藏动画
- (void)hide {
    self.shareViewBottom.constant = self.shareViewH;
    [UIView animateWithDuration:0.5f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        self.hidden = YES;
    }];
    
}

//  取消
- (IBAction)cancel:(UIButton *)sender {
    NSLog(@"点击取消按钮");
    [self hide];
}

- (IBAction)cancelTap:(UITapGestureRecognizer *)sender {
    NSLog(@"点击蒙板");
    [self hide];
}

//分享图片
//- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建图片内容对象
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = self.thumbImage;
//    [shareObject setShareImage:self.shareImage];//@"http://dev.umeng.com/images/tab2_1.png"
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                NSLog(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                NSLog(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                NSLog(@"response data is %@",data);
//            }
//        }
//    }];
//}


//  根据安装的app判断可以分享到多少个平台，确认数据model
- (void)allAppCanShare {
    
    if ([WXApi isWXAppInstalled]) {
        NXShareModel *sharModel = [[NXShareModel alloc] init];
        sharModel.iconName = @"share_wx_HY";
        sharModel.shareType = NXShareTypeWeixinFriends;
        sharModel.describe = @"微信";
        
        [_dataArray addObject:sharModel];
        
        NXShareModel *sharModel1 = [[NXShareModel alloc] init];
        sharModel1.iconName = @"share_wx_PYQ";
        sharModel1.shareType = NXShareTypeWeixinCircle;
        sharModel1.describe = @"微信朋友圈";
        
        [_dataArray addObject:sharModel1];
       
    }
    
    //  其他平台暂时不支持，后期支持后需要更变响应的位置和顺序
    /*
    NXShareModel *sharModel2 = [[NXShareModel alloc] init];
    sharModel2.iconName = @"share_xl_wb";
    sharModel2.shareType = NXShareTypeWeibo;
    sharModel2.describe = @"新浪微博";
    
    [_dataArray addObject:sharModel2];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NXShareModel *sharModel3 = [[NXShareModel alloc] init];
        sharModel3.iconName = @"share_qq_HY";
        sharModel3.shareType = NXShareTypeQQ;
        sharModel3.describe = @"QQ";
        
        [_dataArray addObject:sharModel3];
        //
        NXShareModel *sharModel4 = [[NXShareModel alloc] init];
        sharModel4.iconName = @"share_qq_qzone";
        sharModel4.shareType = NXShareTypeQzone;
        sharModel4.describe = @"QQ空间";
        
        [_dataArray addObject:sharModel4];
        
    }
    NXShareModel *sharModel5 = [[NXShareModel alloc] init];
    sharModel5.iconName = @"share_qq_wb";
    sharModel5.shareType = NXShareTypeTengxunWeibo;
    sharModel5.describe = @"腾讯微博";
    
    [_dataArray addObject:sharModel5];
     */
}

/**
 *  将UIView的内容转换成image
 *
 *  @param theView 要转换的UIView
 *
 *  @return 转换后的image
 */
-(UIImage *)getImageFromView:(UIView *)theView
{
  
    //  第三个参数是转换的图像的高清度，设置成0将会自动根据屏幕的分辨率判断所需截屏的倍率
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, 0);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //  先将image转化为NSData
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, theView.size.height)];
    UIImageView *imageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, theView.size.height)];
    [middleView addSubview:imageViwe];
    imageViwe.image = [UIImage imageWithData:imageData];
    
    UIView *bodyView = [self linkTopAndBottomViwe:middleView];
  
    UIGraphicsBeginImageContextWithOptions(bodyView.bounds.size, YES, 0);
    [bodyView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [bodyView removeFromSuperview];
    return image1;
}

- (UIView *)linkTopAndBottomViwe:(UIView *)middleViwe {
    
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;

    CGFloat topViewHeight = 357 * SCREEN_WIDTH / 720;
    CGFloat bottomViewHeight = 390 * SCREEN_HEIGHT / 667;
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, topViewHeight + middleViwe.size.height + bottomViewHeight)];
    /*
      先将view添加到keyWindows，目的是为了把分享内容的view渲染到正确的位置
     */
    [keyWindows addSubview:bodyView];

    NXShareTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"NXShareTopView" owner:nil options:nil] firstObject];
    [topView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, topViewHeight)];
    [bodyView addSubview:topView];
  
    [middleViwe setFrame:CGRectMake(0, topViewHeight, SCREEN_WIDTH, middleViwe.size.height)];
    [bodyView addSubview:middleViwe];
    
    NXShareBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"NXShareBottomView" owner:nil options:nil] lastObject];

    [bottomView setFrame:CGRectMake(0, topViewHeight + middleViwe
                                    .size.height, SCREEN_WIDTH, bottomViewHeight)];
    [bodyView addSubview:bottomView];
    
    return bodyView;
}

- (void)dealloc {
    NSLog(@"shareView 释放了");
}

@end
