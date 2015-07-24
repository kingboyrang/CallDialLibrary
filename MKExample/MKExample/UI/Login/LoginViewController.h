//
//  LoginViewController.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//登录
- (IBAction)loginClick:(id)sender;

//忘记密码
- (IBAction)forgetPwdClick:(id)sender;

@end
