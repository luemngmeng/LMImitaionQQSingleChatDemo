//
//  LMPhotoHandle.h
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/18/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LMPhotoHandle : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  从相册选取照片
 *
 *  @param vc 传入当前指向的对象
 */
+ (void)showPhotoActionIn:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) vc;


/**
 *  通过相机拍照选取照片
 *
 *  @param vc 传入当前指向的对象
 */
+ (void)takePhotoActionIn:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>) vc;


/**
 *  判断相机是否可用
 *
 *  @return 返回是否可用的Bool
 */
+ (BOOL) isCameraAvailable;


/**
 *  判断后置相机是否可用
 *
 *  @return 返回是否可以访问的Bool
 */
+ (BOOL)isRearCameraAvailable;

/**
 *  判断前置相机是否可用
 *
 *  @return 
 */
+ (BOOL)isFrontCameraAvailable;

/**
 *  查看是否支持拍照功能
 *
 *  @return
 */
+ (BOOL)doesCameraSupportTakingPhotos;

/**
 *  查看相册功能是否可用
 *
 *  @return 返回可用
 */
+ (BOOL)isPhotoLibraryAvailable;

/**
 *  判断是否能从相册选取的语音
 *
 *  @return
 */
+ (BOOL)canUserPickVideosFromPhotoLibrary;

/**
 *  判断是否能从相册选取相片
 *
 *  @return 返回的bool
 */
+ (BOOL)canUserPickPhotosFromPhotoLibrary;

/**
 *  相机能支持的媒体文件类型
 *
 *  @param paramMediaType
 *  @param paramSourceType
 *
 *  @return 
 */
+ (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

@end
