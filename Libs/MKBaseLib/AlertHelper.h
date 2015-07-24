//
//  AlertHelper.h
//  Eland
//
//  Created by aJia on 13/9/30.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

//信息提示
+(void)showAlertWithMessage:(NSString *)msg;

+(void)showAlertWithTitle:(NSString*)title message:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

+(void)showAlertWithMessage:(NSString *)inMessage cancelTitle:(NSString*)cancelTitle cancelAction:(void (^)(void))cancelAction confirmTitle:(NSString*)confirmTitle confirmAction:(void (^)(void))confirmAction;

@end
