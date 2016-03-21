//
//  LMLocationViewController.h
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/17/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol LMLocationViewControllerDelegate <NSObject>

/**
 *  发送定位后的地址
 *
 *  @param latitude  经度
 *  @param longitude 纬度
 *  @param address   地址
 */
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;

@end

@interface LMLocationViewController : UIViewController

/**
 *  定义代理属性
 */
@property (nonatomic,weak) id<LMLocationViewControllerDelegate> delegate;


/**
 *  利用CLLocationCoordinate2D类型参数初始化
 *
 *  @param locationCoordinate
 *
 *  @return 当前对象
 */
- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate;

@end
