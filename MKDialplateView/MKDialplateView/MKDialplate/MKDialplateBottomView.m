//
//  MKDialplateBottomView.m
//  MKDialplateView
//
//  Created by wulanzhou on 15/6/17.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "MKDialplateBottomView.h"
#import "MKDialplateUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MKDialplateBottomView

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
        //显示或隐藏拨打
        UIImage *dial_callBtnNor =[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_keypad_down" type:@"png"];
        UIButton *dial_key_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        dial_key_btn.frame=CGRectMake(46, 5, dial_callBtnNor.size.width, dial_callBtnNor.size.height);
        [dial_key_btn setBackgroundImage:dial_callBtnNor forState:UIControlStateNormal];
        UILabel *labkey=[[UILabel alloc] initWithFrame:CGRectMake(0,dial_callBtnNor.size.height, dial_callBtnNor.size.width, 10)];
        labkey.text=@"拨号";
        labkey.backgroundColor=[UIColor clearColor];
        labkey.font = [UIFont systemFontOfSize:10];
        labkey.textAlignment = NSTextAlignmentCenter;
        labkey.textColor=[UIColor colorWithRed:0 green:174/255.0 blue:19/255.0 alpha:1.0];
        [dial_key_btn addSubview:labkey];
        self.dialKeyboradButton=dial_key_btn;
        [self addSubview:dial_key_btn];
        
        
        //拨打按钮
        UIImage *callBtnNor =[MKDialplateUtils getImageFromResourceBundleWithName:@"call_btn_nor" type:@"png"];
        UIImage *callBtnDown =[MKDialplateUtils getImageFromResourceBundleWithName:@"call_btn_sel" type:@"png"];
        
        UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        callBtn.frame = CGRectMake((screenWidth-callBtnNor.size.width)*0.5, 5, callBtnNor.size.width, callBtnNor.size.height);
        
        [callBtn setBackgroundImage:callBtnNor forState:UIControlStateNormal];
        [callBtn setBackgroundImage:callBtnDown forState:UIControlStateHighlighted];
        //[callBtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        self.dialButton=callBtn;
        [self addSubview:callBtn];
        
        
        //删除
        UIImage *callDelNor=[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_delete_nor" type:@"png"];
        UIImage *callDelSel=[MKDialplateUtils getImageFromResourceBundleWithName:@"dial_delete_sel" type:@"png"];
        UIButton *btnDel=[UIButton buttonWithType:UIButtonTypeCustom];
        btnDel.tag=13;
        btnDel.frame=CGRectMake(self.bounds.size.width-callDelNor.size.width-46,5, callDelNor.size.width, callDelNor.size.height);
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
        self.delButton=btnDel;
        [self addSubview:self.delButton];
        
        
        
        
    }
    return self;
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
