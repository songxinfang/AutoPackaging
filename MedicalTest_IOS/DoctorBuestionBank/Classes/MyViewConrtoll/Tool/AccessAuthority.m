//
//  PPAccessAuthority.m
//  
//
//  Created by songxf on 15/8/17.
//

#import "AccessAuthority.h"

@implementation AccessAuthority

+ (BOOL)checkAlbum
{
    if (IOS_VERSION >= 6.0f)
    {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        
        if (authStatus != ALAuthorizationStatusAuthorized && authStatus != ALAuthorizationStatusNotDetermined)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有权限访问您的相册，您可到\"设置-隐私-照片\"打开权限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相册不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkCamera
{
    if (IOS_VERSION >= 7.0f)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有权限访问您的相机，您可到\"设置-隐私-相机\"打开权限" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

@end
