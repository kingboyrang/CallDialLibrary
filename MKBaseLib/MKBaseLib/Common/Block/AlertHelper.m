//
//  AlertHelper.m
//  Eland
//
//  Created by aJia on 13/9/30.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "AlertHelper.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
@implementation AlertHelper


+(void)showAlertWithMessage:(NSString *)msg{
    
    RIButtonItem *button=[RIButtonItem item];
    button.label=@"我知道了";
    button.action=nil;
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"温馨提醒" message:msg cancelButtonItem:button otherButtonItems:nil, nil];
    [alter show];
}

+(void)showAlertWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    RIButtonItem *cancel=[RIButtonItem item];
    cancel.label=cancelTitle;
    cancel.action=cancelAction;
    
    RIButtonItem *confirm=[RIButtonItem item];
    confirm.label=confirmTitle;
    confirm.action=confirmAction;
    
    
    UIAlertView *alter=[[UIAlertView alloc] initWithTitle:title message:inMessage cancelButtonItem:cancel otherButtonItems:confirm, nil];
    [alter show];
}

+(void)showAlertWithMessage:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction{
    
    [self showAlertWithTitle:@"温馨提醒" message:inMessage cancelTitle:cancelTitle cancelAction:cancelAction confirmTitle:confirmTitle confirmAction:confirmAction];
}


@end
