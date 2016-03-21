//
//  LMMoreView.m
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/17/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation LMMoreView

#pragma mark 初始化视图
- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviewsForType:type];
    }
    
    return self;
}


#pragma mark 根据不同的类型设置子视图
- (void)setupSubviewsForType:(ChatMoreType)type {
    
    // 添加照片按钮视图
    [self addSubview:self.photoButton];
    
    
    // 添加定位按钮视图
    [self addSubview:self.locationButton];
    
    // 添加拍照按钮视图
    [self addSubview:self.takePicButton];
    
    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        
        frame.size.height = 150;
        // 添加视频按钮视图
        [self addSubview:self.audioCallButton];
        
        // 添加语音按钮视图
        [self addSubview:self.videoButton];
        
    } else if (type == ChatMoreTypeGroupChat) {
        frame.size.height = 80;
    }
    
    self.frame = frame;
}

#pragma mark 照片按钮
- (UIButton *)photoButton {
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    if (!_photoButton) {
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
        [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
        [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _photoButton;
}

#pragma mark 定位按钮
- (UIButton *)locationButton {
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    if (!_locationButton) {
        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
        [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
        [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _locationButton;
}

#pragma mark 照相按钮
- (UIButton *)takePicButton {
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    if (!_takePicButton) {
        _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_takePicButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
        [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
        [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _takePicButton;
}

#pragma mark 视频按钮
- (UIButton *)audioCallButton {
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    if (!_audioCallButton) {
        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _audioCallButton;
}

#pragma mark 语音按钮
- (UIButton *)videoButton {
    
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    if (!_videoButton) {
        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _videoButton;
}

#pragma mark - action

- (void)photoAction {
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]){
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takePicAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]) {
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)takeAudioCallAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

@end
