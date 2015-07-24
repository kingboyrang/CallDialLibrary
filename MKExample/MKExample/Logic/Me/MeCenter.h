//
//  MeCenter.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MeSourceAccountType=0, //我的帐户
    MeSourceRecommendType, //推荐有礼
    MeSourceSweepType, //扫一扫
    MeSourceSettingType //设置
}MeSourceType;

@interface MeCenter : NSObject
@property (nonatomic,strong)  NSString *name; //名称
@property (nonatomic,strong)  NSString *imageName;//图片名
@property (nonatomic,assign)  MeSourceType sourceType;
@end
