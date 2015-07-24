//
//  MKDialplateView.m
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKDialplateView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MKDialplateUtils.h"
//#import "ConfigSettingHandler.h"

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ScWidth [[UIScreen mainScreen] bounds].size.width
#define ScHeight [[UIScreen mainScreen] bounds].size.height

@implementation MKDialplateView
{
    NSInteger index;
    CGFloat keyboardPositionY;
    
    
    /***
     AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
     if(ScreenHeight > 480){
     myDelegate.autoSizeScaleX = ScreenWidth / 320;
     myDelegate.autoSizeScaleY = ScreenHeight / 568;
     }else{
     myDelegate.autoSizeScaleX = 1.0;
     myDelegate.autoSizeScaleY = 1.0;
     }
     **/
}

/**
 *  @brief  创建拨号盘的按钮
 *
 *  @param x        行号
 *  @param y        列好
 *  @param indexnum 用于寻找按钮的序列号
 *
 *  @return 按钮对象
 */
-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y Indexnum:(NSInteger)indexnum
{
    UIButton *button;
    //
    CGFloat frameX;
    CGFloat frameY;
    CGFloat btnWidth;
    CGFloat btnHeight;
    
    //320分3列，中间为107两边为106
//    btnWidth = (0==y%2) ? 107.0:106.0;
    btnWidth = [UIScreen mainScreen].bounds.size.width /3;
    btnHeight = 59.0;
    
    //X坐标
    switch (y)
    {
        case 0:
            frameX = 0.0;
            break;
        case 1:
            frameX = btnWidth;
            break;
        case 2:
            frameX = btnWidth *2;
            break;
        default:
            break;
    }
    //Y坐标
    if (x == 0) {
        frameY = 0;
    } else
    {
        frameY = 59*x;
    }
    button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY, btnWidth, btnHeight)];
    
       /**
    //数字键
    NSString *numberImageName=[NSString stringWithFormat:@"dial_num_%ld_normal",(long)indexnum];
    UIImage *numberImage=[MKDialplateUtils getImageFromResourceBundleWithName:numberImageName type:@"png"];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(25, 14, numberImage.size.width, numberImage.size.height)];
    [imageView setImage:numberImage];
    [button addSubview:imageView];
    
    //高亮设置
    UIImage *imagehighlight = [MKDialplateUtils getImageFromResourceBundleWithName:@"dial_call_sel" type:@"png"];
    [button setBackgroundImage:imagehighlight forState:UIControlStateHighlighted];
    button.imageEdgeInsets=UIEdgeInsetsMake(5, 8, 5, 8);
    **/
    
    //设置背景图片 普通和高亮
 
    NSString *nor = [NSString stringWithFormat:@"dial_num_%ld_normal",(long)indexnum];
    [button setImage:[MKDialplateUtils getImageFromResourceBundleWithName:nor type:@"png"] forState:UIControlStateNormal];
    UIImage *bgImage = [MKDialplateUtils imageWithColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:236/255.0 alpha:1.0]];
    
    //UIColor * highlightColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.15];
    UIImage *imagehighlight =[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_call_sel" type:@"png"];
    //[MKDialplateUtils imageWithColor:highlightColor];
    
    
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    [button setBackgroundImage:imagehighlight forState:UIControlStateHighlighted];
     
    button.tag = indexnum; //1-12
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //如果是删除按钮 tag==13情况,增加长按事件
    if (button.tag == 13) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 1.0; //定义按的时间
        [button addGestureRecognizer:longPress];
    }
    
    //黏贴长按事件
    if (button.tag==12) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(btnPaseLong:)];
        longPress.minimumPressDuration = 1.0; //定义按的时间
        [button addGestureRecognizer:longPress];
    }
    
    //添加按键音
    [button addTarget:self action:@selector(playSystemSound) forControlEvents:UIControlEventTouchDown];
    
    return button;
}

/**
 *  @brief  按钮点击事件，由代理实现
 *
 *  @param sender 被点击的按钮
 */
- (void)clickButton:(UIButton *)sender
{
    //长按删除
    if(sender.tag == 13)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(DialnumberKeyboardBackspace:)])
        {
            [self.delegate DialnumberKeyboardBackspace:sender];
        }
    }
    else
    {
        NSInteger num;
        if (sender.tag == 11)
            num =0;
        else
            num = sender.tag;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewNumberInput:)]) {
            [self.delegate DialplateViewNumberInput:num];
        }
    }
}

/**
 *  @brief 按钮长按事件，由代理实现
 *
 *  @param gestureRecognizer
 */
- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewLongPress)])
        {
            [self.delegate DialplateViewLongPress];
        }
    }
}

/**
 *  @brief 长按事件黏贴
 *
 *  @param gestureRecognizer
 */
- (void)btnPaseLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewLongPressPase)])
        {
            [self.delegate DialplateViewLongPressPase];
        }
    }
}

/**
 *  @brief  拨号按钮事件，由代理实现
 *
 *  @param sender 拨号按钮
 */
- (void)call:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DialplateViewDialButtonClicked)]) {
        [self.delegate DialplateViewDialButtonClicked];
    }
}


/**
 *  @brief  初始化拨号键盘
 *
 *  @param position 拨号键盘的位置，大小是固定的
 *
 *  @return 拨号键盘对象
 */
- (MKDialplateView *)initWithPosition:(CGPoint)position
{
    //if (self = [super initWithFrame:CGRectMake(position.x, position.y, [UIScreen mainScreen].bounds.size.width, 285)])
    if (self = [super initWithFrame:CGRectMake(position.x, position.y, [UIScreen mainScreen].bounds.size.width, 236)])
    {
        self.numberKeypadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 236)];
        self.numberKeypadView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:236/255.0 alpha:1.0];
        for (int i=0; i<4; i++)
        {
            for (int j=0; j<3; j++)
            {
                index++;
                UIButton *button = [self creatButtonWithX:i Y:j Indexnum:index];
                [self.numberKeypadView addSubview:button];
            }
        }
        [self addSubview:self.numberKeypadView];
        
        
        self.dialplateBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, [UIScreen mainScreen].bounds.size.width, 49)];
        self.dialplateBottomView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:236/255.0 alpha:1.0];

        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        //拨号键盘
        UIImage *dial_callBtnNor =[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_keypad_down" type:@"png"];
        UIButton *dial_key_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        dial_key_btn.frame=CGRectMake((screenWidth/3-dial_callBtnNor.size.width)/2, 5, dial_callBtnNor.size.width, dial_callBtnNor.size.height);
        [dial_key_btn setBackgroundImage:dial_callBtnNor forState:UIControlStateNormal];
        UILabel *labkey=[[UILabel alloc] initWithFrame:CGRectMake(0,dial_callBtnNor.size.height, dial_callBtnNor.size.width, 10)];
        labkey.text=@"拨号";
        labkey.backgroundColor=[UIColor clearColor];
        labkey.font = [UIFont systemFontOfSize:10];
        labkey.textAlignment = NSTextAlignmentCenter;
        labkey.textColor=[UIColor colorWithRed:0 green:174/255.0 blue:19/255.0 alpha:1.0];
        [dial_key_btn addSubview:labkey];
        [dial_key_btn addTarget:self action:@selector(showHideDialplate) forControlEvents:UIControlEventTouchUpInside];
        [self.dialplateBottomView addSubview:dial_key_btn];

        //拨打按钮
        UIImage *callBtnNor =[MKDialplateUtils getImageFromResourceBundleWithName:@"call_btn_nor" type:@"png"];
        UIImage *callBtnDown =[MKDialplateUtils getImageFromResourceBundleWithName:@"call_btn_sel" type:@"png"];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        callBtn.frame = CGRectMake((screenWidth-callBtnNor.size.width)*0.5, 5, callBtnNor.size.width, callBtnNor.size.height);
       
        [callBtn setBackgroundImage:callBtnNor forState:UIControlStateNormal];
        [callBtn setBackgroundImage:callBtnDown forState:UIControlStateHighlighted];
        //[callBtn setTitle:@"呼叫" forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self.dialplateBottomView addSubview:callBtn];
        
        //删除
        UIImage *callDelNor=[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_delete_nor" type:@"png"];
        UIImage *callDelSel=[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_delete_sel" type:@"png"];
        UIButton *btnDel=[UIButton buttonWithType:UIButtonTypeCustom];
        btnDel.tag=13;
        btnDel.frame=CGRectMake(screenWidth*2/3+(screenWidth/3-callDelNor.size.width)/2,5, callDelNor.size.width, callDelNor.size.height);
        [btnDel setBackgroundImage:callDelNor forState:UIControlStateNormal];
        [btnDel setBackgroundImage:callDelSel forState:UIControlStateHighlighted];
        
        UILabel *labDel=[[UILabel alloc] initWithFrame:CGRectMake(0,callDelNor.size.height, callDelNor.size.width, 10)];
        labDel.text=@"删除";
        labDel.backgroundColor=[UIColor clearColor];
        labDel.font = [UIFont systemFontOfSize:10];
        labDel.textAlignment = NSTextAlignmentCenter;
        labDel.textColor=[UIColor colorWithRed:0 green:174/255.0 blue:19/255.0 alpha:1.0];
        [btnDel addSubview:labDel];
        [btnDel addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加按键音
        [btnDel addTarget:self action:@selector(playSystemSound) forControlEvents:UIControlEventTouchDown];
        //如果是删除按钮 tag==12情况,增加长按事件
        if (btnDel.tag == 13) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(btnLong:)];
            longPress.minimumPressDuration = 1.0; //定义按的时间
            [btnDel addGestureRecognizer:longPress];
        }
        [self.dialplateBottomView addSubview:btnDel];
        
        //view上方的线条
        UIColor *color = [UIColor colorWithRed:188/255.0 green:192/255.0 blue:199/255.0 alpha:1];
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        line1.backgroundColor = color;
        [self.dialplateBottomView addSubview:line1];
        
        //[self addSubview:self.dialplateBottomView];
        
        
        
    }
    return self;
}

/**
 *  @brief  显示或隐藏拨号键盘
 */
- (void)showHideDialplate{
    if (self.hidden) {
        [self showDialplate];
    }else{
        [self hideDialplate];
    }
}

/**
 *  @brief  显示拨号键盘
 */
- (void)showDialplate
{
    if (self.hidden) {
        CGRect platekeyboardframe = self.frame;
        platekeyboardframe.origin.y -= platekeyboardframe.size.height;
        self.hidden = NO;
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = platekeyboardframe;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowDialPlateNotificationChanged object:nil];
        }];
    }
}

/**
 *  @brief  隐藏拨号键盘
 */
- (void)hideDialplate
{
    if (!self.hidden) {
        CGRect temp = self.frame;
        temp.origin.y += temp.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = temp;
        }completion:^(BOOL finished) {
            self.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kHideDialPlateNotificationChanged object:nil];
        }];
    }
}
/**
 *  @brief  隐藏拨号键盘不带通知
 */
- (void)hide:(void(^)())completed{
    if (!self.hidden) {
        CGRect temp = self.frame;
        temp.origin.y += temp.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = temp;
        }completion:^(BOOL finished) {
            self.hidden = YES;
            if(completed)
            {
                completed();
            }
        }];
    }
}

/**
 *  @brief  播放系统按键音
 */
- (void)playSystemSound
{
    /**
    if(![ConfigSettingHandler isKeyPressSoundOn])
        return;
    **/
    
    SystemSoundID sID;
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
    {
        sID = 1109;
    }
    else
    {
        sID = 1201;
    }
    AudioServicesPlaySystemSound(sID);
}

@end
