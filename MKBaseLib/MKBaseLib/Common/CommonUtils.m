//
//  CommonUtils.m
//  MKBaseLib
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "CommonUtils.h"
#import "PhoneInfo.h"

@implementation CommonUtils
//是否有网络
+ (BOOL)isHasNetWork{
    PhoneNetType nPhoneNetType=[PhoneInfo sharedInstance].phoneNetType;
    if (nPhoneNetType==PNT_UNKNOWN) {
        return NO;
    }
    return YES;
}
@end
