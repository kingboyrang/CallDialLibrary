//
//  WebController.m
//  CoolTalk
//
//  Created by BreazeMago on 15/5/29.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHTML];
}

- (void)loadHTML
{
    NSURL *webURL=[NSURL URLWithString:self.urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:webURL];
    [self.webView loadRequest:request];
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
