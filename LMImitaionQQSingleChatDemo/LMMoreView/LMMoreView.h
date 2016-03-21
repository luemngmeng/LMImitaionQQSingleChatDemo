//
//  LMMoreView.h
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/17/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;


// 声明自定义的协议
@protocol LMMoreViewDelegate;

@interface LMMoreView : UIView

/**
 *  定义代理属性
 */
@property (nonatomic,assign) id<LMMoreViewDelegate> delegate;

/**
 *  照片按钮
 */
@property (nonatomic, strong) UIButton *photoButton;

/**
 *  图片按钮
 */
@property (nonatomic, strong) UIButton *takePicButton;

/**
 *  定位按钮
 */
@property (nonatomic, strong) UIButton *locationButton;

/**
 *  语音按钮
 */
@property (nonatomic, strong) UIButton *videoButton;

/**
 *  视频按钮
 */
@property (nonatomic, strong) UIButton *audioCallButton;

/**
 *  语音聊天按钮
 */
@property (nonatomic, strong) UIButton *videoCallButton;

/**
 *  按照传入的frame和type初始化视图
 *
 *  @param frame
 *  @param type
 *
 *  @return 当前对象
 */
- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;


/**
 *  设置子视图根据传入的不同的类型
 *
 *  @param type 
 */
- (void)setupSubviewsForType:(ChatMoreType)type;


@end


/**
 *  定义实现的协议
 */
@protocol LMMoreViewDelegate <NSObject>

@required

/**
 *  拍照
 *
 */
- (void)moreViewTakePicAction:(LMMoreView *)moreView;


/**
 *  查看照片
 *
 */
- (void)moreViewPhotoAction:(LMMoreView *)moreView;


/**
 *  发送定位
 *
 */
- (void)moreViewLocationAction:(LMMoreView *)moreView;


/**
 *  视频
 *
 */
- (void)moreViewAudioCallAction:(LMMoreView *)moreView;


/**
 *  语音
 *
 */
- (void)moreViewVideoCallAction:(LMMoreView *)moreView;

@end