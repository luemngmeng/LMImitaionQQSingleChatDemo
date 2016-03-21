//
//  UITextView+PlaceHolder.h
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//  应用Runtime机制添加一个Label视图属性

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

@interface UITextView (PlaceHolder) <UITextViewDelegate>

/**
 *  添加placeHolder视图属性
 */
@property (nonatomic,strong) UILabel *placeHolderLabel;

/**
 *  添加提示语文字
 *
 *  @param placeHolder 传入的文字
 */
- (void)addPlaceHolder:(NSString *)placeHolder;

@end
