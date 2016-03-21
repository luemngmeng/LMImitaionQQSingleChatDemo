//
//  UITextView+PlaceHolder.m
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

static const char *lmPalceHolderLabel = "placeHolderLabel";

@implementation UITextView (PlaceHolder)

#pragma mark - Runtime get set Method
- (UILabel *)placeHolderLabel {
    return objc_getAssociatedObject(self, lmPalceHolderLabel);
}

- (void)setPlaceHolderLabel:(UILabel *)placeHolderLabel {
    objc_setAssociatedObject(self, lmPalceHolderLabel, placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"开始编辑");
    self.placeHolderLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"开始改变");
    if (textView && textView.text.length > 0){
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"结束编辑");
}

#pragma mark - Public Method
- (void)addPlaceHolder:(NSString *)placeHolder {
    
    if (![self placeHolderLabel]){
        self.delegate = self;
        
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.frame.size.width - 10, 30)];
        placeHolderLabel.text = placeHolder;
        placeHolderLabel.font = [UIFont systemFontOfSize:16];
        placeHolderLabel.textColor = [UIColor grayColor];
        placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        self.contentInset = UIEdgeInsetsMake( 3, 0, 0, 0);
        [self addSubview:placeHolderLabel];
        [self setPlaceHolderLabel:placeHolderLabel];
    }
}


@end
