//
//  LMFacialView.h
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/9/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LMFacialViewDelegate <NSObject>

@optional

/**
 *  发送表情
 */
- (void)sendFacial;

/**
 *  选择表情
 */
- (void)selectedFacialView:(NSString *)faceStr;

/**
 *  删除表情
 */
- (void)deleteSelected:(NSString *)faceStr;

@end

@interface LMFacialView : UIView {
    /**
     *  表情数组
     */
    //NSArray *_facesArray;
}

/**
 *  定义代理属性
 */
@property(nonatomic,weak) id<LMFacialViewDelegate>delegate;


/**
 *  表情数组
 */
@property(strong, nonatomic, readonly) NSArray *facesArray;

/**
 *  加载表情通过页数和表情视图的大小
 */
- (void)loadFacialViewWithPage:(int)page facialViewSize:(CGSize)size;

@end
