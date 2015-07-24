//
//  DialModeViewController.m
//  CoolTalk2
//
//  Created by BreazeMago on 15/4/20.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import "DialModeViewController.h"
#import "ConfigSettingHandler.h"

@interface DialModeViewController ()

@end

@implementation DialModeViewController
@synthesize ZhiBoSwitch;
@synthesize CallBackSwitch;

- (IBAction)WIFI_CALLBACK:(UISwitch *)sender {

    [ConfigSettingHandler setWiFiCallBackOn:sender.on];
}
- (IBAction)G_CALLBACK:(UISwitch *)sender {

    [ConfigSettingHandler set3G4GCallBackOn:sender.on];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"拨打方式";

    [ZhiBoSwitch setOn:[ConfigSettingHandler isWiFiCallBackOn] animated:NO];
    [CallBackSwitch setOn:[ConfigSettingHandler is3G4GCallBackOn] animated:NO];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
