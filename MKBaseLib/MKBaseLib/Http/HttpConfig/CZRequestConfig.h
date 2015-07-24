//
//  CZRequestConfig.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

//默认请求配置

#import <Foundation/Foundation.h>

@interface CZRequestConfig : NSObject<NSCoding>
/**
 *  服务地址
 */
@property (nonatomic,copy)     NSString *httpServer;
/**
 *  agw版本,默认值为01
 */
@property (nonatomic,copy)     NSString *agwVersion;
/**
 *  用户Id号
 */
@property (nonatomic,copy)     NSString *userId;
@end
