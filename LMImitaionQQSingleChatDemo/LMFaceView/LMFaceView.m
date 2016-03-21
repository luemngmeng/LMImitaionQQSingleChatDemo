//
//  LMFaceView.m
//  AnyTestProjectDemo
//
//  Created by mengmenglu on 3/9/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMFaceView.h"

@interface LMFaceView (){
    
    LMFacialView *_facialView;
}

@end

@implementation LMFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _facialView = [[LMFacialView alloc] initWithFrame: CGRectMake(5, 5, frame.size.width - 10, self.bounds.size.height - 10)];
        [_facialView loadFacialViewWithPage:1 facialViewSize:CGSizeMake(30, 30)];
        _facialView.delegate = self;
        [self addSubview:_facialView];
    }
    return self;
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if ([self.delegate respondsToSelector:@selector(selectedFacialView:isDelete:)]) {
        [self.delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (self.delegate) {
        [self.delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFacial
{
    if (self.delegate) {
        [self.delegate sendFace];
    }
}


#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.facesArray containsObject:string]) {
        return YES;
    }
    
    return NO;
}

@end
