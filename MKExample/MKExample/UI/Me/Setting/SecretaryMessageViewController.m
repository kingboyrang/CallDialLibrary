//
//  SecretaryMessageViewController.m
//  CoolTalk2
//
//  Created by BreazeMago on 15/4/20.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import "SecretaryMessageViewController.h"


@interface SecretaryMessageViewController ()

@end

@implementation SecretaryMessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"秘书消息";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)enableNotification:(BOOL)isEnable{
    if (isEnable) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                                 |UIUserNotificationTypeSound
                                                                                                 |UIUserNotificationTypeAlert) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }else{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
        }
    }else{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (IBAction)enableNotificeClick:(id)sender {
    UISwitch *target=(UISwitch*)sender;
    [self enableNotification:target.on];
}
@end
