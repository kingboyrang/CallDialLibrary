//
//  LoginViewController.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "WebViewController.h"


@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    
    //设代理
    self.phoneField.delegate=self;
    self.passwordField.delegate=self;
    
    //注册按钮
    UIImage *btnImgNor= [UIImage imageNamed:@"btn_nor.png"];
    btnImgNor = [btnImgNor stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_registerBtn setBackgroundImage:btnImgNor forState:UIControlStateNormal];
    
    UIImage *btnImgSel = [UIImage imageNamed:@"btn_sel.png"];
    btnImgSel = [btnImgSel stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_registerBtn setBackgroundImage:btnImgSel forState:UIControlStateHighlighted];
    
    UIImage *btnImgDis = [UIImage imageNamed:@"btn_dis.png"];
    btnImgDis = [btnImgDis stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_registerBtn setBackgroundImage:btnImgDis forState:UIControlStateDisabled];
    _registerBtn.enabled = NO;
    
    //登录
    [self addRightMenuItemWithTitle:@"登录" target:self action:@selector(loginClick)];
    
    //得到焦点
    [_phoneField becomeFirstResponder];
    
    //失去焦点
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGr];
    
    //文本值监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [_phoneField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_passwordField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}
//文本值监听
- (void)textValueChanged:(NSNotification*)notification{
    
    NSString *phone=[_phoneField.text Trim];
    NSString *pwd=[_passwordField.text Trim];
    
    if ([phone length]>0&&[pwd length]>0) {
        _registerBtn.enabled = YES;
    }else{
        _registerBtn.enabled = NO;
    }
}

//登录
- (void)loginClick{
    
    LoginViewController *loginController=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginController animated:YES];
}
//注册
- (IBAction)registerClick:(id)sender {
    if ([_phoneField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"手机号码不能为空!"];
        [_phoneField becomeFirstResponder];
        return;
    }
    if ([_passwordField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"密码不能为空!"];
        [_passwordField becomeFirstResponder];
        return;
    }
    
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    [self textFieldResponed:nil];
    
    //手机号码
    NSString *phone=[_phoneField.text Trim];
    
    if ((phone.length == 11)&&(([phone hasPrefix:@"13"])||([phone hasPrefix:@"14"])||([phone hasPrefix:@"15"])||([phone hasPrefix:@"17"])||([phone hasPrefix:@"18"]))) {
        
        NSString *str = [[NSString alloc] initWithFormat:@"COOL170将会发送验证短信到这个手机号：%@",phone];
        [AlertHelper showAlertWithTitle:@"确认手机号" message:str cancelTitle:@"取消" cancelAction:^{
            
        } confirmTitle:@"确定" confirmAction:^{
            //发送短信验证手机
             NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:phone, @"to",@"register", @"type",kNoLoginAuthToken, @"token", nil];
            [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServicePhoneSMS completed:^(NSDictionary *userInfo) {
                NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
                if (result==0){
                    //跳转验证手机

                }
                else{
                    [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
                }
            }];
        }];
        
    }else{
        [AlertHelper showAlertWithMessage:@"请输入有效的手机号码!"];
    }
}
//用户协议
- (IBAction)userAgreeClick:(id)sender {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wap" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //获取html路径
    NSString *path = [bundle pathForResource:@"service" ofType:@"html"];
    
    WebViewController *webController=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webController.urlString=path;
    webController.title = @"用户协议";
    [self.navigationController pushViewController:webController animated:YES];
    
    
}
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr{
    [_phoneField resignFirstResponder];
    [_passwordField resignFirstResponder];
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
    if (textField==self.phoneField) {
         return (range.location<11);
    }
    if (textField==self.passwordField) {
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
