//
//  WebController.h
//  CoolTalk
//
//  Created by BreazeMago on 15/5/29.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : BaseViewController
@property (nonatomic,strong) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
