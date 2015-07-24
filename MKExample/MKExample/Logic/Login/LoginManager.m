//
//  LoginManager.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "LoginManager.h"
#import "Md5Encrypt.h"
#import "SystemUser.h"

@implementation LoginManager
//登录处理
+ (void)requestLoginWithName:(NSString*)phone password:(NSString*)pwd completed:(void(^)(NSDictionary *userInfo))finished{

    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:phone, @"phone",[Md5Encrypt md5:pwd], @"pass", nil];
    
    [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceLogin completed:^(NSDictionary *userInfo) {
        NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
        if (result==0){ //登录成功
            
            //保存登陆信息
            SystemUser *user=[[SystemUser alloc] initWithDictionary:userInfo];
            user.name=phone;
            user.phone=phone;
            user.password=pwd;
            user.isLogin=YES;
            [user saveUser];
            
            //登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:userInfo];
        }
        else{
            //[AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
        }
        
        if (finished) {
            finished(userInfo);
        }
        
    }];
}
@end
