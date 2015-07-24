//
//  LoginViewController.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Md5Encrypt.h"
#import "ForgetPasswordViewController.h"
#import "SystemUser.h"
#import "LoginManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录 ";
    
    //设代理
    self.nameField.delegate=self;
    self.pwdField.delegate=self;
    
    //登录按钮
    UIImage *btnImgNor= [UIImage imageNamed:@"btn_nor.png"];
    btnImgNor = [btnImgNor stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_loginBtn setBackgroundImage:btnImgNor forState:UIControlStateNormal];
    
    UIImage *btnImgSel = [UIImage imageNamed:@"btn_sel.png"];
    btnImgSel = [btnImgSel stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_loginBtn setBackgroundImage:btnImgSel forState:UIControlStateHighlighted];
    
    UIImage *btnImgDis = [UIImage imageNamed:@"btn_dis.png"];
    btnImgDis = [btnImgDis stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_loginBtn setBackgroundImage:btnImgDis forState:UIControlStateDisabled];
    _loginBtn.enabled = NO;
    
    //注册
    [self addRightMenuItemWithTitle:@"注册" target:self action:@selector(registerClick)];
    
    //失去焦点
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGr];
    
    //文本值监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [_nameField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_pwdField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}
//失去焦点
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr{
    [_nameField resignFirstResponder];
    [_pwdField resignFirstResponder];
}
//注册
- (void)registerClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//登录
- (IBAction)loginClick:(id)sender {
    
    if ([_nameField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"手机号码不能为空!"];
        [_nameField becomeFirstResponder];
        return;
    }
    if ([_pwdField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"密码不能为空!"];
        [_pwdField becomeFirstResponder];
        return;
    }
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    [self textFieldResponed:nil];
    
    //手机号码
    NSString *phone=[_nameField.text Trim];
    
    if ((phone.length == 11)&&(([phone hasPrefix:@"13"])||([phone hasPrefix:@"14"])||([phone hasPrefix:@"15"])||([phone hasPrefix:@"17"])||([phone hasPrefix:@"18"]))) {
        
        [LoginManager requestLoginWithName:phone password:[_pwdField.text Trim] completed:^(NSDictionary *userInfo) {
            NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
            if (result!=0){ //登录成功
               [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
            }
        }];
       
        
    }else{
        [AlertHelper showAlertWithMessage:@"请输入有效的手机号码!"];
    }
}
//忘记密码
- (IBAction)forgetPwdClick:(id)sender {

    if ([_nameField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"手机号码不能为空!"];
        [_nameField becomeFirstResponder];
        return;
    }
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    [self textFieldResponed:nil];
    
    NSString *msg = [NSString stringWithFormat:@"COOL170将发送验证短信到这个手机号:%@",[_nameField.text Trim]];
    [AlertHelper showAlertWithTitle:@"修改密码" message:msg cancelTitle:@"取消" cancelAction:nil confirmTitle:@"确认" confirmAction:^{
        
        
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[_nameField.text Trim], @"phone",kNoLoginAuthToken, @"token", nil];
        
        [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceQueryUserExist completed:^(NSDictionary *userInfo) {
            NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
            if (result==0){ //存在
                
                 NSString *rtn1 = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"exists"]];
                if (![rtn1 isEqualToString:@"1"]) {
                    [AlertHelper showAlertWithMessage:@"此手机号码没有注册!"];
                    return;
                }
                
                ForgetPasswordViewController *forgetController=[[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
                forgetController.mobile=[_nameField.text Trim];
                [self.navigationController pushViewController:forgetController animated:YES];
                
            }
            else{
                [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
            }
        }];
        
    }];
    
    
   
    
    
}
//文本值监听
- (void)textValueChanged:(NSNotification*)notification{
    
    NSString *phone=[_nameField.text Trim];
    NSString *pwd=[_pwdField.text Trim];
    
    if ([phone length]>0&&[pwd length]>0) {
        _loginBtn.enabled = YES;
    }else{
        _loginBtn.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.nameField) {
        return (range.location<11);
    }
    if (textField==self.pwdField) {
        return (range.location<16);
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}
@end
