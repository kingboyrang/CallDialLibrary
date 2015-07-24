//
//  LoginManager.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject
//登录处理
+ (void)requestLoginWithName:(NSString*)phone password:(NSString*)pwd completed:(void(^)(NSDictionary *userInfo))finished;
@end
