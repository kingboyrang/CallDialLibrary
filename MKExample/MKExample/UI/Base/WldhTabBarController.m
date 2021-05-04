//
//  WldhTabBarController.m
//  WldhMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "WldhTabBarController.h"
#import "DialplateViewController.h"
#import "ContactManager.h"
#import "WldhNavigationController.h"

#define kWldhTabBarButtonBaseTag 9999
#define kWldhTabBarMsgBaseTag    6666

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static WldhTabBarController *sharedRechargeViewController = nil;
@interface WldhTabBarController ()
{
    NSArray *titileArr;
}
//@property (nonatomic, copy) void (^hideview)();

@property (nonatomic,strong) UIView *coverView;

@end

@implementation WldhTabBarController
@synthesize _tabBarButtons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        
    }
    return self;
}

+(WldhTabBarController *)shareInstance
{
    return  sharedRechargeViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
   

    /**
    //1.UI框架初始化
    //隐藏系统的tabbar
    //self.tabBar.hidden = YES;
    [self makeTabBarHidden:YES];
    titileArr = [NSArray arrayWithObjects:@"拨号",@"联系人",@"我",nil];
    //创建自定义的tabbar
    [self createCustomTabbar];
    sharedRechargeViewController = self;
    **/
    
    //监听拨号盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideDialplateAction:) name:@"dialplateIsHidden" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载联系人
    //[[ContactManager shareInstance] loadAllContact];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (item.tag == 0) {

        //拨号盘隐藏了，则显示
        WldhNavigationController *nav = (WldhNavigationController *)self.viewControllers[item.tag];
        if([nav.topViewController isKindOfClass:[DialplateViewController class]]){
           DialplateViewController *dialview = (DialplateViewController *)nav.topViewController;
            if (dialview) {
                [dialview.dialplateView showDialplate];
            }
        }
    }
    
}

//添加拨打显示界面
- (void)addDialView:(UIView*)dialView{
    if (![self.view.subviews containsObject:dialView]) {

        CGRect aRect = self.tabBar.frame;
        dialView.frame=aRect;
        dialView.alpha=0.0;
        [self.view addSubview:dialView];
    }

}

- (void)hideDialplateAction:(NSNotification *)notification
{
    
   
}


-(void)makeTabBarHidden:(BOOL)hide
{
    for(UIView *view in self.view.subviews)
    {
		if([view isKindOfClass:[UITabBar class]])
        {
			view.hidden = hide;
			break;
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dialplateIsHidden" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
