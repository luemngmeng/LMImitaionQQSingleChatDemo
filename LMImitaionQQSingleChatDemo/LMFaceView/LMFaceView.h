//
//  LMFaceView.h
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/9/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LMFacialView.h"

@protocol LMFaceViewDelegate <NSObject>

@required

/**
 *  选择表情，以及是否删除
 *
 *  @param faceStr  表情视图
 *  @param isDelete 是否删除
 */
- (void)selectedFacialView:(NSString *)faceStr isDelete:(BOOL)isDelete;

/**
 *  发送表情
 */
- (void)sendFace;

@end

@interface LMFaceView : UIView<LMFacialViewDelegate>

/**
 *  定义代理属性，继承协议
 */
@property (nonatomic, weak) id<LMFaceViewDelegate>delegate;

/**
 *  判断字符串是否属于表情
 *
 *  @param string 传入的字符串
 *
 *  @return 是或者不是
 */
- (BOOL)stringIsFace:(NSString *)string;

@end
