//
//  WldhTabBarController.m
//  WldhMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "WldhTabBarController.h"
#import "DialViewController.h"
#import "ContactManager.h"

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
    
    
    NSLog(@"self.tabbar.frame =%@",NSStringFromCGRect(self.tabBar.frame));

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


//添加拨打显示界面
- (void)addDialView:(UIView*)dialView{
    if (![self.view.subviews containsObject:dialView]) {
        
        NSLog(@"dialView.frame =%@",NSStringFromCGRect(dialView.frame));
        
        CGRect aRect = self.tabBar.frame;
        dialView.frame=aRect;
        dialView.alpha=0.0;
        [self.view addSubview:dialView];
    }

}

- (void)hideDialplateAction:(NSNotification *)notification
{
    
    /**
    UIButton *dibtn = (UIButton *)[_wldhTabBarView viewWithTag:kWldhTabBarButtonBaseTag];
    UIImageView * btnimg = (UIImageView *)[dibtn viewWithTag:kWldhTabBarButtonBaseTag+100];
    [self rotate:btnimg andAnimationDuration:0.5 andWait:NO andAngle:180];
    **/
    
    /**
    NSLog(@"键盘隐藏");
    double _width = self.tabBar.frame.size.width / titileArr.count;
    
    if (self.selectedIndex == 0) {
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake((_width-34)/2, 3, 34, 34)];
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.userInteractionEnabled = NO;
        UIImageView * btnimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 31)];
        btnimg.image = [UIImage imageNamed:@"tab_0_pre.png"];
        [self.coverView addSubview:btnimg];
        [_wldhTabBarView addSubview:self.coverView];
    }
     **/
}


-(void)makeTabBarHidden:(BOOL)hide
{

    /**
    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
    
    if (hide) {
        contentView.frame = self.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height -
                                       self.tabBar.frame.size.height);
    }
    **/
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


- (void)createCustomTabbar
{
    CGRect aRect = self.tabBar.frame;
    
    
    _wldhTabBarBgView = [[UIView alloc] initWithFrame:aRect];
    _wldhTabBarBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    _wldhTabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width, aRect.size.height)];
    _wldhTabBarView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:236/255.0 alpha:1.0];
    [_wldhTabBarBgView addSubview:_wldhTabBarView];
    
    _wldhCallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aRect.size.width, aRect.size.height)];
    _wldhCallView.backgroundColor = [UIColor whiteColor];
    _wldhCallView.hidden = YES;
    [_wldhTabBarBgView addSubview:_wldhCallView];
    
    [self.view addSubview:_wldhTabBarBgView];
    
    NSInteger viewCount = self.viewControllers.count;
    _tabBarButtons = [[NSMutableArray alloc] initWithCapacity:viewCount];
    
    double _width = self.tabBar.frame.size.width / viewCount;
	double _height = self.tabBar.frame.size.height;
    
    //创建tabbar按钮
    for (int i = 0; i < viewCount; ++i)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( _width*i, 0, _width, _height);
		[btn addTarget:self action:@selector(tabbarChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *img;
        if (i == 0)
        {
            img = [UIImage imageNamed:@"tab_0_predown.png"];
        }else
        {
            img = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_nor.png",i]];
        }
        UIImageView * btnimg = [[UIImageView alloc] initWithFrame:CGRectMake((_width-30)/2, 3, 30, 30)];
        [btn addSubview:btnimg];
        btnimg.image=img;
        [btn setAdjustsImageWhenHighlighted:NO];
        btn.tag = i + kWldhTabBarButtonBaseTag;
        btnimg.tag =  i + kWldhTabBarButtonBaseTag + 100;
        [_tabBarButtons addObject:btn];
		[_wldhTabBarView addSubview:btn];
        
        
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, _width, 14)];
        bottomLab.backgroundColor = [UIColor clearColor];
        if (i == 0)
        {
            bottomLab.textColor = kColorFromRGB(0x06bf04);
        }else
        {
            bottomLab.textColor = RGB(123, 123, 123);
        }
        
        bottomLab.textAlignment = NSTextAlignmentCenter;
        bottomLab.font = [UIFont systemFontOfSize:11];
        bottomLab.text = [titileArr objectAtIndex:i];
        bottomLab.tag = 5000+i;
        [btn addSubview:bottomLab];
    }
    //创建线条
    UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    line1.backgroundColor = color;
    [_wldhTabBarView addSubview:line1];
    [_wldhCallView setHidden:YES];
    
}

- (void)tabbarChanged:(UIButton *)tabbtn
{
    NSInteger nextIndex = tabbtn.tag - kWldhTabBarButtonBaseTag; //切换到的标签序号
    
    if(nextIndex == 0)
    {
        UIViewController *curview = (UIViewController *)[self.viewControllers objectAtIndex:nextIndex];
        if ([curview class] == [DialViewController class] )
        {
            DialViewController * dialview = (DialViewController *) curview;
            UIImageView * btnimg =  (UIImageView *)[tabbtn viewWithTag:(tabbtn.tag + 100)];
            if (self.selectedIndex == nextIndex) {
                //键盘的相关动作处理
                if (dialview.dialplateVc.dialplateView.hidden)
                {
                    [dialview.dialplateVc.dialplateView showDialplate];
                    
                    if (self.coverView) {
                        [self.coverView removeFromSuperview];
                        self.coverView = nil;
                    }
                    
                    if (self.selectedIndex == 0) {
                        btnimg.image = [UIImage imageNamed:@"tab_0_predown.png"];
                    }

                    
                }else {
                    [dialview.dialplateVc.dialplateView hideDialplate];
                    if (self.selectedIndex == 0) {
                        btnimg.image = [UIImage imageNamed:@"tab_0_pre.png"];
                    }
                   

                    
                }
            }
        }
    }
    
    if (nextIndex != self.selectedIndex)
    {
        UINavigationController *nav = self.navigationController;
        if ([nav.viewControllers count] > 1)
        {
            [nav popToRootViewControllerAnimated:NO];
        }
        
        UIButton *oldBtn = [_tabBarButtons objectAtIndex:self.selectedIndex];
        
        UILabel *oldlab = (UILabel *)[oldBtn viewWithTag:(5000+self.selectedIndex)];
        oldlab.textColor = RGB(123, 123, 123);

        UILabel *btnlab = (UILabel *)[tabbtn viewWithTag:(5000+ nextIndex )];
        btnlab.textColor = kColorFromRGB(0x06bf04);
        
        UIImageView * oldimg = (UIImageView *)[oldBtn viewWithTag:(kWldhTabBarButtonBaseTag + 100+self.selectedIndex)];
        UIImageView * btnimg = (UIImageView *)[tabbtn viewWithTag:(kWldhTabBarButtonBaseTag + 100+nextIndex)];
        
        btnimg.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_pre.png",nextIndex]];
        oldimg.image = [UIImage imageNamed:[NSString stringWithFormat:@"tab_%d_nor.png",self.selectedIndex]];
        
        
        self.selectedIndex = nextIndex;
        _currentSelectedIndex = nextIndex;
    }
}

- (void)changedToIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.viewControllers count])
    {
        UIButton *tempBt = (UIButton *)[_tabBarButtons objectAtIndex:index];
        [self tabbarChanged:tempBt];
    }
    
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:YES];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = (UIViewController *)[self.viewControllers objectAtIndex:index] ;
    [lastController viewWillAppear:YES];
    
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
