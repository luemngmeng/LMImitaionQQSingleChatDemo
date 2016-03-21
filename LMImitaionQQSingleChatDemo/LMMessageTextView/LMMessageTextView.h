//
//  LMMessageTextView.h
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//  用户输入文本消息的输入框

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSUInteger,LMTextViewInputViewType){
    LMTextViewInputViewType_NormalInput = 0,
    LMTextViewInputViewType_TextInput,
    LMTextViewInputViewType_FaceInput,
    LMTextViewInputViewType_ShareMenuInputType,
};

@interface LMMessageTextView : UITextView

/**
 *  自定义用户输入的提示语
 */
//@property (nonatomic, copy) NSString *placeHolder;

/**
 *  标语文本的颜色
 */
//@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 *  获取自身文本占据有多少行
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLinesOfText;

/**
 *  获取每行的高度
 *
 *  @return 根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/**
 *  获取某个文本占据自身适应宽带的行数
 *
 *  @param text 目标文本
 *
 *  @return 返回占据行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
