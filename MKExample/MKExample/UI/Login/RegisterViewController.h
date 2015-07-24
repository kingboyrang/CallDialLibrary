//
//  LoginViewController.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
//注册
- (IBAction)registerClick:(id)sender;
//用户协议
- (IBAction)userAgreeClick:(id)sender;


@end
