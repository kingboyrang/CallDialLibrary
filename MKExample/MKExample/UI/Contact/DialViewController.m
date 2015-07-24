//
//  DialViewController.m
//  MKDemo
//
//  Created by chenzhihao on 15-5-25.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "DialViewController.h"



#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DialViewController ()



@property (nonatomic,strong) UIView *showSegAndNumberView;  //显示segmen和输入号码的view

@end

@implementation DialViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createUI
{
    /**
    self.containerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
    
    self.contactVc = [[ContactViewController alloc] init];
    [self.contactVc setParentController:self];
    self.contactVc.view.hidden = YES;
    self.contactVc.view.frame = self.containerView.bounds;
    [self addChildViewController:self.contactVc];
    [self.containerView addSubview:self.contactVc.view];
     **/
    
    self.dialplateVc = [[DialplateViewController alloc] init];
    self.dialplateVc.view.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49);
    self.dialplateVc.view.backgroundColor=self.view.backgroundColor;
    //self.containerView.bounds;
    [self.dialplateVc UpdateUI];    //传入所在view的bounds后需要重新布局
    [self addChildViewController:self.dialplateVc];
    [self.view addSubview:self.dialplateVc.view];
   
    
    //显示segment和手机号码的view
    self.showSegAndNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    
    /**
    self.recentCallView=[[UIView alloc] initWithFrame:self.showSegAndNumberView.bounds];
    self.recentCallView.backgroundColor=[UIColor clearColor];
    
    
    UILabel *labTitle=[[UILabel alloc] initWithFrame:self.showSegAndNumberView.bounds];
    labTitle.text=@"最近通话";
    labTitle.textAlignment=NSTextAlignmentCenter;
    labTitle.backgroundColor=[UIColor clearColor];
    labTitle.textColor=[UIColor blackColor];
    labTitle.font=[UIFont boldSystemFontOfSize:18];
    [self.recentCallView  addSubview:labTitle];
    
    //编辑按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.recentCallView.bounds.size.width-40-18,(self.recentCallView.bounds.size.height-30)/2, 40, 30)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget: self action: @selector(editClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.recentCallView addSubview:btn];
    
    [self.showSegAndNumberView addSubview:self.recentCallView];
     **/
    [self.showSegAndNumberView addSubview:self.dialplateVc.showDialNumberView];
    
    //是否隐藏最近通话
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHiddenRecent:) name:@"KDialNumberViewValueChanged" object:nil];
    
}
//是否隐藏最近通话
- (void)receiveHiddenRecent:(NSNotification*)notification{
    NSString *str=[notification.userInfo objectForKey:@"text"];
    if ([str length]==0) {
        self.recentCallView.hidden=NO;
    }else{
        self.recentCallView.hidden=YES;
    }
}

//编辑
- (void)editClick:(UIButton*)btn{

    [self.dialplateVc.callRecordsListVc.callRecordListTable setEditing:!self.dialplateVc.callRecordsListVc.callRecordListTable.editing animated:YES];
    
    if (self.dialplateVc.callRecordsListVc.callRecordListTable.editing) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //[self createSegment];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect r=self.showSegAndNumberView.frame;
    r.origin.x=0;
    r.size.width=self.view.bounds.size.width;
    self.showSegAndNumberView.frame=r;
    
    
   self.navigationItem.titleView = self.showSegAndNumberView;
    
    //NSLog(@"title frame=%@",NSStringFromCGRect(self.tabBarController.navigationItem.titleView.frame));
    //NSLog(@"showSegAndNumberView frame=%@",NSStringFromCGRect(self.showSegAndNumberView.frame));
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
