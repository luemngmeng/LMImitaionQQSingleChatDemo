//
//  LMMessageTextView.m
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//  用户输入文本消息的输入框

#import "LMMessageTextView.h"

#import "UITextView+PlaceHolder.h"

@interface LMMessageTextView ()<UITextViewDelegate>

/**
 *  提示语的Label
 */
//@property (nonatomic,strong) UILabel *placeHolderLabel;

@end

@implementation LMMessageTextView

#pragma mark - Message Text view
// 针对不同的设备 返回的行高是不一样的额 iphone:33 ipad:109
+ (NSUInteger)maxCharactersPerLine {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33.0f:109.0f;
}

// 返回文本所占的行数 文本的Length/行数
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [LMMessageTextView maxCharactersPerLine]) + 1;
}

//返回TextView的文本所占的行数
- (NSUInteger)numberOfLinesOfText {
    return [LMMessageTextView numberOfLinesForMessage:self.text];
}

#pragma mark - life cycle
- (void)setup {
    
    self.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.keyboardType = UIKeyboardTypeDefault;
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.delegate = self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}


#pragma mark - Getter Method

//- (void)textViewDidChange:(UITextView *)textView {
//    
//    if ([textView isKindOfClass:[LMMessageTextView class]]){
//        LMMessageTextView *messageTextView = (LMMessageTextView *)textView;
//        NSUInteger row = [messageTextView numberOfLinesOfText];
//        NSLog(@"row----%d",(int)row);
//    } else{
//        NSLog(@"不是指定的UITextView,无法返回行数");
//    }
//    
//}

@end
