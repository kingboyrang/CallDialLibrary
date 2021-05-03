//
//  DialplateViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "DialplateViewController.h"
#import "MKDialplateView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WldhTabBarController.h"



@interface DialplateViewController ()

@end

@implementation DialplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  UIColorMakeRGB(247, 247, 241);
    
   
    WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //添加底部
    [tab addDialView:self.dialplateView.dialplateBottomView];
}

- (void)showDialplateViewStatus:(BOOL)status{

    if (status) {
        self.dialplateView.dialplateBottomView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.dialplateView.dialplateBottomView.alpha = 1.0;
        } completion:^(BOOL finished) {
            WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            //添加底部
            [tab makeTabBarHidden:YES];
        }];
        
    }else{
        self.dialplateView.dialplateBottomView.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.dialplateView.dialplateBottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            //添加底部
            [tab makeTabBarHidden:NO];
        }];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
