//
//  MKContactBasicViewController.m
//  MKContact
//
//  Created by rang on 15/7/6.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "MKContactBasicViewController.h"
#import "MKContact.h"

@interface MKContactBasicViewController ()

@end

@implementation MKContactBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor=[UIColor colorWithRed:247/255.0 green:247/255.0 blue:241/255.0 alpha:1.0];
    
    self.navigationItem.hidesBackButton=NO;
    //返回按钮
    if (self.navigationController&&[self.navigationController.viewControllers count]>1) {
        UIImage *btnImgNor =[MKContact getImageFromResourceBundleWithName:@"nav_back_nor@2x" type:@"png"];
        UIImage *btnImgSel = [MKContact getImageFromResourceBundleWithName:@"nav_back_sel@2x" type:@"png"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setImage:btnImgNor forState:UIControlStateNormal];
        [aButton setBackgroundImage:btnImgSel forState:UIControlStateHighlighted];
        aButton.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
        aBarButtonItem.title=@"";
        [aButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setLeftBarButtonItem:aBarButtonItem];
    }
}
- (BOOL)isNavigationBack{
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
