//
//  WldhTabBarController.h
//  WldhMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WldhTabBarController : UITabBarController
{
    UIView  *_wldhCallView;
}
@property(nonatomic,strong) UIView  *wldhTabBarBgView;
@property(nonatomic,strong) UIView  *wldhTabBarView;


@property(nonatomic, assign) NSInteger currentSelectedIndex;
@property(nonatomic, strong) NSMutableArray *_tabBarButtons;

//添加拨打显示界面
- (void)addDialView:(UIView*)dialView;
//显示或隐藏TabBar
-(void)makeTabBarHidden:(BOOL)hide;

+(WldhTabBarController *)shareInstance;



@end
