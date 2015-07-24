//
//  ModifyPassViewController.h
//  CoolTalk2
//
//  Created by BreazeMago on 15/4/20.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPwdViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

//显示密码
- (IBAction)showPwdClick:(id)sender;
//提交
- (IBAction)submitClick:(id)sender;

@end
