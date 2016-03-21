//
//  LMPhotoHandle.m
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/18/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//  处理跟照片有关的类

#import "LMPhotoHandle.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface LMPhotoHandle ()

@end

@implementation LMPhotoHandle


#pragma mark - 从相册选取照片
+ (void)showPhotoActionIn:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) vc{
    
    if ([self isPhotoLibraryAvailable]) { // 判断是否允许从相册中选取照片
        
        UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
        pickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        
        pickerCtrl.mediaTypes = mediaTypes;
        pickerCtrl.delegate = vc;  // 传过来当前页面的指针
        pickerCtrl.allowsEditing = YES;
        
        [(UIViewController *)vc presentViewController:pickerCtrl animated:YES completion:^{
            NSLog(@"Picker View Controller is presented");
        }];
        
    } else {  // 不允许选取照片应做的操作
        NSLog(@"不允许访问相册中的照片");
    }
}


#pragma mark - 通过相机拍照选取照片
+ (void)takePhotoActionIn:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) vc{
    
    if ([LMPhotoHandle isCameraAvailable] && [LMPhotoHandle doesCameraSupportTakingPhotos]) {
        
        UIImagePickerController *pickerCtrl = [[UIImagePickerController alloc] init];
        pickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 判断是否是使用前置摄像头拍照
        if ([self isFrontCameraAvailable]) {
           pickerCtrl.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        pickerCtrl.mediaTypes = mediaTypes;
        pickerCtrl.delegate = vc;
        //设置选择后的图片可被编辑
        pickerCtrl.allowsEditing = YES;
        
        [(UIViewController *)vc presentViewController:pickerCtrl animated:YES completion:^(void){
                                               NSLog(@"Picker View Controller is presented");
                                           }];
        
    } else {  // 照相机不可用的操作
        NSLog(@"不允许访问手机的照相机");
    }
}


#pragma mark Utility
#pragma mark 判断相机是否可用
+ (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark 判断后置相机是否可用
+ (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark 判断前置相机是否可用
+ (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

#pragma mark 查看是否支持拍照功能
+ (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark 查看相册功能是否可用
+ (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark 判断是否能从相册选取的语音
+ (BOOL)canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark 判断是否能从相册选取相片
+ (BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma makr 相机能支持的媒体文件类型
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


@end
