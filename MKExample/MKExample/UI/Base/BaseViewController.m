//
//  BaseViewController.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "BaseViewController.h"
#import "UIColor+CZExtend.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorFromHexRGB:@"F4F5EE"];
    self.view.backgroundColor = UIColorMakeRGB(247, 247, 241);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //返回按钮
    if (self.navigationController&&[self.navigationController.viewControllers count]>1) {
        UIImage *btnImgNor = [UIImage imageNamed:@"nav_back_nor.png"];
        UIImage *btnImgSel = [UIImage imageNamed:@"nav_back_sel.png"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setImage:btnImgNor forState:UIControlStateNormal];
        [aButton setBackgroundImage:btnImgSel forState:UIControlStateHighlighted];
        aButton.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
        [aButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setLeftBarButtonItem:aBarButtonItem];
    }
   
    
    
    //添加一个  ios的用户习惯行为
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    //设置滑动方向，下面以此类推
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (BOOL)isNavigationBack{
    return YES;
}
//导航右边按钮
- (void)addRightMenuItemWithTitle:(NSString*)title target:(id)target action:(SEL)action{
    UIButton  *_rightcustomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightcustomButton.frame = CGRectMake(0, 0, 40, 30);
    [_rightcustomButton setTitle:title forState:UIControlStateNormal];
    [_rightcustomButton setTitle:title forState:UIControlStateHighlighted];
    [_rightcustomButton setTitleColor:UIColorMakeRGB(0, 181, 31) forState:UIControlStateNormal];
    [_rightcustomButton setTitleColor:UIColorMakeRGB(0, 181, 31) forState:UIControlStateHighlighted];
    _rightcustomButton.titleLabel.font=[UIFont boldSystemFontOfSize:18.0];
    [_rightcustomButton addTarget:target
                           action:action
                 forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_rightcustomButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
- (void)back
{
    if (![self isNavigationBack]) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
