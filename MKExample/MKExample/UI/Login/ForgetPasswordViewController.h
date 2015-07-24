//
//  ForgetPasswordViewController.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UITextField *vertyField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *vertyBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic,strong) NSString *mobile;//手机号码

//再次获取验证码
- (IBAction)sendVertyClick:(id)sender;
//提交
- (IBAction)submitClick:(id)sender;

@end
