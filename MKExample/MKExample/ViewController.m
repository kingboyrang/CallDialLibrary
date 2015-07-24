//
//  ViewController.m
//  MKExample
//
//  Created by wulanzhou on 15/6/15.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "ViewController.h"
#import "CZServiceManager.h"
#import "Md5Encrypt.h"
#import "CZMyLog.h"
#import "SystemUser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //户用写日志
    //[CZMyLog setWriteLogEnable:YES];
    
    //登录
    //[self login];
    
    
    //查询用户是否存
    //[self queryUser];
    
    //取得帐户信息
    [self accountInfo];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//登陆
- (void)login{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"13632638275", @"phone",[Md5Encrypt md5:@"111111"], @"pass", nil];
    //登陆
    [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceLogin completed:^(NSDictionary *userInfo) {
        NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
        if (result==0) {
            //保存登陆信息
            SystemUser *user=[[SystemUser alloc] initWithDictionary:userInfo];
            user.name=@"13632638275";
            user.phone=@"13632638275";
            user.password=@"111111";
            user.isLogin=YES;
            [user saveUser];
            //
        }else{
            
        }
    }];
}
//查询用户是否存
- (void)queryUser{
    NSString *tokenStr = @"H03I1NG1LWXRA482U8XDS2V4YXTBB2WSBR04N365NOTSOL_7K0CE9UHAFPVC&_UEFYMEIFRUXAV5RL.5&JTPM3C0Q81.9&WE.76DZMFG189NSJ5O32GPPJLYYAIZD7QJ";
    NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:@"13632638275", @"phone",tokenStr, @"token", nil];
    
    [[CZServiceManager shareInstance] requestServiceWithDictionary:user requestServiceType:CZServiceQueryUserExist completed:^(NSDictionary *userInfo) {
         NSLog(@"userinfo =%@",userInfo);
    }];
}
//取得帐户信息
- (void)accountInfo{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[SystemUser shareInstance].token, @"token", [SystemUser shareInstance].userId,@"uid",nil];
    
    [[CZServiceManager shareInstance] requestServiceWithDictionary:dic requestServiceType:CZServiceAccountInfo completed:^(NSDictionary *userInfo) {
        NSLog(@"userinfo =%@",userInfo);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
