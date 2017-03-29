//
//  AccessAuthority.h
//  
//
//  Created by songxf on 15/8/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>


#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif


@interface AccessAuthority : NSObject

// 检测相册权限
+ (BOOL)checkAlbum;

// 检测相机权限
+ (BOOL)checkCamera;

@end
