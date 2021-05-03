//
//  AppDelegate.m
//  MKExample
//
//  Created by wulanzhou on 15/6/15.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "AppDelegate.h"
#import "MKContact.h"
#import "CZRequestHandler.h"
#import "SystemUser.h"
#import "WldhDBManager.h"
#import "WldhNavigationController.h"
#import "WldhTabBarController.h"
#import "RegisterViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.backgroundColor=[UIColor whiteColor];
    
    //初始化默认值
    [self initClientValue];
    

    //加载联系人归属地
    [MKContact loadContactAttribution];
    
    SystemUser *user = [SystemUser shareInstance];
    user.name = @"kingboyrang";
    user.phone = @"13632638275";
    user.password = @"123456";
    user.clientNubmer = @"13632638275";
    user.clientPassword = @"542365";
    user.token = @"6813248961231676121657";
    user.tokenValidDate = @"2021-10-10";
    user.userId = @"1";
    user.yunToken = @"5613246130";
    user.isLogin = YES;
    [user saveUser];
    
     //创建用户数据库
    if ([SystemUser shareInstance].isLogin) {
        [[WldhDBManager shareInstance] createUserDatabase:[SystemUser shareInstance].userId];
    }
    
    //创建视图
    [self createView];
    
    return YES;
}

//初始化默认值
- (void)initClientValue{
    //默认请求配置初始化
    CZRequestConfig *config=[[CZRequestConfig alloc] init];
    config.httpServer=@"http://api.cool170.com:8081";
    config.agwVersion=@"01";
    
    if([[SystemUser shareInstance] isLogin]){
        config.userId=[SystemUser shareInstance].userId;
    }
    [CZRequestHandler initWithConfig:config];
    //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginSucess:) name:kNotificationLoginSuccess object:nil];
}

- (void)receiveLoginSucess:(NSNotification*)notification{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.window.rootViewController=[storyboard instantiateInitialViewController];

}
//创建视图
- (void)createView{
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    //表示已登录
    if ([SystemUser shareInstance].isLogin) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self.window.rootViewController=[storyboard instantiateInitialViewController];
        
    }else{
        RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        WldhNavigationController *nav=[[WldhNavigationController alloc] initWithRootViewController:registerController];
        
        self.window.rootViewController=nav;
    }
    
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
