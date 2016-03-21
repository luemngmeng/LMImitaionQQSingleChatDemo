//
//  LMMessageToolBar.m
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMMessageToolBar.h"

#import "UITextView+PlaceHolder.h"

#import "LMFaceView.h"
#import "LMMoreView.h"

#define TOOLBAR_VOICE_BUTTON_TAG 198900
#define TOOLBAR_FACE_BUTTON_TAG  198901
#define TOOLBAR_MORE_BUTTON_TAG  198902
#define INPUTTEXTVIEW_TEXTFONT   16

@interface LMMessageToolBar ()<UITextViewDelegate,LMFaceViewDelegate>{
    CGFloat _previousTextViewContentHeight;//记录上一次inputTextView的contentSize.height
}

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;

/**
 *  语音按钮
 */
@property (strong, nonatomic) UIButton *voiceButton;

/**
 *  更多按钮
 */
@property (strong, nonatomic) UIButton *moreButton;

/**
 *  表情按钮
 */
@property (strong, nonatomic) UIButton *faceButton;

/**
 *  输入框
 */
@property (strong, nonatomic) LMMessageTextView *inputTextView;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@end

@implementation LMMessageToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height < (kVerticalPadding * 2 + kInputTextViewMinHeight)) {
        frame.size.height = kVerticalPadding * 2 + kInputTextViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}

#pragma mark - Private Method
#pragma mark 配置子视图
- (void)setupSubviews
{
    //添加背景视图
    [self addSubview:self.backgroundImageView];
    
    // 添加toolBar视图
    [self addSubview:self.toolbarView];
    
    // 给toolBar视图添加背景视图
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    
    // 语音按钮
    [self.toolbarView addSubview:self.voiceButton];
    
    // 更多按钮
    [self.toolbarView addSubview:self.moreButton];
    
    // 表情按钮
    [self.toolbarView addSubview:self.faceButton];
    
    // 输入框
    [self.toolbarView addSubview:self.inputTextView];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
}

#pragma mark - Getter Method
#pragma mark toolBar 视图
- (UIView *)toolbarView {
    
    if (!_toolbarView){
        _toolbarView = [[UIView alloc] initWithFrame:self.bounds];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    
    return _toolbarView;
}

#pragma mark toolBar的背景视图
- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:self.backgroundImageView.frame];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

#pragma mark 背景视图
- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _backgroundImageView.image = [[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
    }
    
    return _backgroundImageView;
}

#pragma mark 语音button
- (UIButton *)voiceButton {
    
    if (!_voiceButton){
        _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kButtonDefaultHeight , kButtonDefaultHeight)];
        _voiceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.tag = TOOLBAR_VOICE_BUTTON_TAG;
    }
    
    return _voiceButton;
}

#pragma mark 表情button
- (UIButton *)faceButton {
    
    if (!_faceButton){
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kVerticalPadding, kVerticalPadding, kButtonDefaultHeight, kButtonDefaultHeight)];
        _faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_faceButton setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"chatBar_faceSelected"] forState:UIControlStateHighlighted];
        [_faceButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _faceButton.tag = TOOLBAR_FACE_BUTTON_TAG;
    }
    
    return _faceButton;
}

#pragma mark 更多button
- (UIButton *)moreButton {
    
    if (!_moreButton){
        _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kButtonDefaultHeight, kButtonDefaultHeight)];
        _moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [_moreButton setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:@"chatBar_moreSelected"] forState:UIControlStateHighlighted];
        [_moreButton setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.moreButton.tag = TOOLBAR_MORE_BUTTON_TAG;
    }
    
    return _moreButton;
}

#pragma mark 输入框
- (LMMessageTextView *)inputTextView {
    
    if (!_inputTextView){
        _inputTextView = [[LMMessageTextView alloc] initWithFrame:CGRectMake(self.voiceButton.frame.size.width + kHorizontalPadding*2, kVerticalPadding + 1.5 , CGRectGetWidth(self.bounds) - kHorizontalPadding*5 - kButtonDefaultHeight*3, kInputTextViewMinHeight)];
        _inputTextView.scrollEnabled = YES;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
        _inputTextView.backgroundColor = [UIColor clearColor];
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _inputTextView.layer.borderWidth = 0.65f;
        _inputTextView.layer.cornerRadius = 6.0f;
        _inputTextView.delegate = self;
        //[_inputTextView addPlaceHolder:@"请输入文本信息"];
        _inputTextView.font = [UIFont systemFontOfSize:INPUTTEXTVIEW_TEXTFONT];
        _previousTextViewContentHeight = [self getInputTextViewContentHeighWithTextView:_inputTextView];
    }
    
    
    return _inputTextView;
}

#pragma mark 语音附加页面
- (UIView *)recordView {
    
    if (!_recordView){
        //self.recordView = [[DXRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    
    return _recordView;
}

#pragma mark 表情附加页面
- (UIView *)faceView {
    
    if (!_faceView){
        _faceView = [[LMFaceView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 265)];
        LMFaceView *faceView = (LMFaceView *)_faceView;
        faceView.delegate = self;
        _faceView.backgroundColor = [UIColor lightGrayColor];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _faceView;
}

#pragma mark 更多附加页面
- (UIView *)moreView {
    
    if (!_moreView){
        _moreView = [[LMMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 80) type:ChatMoreTypeGroupChat];
        _moreView.backgroundColor = [UIColor lightGrayColor];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _moreView;
}

#pragma mark - Button Click
- (void)buttonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    switch (tag) {
            
        case TOOLBAR_VOICE_BUTTON_TAG: {  // 语音
            if (button.selected) {
                self.faceButton.selected = NO;
                self.moreButton.selected = NO;
                //录音状态下，不显示底部扩展页面
                [self willShowBottomView:nil];
                
                //将inputTextView内容置空，以使toolbarView回到最小高度
                self.inputTextView.text = @"";
                [self textViewDidChange:self.inputTextView];
                [self.inputTextView resignFirstResponder];
            }
            else{
                //键盘也算一种底部扩展页面
                [self.inputTextView becomeFirstResponder];
            }
            
        }
            
            break;
            
        case TOOLBAR_FACE_BUTTON_TAG: { // 表情
            
            if (button.selected) {
                
                self.moreButton.selected = NO;
                if (self.voiceButton.selected){
                    self.voiceButton.selected = NO;
                } else {
                    [self.inputTextView resignFirstResponder];
                }
                
                //显示表情键盘
                [self willShowBottomView:self.faceView];
                
            } else {
                
                // 没有选中的状态
                if (!self.voiceButton.selected) {
                    [self.inputTextView becomeFirstResponder];
                } else{
                    [self willShowBottomView:nil];
                }
            }
        }
            
            break;
            
        case TOOLBAR_MORE_BUTTON_TAG: { // 更多
            
            if (button.selected) {
                
                self.faceButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.voiceButton.selected) {
                    self.voiceButton.selected = NO;
                } else { //如果处于文字输入状态，使文字输入框失去焦点
                    [self.inputTextView resignFirstResponder];
                }
                
                // 显示更多页面视图
                [self willShowBottomView:self.moreView];
                
            } else {
                self.voiceButton.selected = NO;
                [self.inputTextView becomeFirstResponder];
            }
            
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - keyBoard notification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
    
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height){
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowBottomHeight:(CGFloat)bottomHeight {
    
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height){
        return;
    }
    
    self.frame = toFrame;
}

#pragma 显示底部视图进行切换
- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        // 更新activityButtomView
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

#pragma mark - 各类的Delegate
#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
#warning  后期加上代理给外部方法调用
    //    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
    //        [self.delegate inputTextViewWillBeginEditing:self.inputTextView];
    //    }
    
    // 所有toolbar上的按钮都变为正常正常状态
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    self.voiceButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    
#warning  后期加上代理给外部方法调用
    //    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
    //        [self.delegate inputTextViewDidBeginEditing:self.inputTextView];
    //    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ // 点击发送按钮，发送消息
        
        if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:textView.text];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getInputTextViewContentHeighWithTextView:self.inputTextView]];
        }
        return NO;
    }
    
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self willShowInputTextViewToHeight:[self getInputTextViewContentHeighWithTextView:self.inputTextView]];
}

/**
 *   重写停止编辑的方法
 */
- (BOOL)endEditing:(BOOL)force {
    
    BOOL result = [super endEditing:force];
    
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    
    return result;
}

#pragma mark - LMFaceViewDelegate
- (void)selectedFacialView:(NSString *)faceStr isDelete:(BOOL)isDelete {
    
    NSString *chatText = self.inputTextView.text;
    
    // 判断是否是删除文字还是表情
    if (!isDelete && faceStr.length > 0) { // 串联文字或者表情
        
        self.inputTextView.text = [NSString stringWithFormat:@"%@%@",chatText,faceStr];
        
    } else { // 删除文字或表情
        
        // 判断是删除文字 还是表情
        if (chatText.length >= 2) { // 删除表情 （长度大于2）
            NSString *subStr = [chatText substringFromIndex:chatText.length-2];
            if ([(LMFaceView *)self.faceView stringIsFace:subStr]) {
                self.inputTextView.text = [chatText substringToIndex:chatText.length-2];
                [self textViewDidChange:self.inputTextView];
                return;
            }
        }
        
        if(chatText.length > 0){ // 删除文字（长度是1）
            self.inputTextView.text = [chatText substringToIndex:chatText.length-1];
        }
    }
    
    // 改变TextView的高度
    [self textViewDidChange:self.inputTextView];
}

- (void)sendFace {
    
    NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSendText:)]) {
            [self.delegate didSendText:chatText];
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getInputTextViewContentHeighWithTextView:self.inputTextView]];;
        }
    }
}

#pragma mark - Utills
#pragma mark 获取UITextView的高度
- (CGFloat)getInputTextViewContentHeighWithTextView:(UITextView *)textView {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){ // 获取textView内容的高度需要根据系统不同来区分
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark 根据内容的不同高度来改变TextView的高度
- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
    
    // 不同小于最小高度
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    
    // 不能大于设定的最大高度
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    // 判断是否是在同一行（同一行就不需要改变高度）
    if (toHeight == _previousTextViewContentHeight){
        return;
    } else {
        
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        // 改变整个Toobar背景视图的高度
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        // 改变整个Toobar视图的高度（默认高度是40）
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        // 改变输入框的高度
        rect = self.inputTextView.frame;
        rect.size.height += changeHeight;
        self.inputTextView.frame = rect;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
#warning  后期加上代理给外部方法调用
//                if (_delegate && [_delegate respondsToSelector:@selector(didChangeFrameToHeight:)]) {
//                    [_delegate didChangeFrameToHeight:self.frame.size.height];
//                }
    }
}


@end
