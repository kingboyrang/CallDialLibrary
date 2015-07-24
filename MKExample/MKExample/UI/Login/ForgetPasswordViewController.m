//
//  ForgetPasswordViewController.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Md5Encrypt.h"
#import "UIImage+CZExtend.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"忘记密码";
    
    self.phonelab.text=self.mobile;
    
    //设代理
    self.vertyField.delegate=self;
    self.pwdField.delegate=self;
    
    //确认按钮
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
    
    //开始计时
    [self startTimeDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//失去焦点
- (void)textFieldResponed:(UITapGestureRecognizer*)tapGr{
    [_vertyField resignFirstResponder];
    [_pwdField resignFirstResponder];
}
//再次发送验证码
- (IBAction)sendVertyClick:(id)sender {
    
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.mobile, @"phone",kNoLoginAuthToken, @"token", nil];
    
    [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceQueryUserExist completed:^(NSDictionary *userInfo) {
        NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
        if (result==0){ //存在
            // 发起请求,开始倒计时
            [self startTimeDown];
        }
        else{
            [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
        }
    }];
}
//提交
- (IBAction)submitClick:(id)sender {
    
    if ([_vertyField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"验证码不能为空!"];
        return;
    }
    if ([_pwdField.text isEmpty]) {
        [AlertHelper showAlertWithMessage:@"新密码不能为空!"];
        return;
    }
    
    [self textFieldResponed:nil];
    
    if (![CommonUtils isHasNetWork]) {
        [AlertHelper showAlertWithMessage:@"网络无法连接，请检查网络状况!"];
        return;
    }
    
    //重置密码
    NSString *pwd=[Md5Encrypt md5:[_pwdField.text Trim]];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.mobile, @"phone",[_vertyField.text Trim], @"SMSMsg",pwd,@"pass", nil];
    [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceResetPwdApply completed:^(NSDictionary *userInfo) {
        NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
        if (result==0){//重置成功
            
            //重新登录
        }
        else{
            [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
        }
    }];

    
}
#pragma mark -私有方法
//计时
- (void)startTimeDown
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0){
            dispatch_source_cancel(_timer);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"再次获取"];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0) {
                [string addAttribute:NSForegroundColorAttributeName
                               value:UIColorMakeRGB(0, 181, 31)
                               range:NSMakeRange(0, string.length)];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0){
                    [self.vertyBtn setAttributedTitle:string forState:UIControlStateNormal];
                }
                
                //[self.vertyBtn setBackgroundColor:[UIColor whiteColor]];
                [self.vertyBtn setBackgroundImage:[UIImage createImageWithColor:UIColorMakeRGB(203, 203, 203)]
                                                  forState:UIControlStateHighlighted];
                self.vertyBtn.userInteractionEnabled = YES;
            });
        } else {
            NSString *strTime = [NSString stringWithFormat:@"再次获取%ds", timeout];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strTime];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0) {
                if (timeout >= 10) {
                    [string addAttribute:NSForegroundColorAttributeName
                                   value:UIColorMakeRGB(0, 181, 31)
                                   range:NSMakeRange(4, 3)];
                } else {
                    [string addAttribute:NSForegroundColorAttributeName
                                   value:UIColorMakeRGB(0, 181, 31)
                                   range:NSMakeRange(4, 2)];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.vertyBtn setTitle:strTime forState:UIControlStateNormal];
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6.0){
                    [self.vertyBtn setAttributedTitle:string forState:UIControlStateNormal];
                }
                self.vertyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.vertyField) {
        return (range.location<7);
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
