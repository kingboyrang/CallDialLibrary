//
//  DialplateViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "DialplateViewController.h"
#import "MKDialplateView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WldhTabBarController.h"



@interface DialplateViewController ()
@property (nonatomic,strong) UIView *showSegAndNumberView;  //显示segmen和输入号码的view
@property (nonatomic,strong) UIView *recentCallView;
@end

@implementation DialplateViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  UIColorMakeRGB(247, 247, 241);
    
    WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    //添加底部
    [tab addDialView:self.dialplateView.dialplateBottomView];
    
    //拨号盘的布局
    CGRect rect = self.dialplateView.frame;
    rect.origin.y -= (kTabbarRealHeight + kNavigationBarRealHeight);
    self.dialplateView.frame = rect;
    //更新其它布局
    [self subViewUpdateUI];
    //添加其它UI
    [self initCallUI];
}


- (void)showDialplateViewStatus:(BOOL)status{

    if (status) {
        self.dialplateView.dialplateBottomView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.dialplateView.dialplateBottomView.alpha = 1.0;
        } completion:^(BOOL finished) {
            WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            //添加底部
            [tab makeTabBarHidden:YES];
        }];
        
    }else{
        self.dialplateView.dialplateBottomView.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.dialplateView.dialplateBottomView.alpha = 0.0;
        } completion:^(BOOL finished) {
            WldhTabBarController *tab=(WldhTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            //添加底部
            [tab makeTabBarHidden:NO];
        }];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

   CGRect r=self.showSegAndNumberView.frame;
   r.origin.x=0;
   r.size.width=self.view.bounds.size.width;
   self.showSegAndNumberView.frame=r;
   self.navigationItem.titleView = self.showSegAndNumberView;

}
- (void)initCallUI
{
    
    //显示segment和手机号码的view
    self.showSegAndNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [self.showSegAndNumberView addSubview:self.showDialNumberView];
    
    //是否隐藏最近通话
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHiddenRecent:) name:@"KDialNumberViewValueChanged" object:nil];
    
}
//是否隐藏最近通话
- (void)receiveHiddenRecent:(NSNotification*)notification{
    if (self.recentCallView) {
        NSString *str=[notification.userInfo objectForKey:@"text"];
           if ([str length]==0) {
               self.recentCallView.hidden=NO;
           }else{
               self.recentCallView.hidden=YES;
           }
    }
   
}

//编辑
- (void)editClick:(UIButton*)btn{

    [self.callRecordsListVc.callRecordListTable setEditing:!self.callRecordsListVc.callRecordListTable.editing animated:YES];
    
    if (self.callRecordsListVc.callRecordListTable.editing) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
