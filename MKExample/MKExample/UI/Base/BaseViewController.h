//
//  BaseViewController.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//返回事件重写
- (BOOL)isNavigationBack;
//导航右边按钮
- (void)addRightMenuItemWithTitle:(NSString*)title target:(id)target action:(SEL)action;
@end
