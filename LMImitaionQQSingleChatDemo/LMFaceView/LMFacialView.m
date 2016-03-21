//
//  LMFacialView.m
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/9/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMFacialView.h"
#import "Emoji.h"

#define DELETE_BUTTON_TAG  10000

@interface LMFacialView ()

@end

@implementation LMFacialView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self){
        _facesArray = [Emoji allEmoji];
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

#pragma mark 加载FaceView 并排好位置
- (void)loadFacialViewWithPage:(int)page facialViewSize:(CGSize)size {
    
    int maxRow = 5;  // 设置最大行数
    int maxCol = 8;  // 设置最大列数
    CGFloat itemWidth = self.frame.size.width / maxCol;    // 获取每列显示一个的宽度
    CGFloat itemHeight = self.frame.size.height / maxRow;  // 获取每行显示一个的高度
    
    // 删除按钮建放在最后两行最后一列
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundColor:[UIColor clearColor]];
    [deleteButton setFrame:CGRectMake((maxCol - 1) * itemWidth, (maxRow - 1) * itemHeight, itemWidth, itemHeight)];
    [deleteButton setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
    deleteButton.tag = DELETE_BUTTON_TAG;
    [deleteButton addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    // 发送按钮按钮建放在最后一行最后一列
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:NSLocalizedString(@"send", @"Send") forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake((maxCol - 2) * itemWidth - 10, (maxRow - 1) * itemHeight + 5, itemWidth + 10, itemHeight - 10)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundColor:[UIColor colorWithRed:10 / 255.0 green:82 / 255.0 blue:104 / 255.0 alpha:1.0]];
    [self addSubview:sendButton];
    
    for (int row = 0; row < maxRow; row++) {
        for (int col = 0; col < maxCol; col++) {
            int index = row * maxCol + col;
            if (index < [_facesArray count]) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setFrame:CGRectMake(col * itemWidth, row * itemHeight, itemWidth, itemHeight)];
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [_facesArray objectAtIndex:(row * maxCol + col)] forState:UIControlStateNormal];
                button.tag = row * maxCol + col;
                [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
            else{
                break;
            }
        }
    }
}

#pragma mark 选择表情
- (void)selected:(UIButton *)button {
    
    if (button.tag == DELETE_BUTTON_TAG && [self.delegate respondsToSelector:@selector(deleteSelected:)]) { // 选选择删除按钮
        [self.delegate deleteSelected:nil];
        
    } else { // 选择表情按钮
        
        NSString *str = [_facesArray objectAtIndex:button.tag];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFacialView:)]) {
            [self.delegate selectedFacialView:str];
        }
    }
}

#pragma mark -发送表情
- (void)sendAction:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(sendFacial)]) {
        [self.delegate sendFacial];
    }
}

@end
