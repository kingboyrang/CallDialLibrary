//
//  ModifyPassViewController.m
//  CoolTalk2
//
//  Created by BreazeMago on 15/4/20.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "Md5Encrypt.h"
#import "SystemUser.h"

@interface ModifyPwdViewController ()

@end

@implementation ModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改密码";
    
    //设代理
    self.oldPwdField.delegate=self;
    self.pwdField.delegate=self;
    
    //完成按钮
    UIImage *btnImgNor= [UIImage imageNamed:@"btn_nor.png"];
    btnImgNor = [btnImgNor stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_submitBtn setBackgroundImage:btnImgNor forState:UIControlStateNormal];
    
    UIImage *btnImgSel = [UIImage imageNamed:@"btn_sel.png"];
    btnImgSel = [btnImgSel stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_submitBtn setBackgroundImage:btnImgSel forState:UIControlStateHighlighted];
    
    UIImage *btnImgDis = [UIImage imageNamed:@"btn_dis.png"];
    btnImgDis = [btnImgDis stretchableImageWithLeftCapWidth:22 topCapHeight:22];
    [_submitBtn setBackgroundImage:btnImgDis forState:UIControlStateDisabled];
   
    //失去焦点
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldResponed:)];
    tapGr.delegate = self;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//失去焦点
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr{
    [_oldPwdField resignFirstResponder];
    [_pwdField resignFirstResponder];
}

//显示密码
- (IBAction)showPwdClick:(id)sender {
    UIButton *btn=(UIButton*)sender;
    if (btn.selected) {
        btn.selected=NO;
        self.pwdField.secureTextEntry=NO;
    }else{
        btn.selected=YES;
        self.pwdField.secureTextEntry=YES;
    }
}
//提交
- (IBAction)submitClick:(id)sender {
    
    if ([_oldPwdField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"原始密码不能为空!"];
        return;
    }
    
    if ([_pwdField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"新密码不能为空!"];
        return;
    }
    
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    [self textFieldResponed:nil];
    
     NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[Md5Encrypt md5:[_oldPwdField.text Trim]], @"pass",[Md5Encrypt md5:[_pwdField.text Trim]], @"new_pass", [SystemUser shareInstance].userId,@"uid",nil];
    
    [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceEditPassword completed:^(NSDictionary *userInfo) {
        NSString *result=[userInfo objectForKey:@"flag"];
        if ([result isEqualToString:@"0"]){//成功
            
            SystemUser *mod=[SystemUser shareInstance];
            mod.password=[_pwdField.text Trim];
            [mod saveUser];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if([result isEqual:@"1010"]){
            [AlertHelper showAlertWithMessage:@"用户不存在!"];
        }else if([result isEqual:@"1011"]){
            [AlertHelper showAlertWithMessage:@"旧密码错误!"];
        }else if([result isEqual:@"1012"]){
            [AlertHelper showAlertWithMessage:@"新密码无效!"];
        }else if([result isEqual:@"1013"]){
            [AlertHelper showAlertWithMessage:@"用户已锁定!"];
        }else if([result isEqual:@"1006"]){
            [AlertHelper showAlertWithMessage:@"新密码与旧密码相同!"];
        }else{
           [AlertHelper showAlertWithMessage:@"修改失败!"];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (range.location<16);
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
