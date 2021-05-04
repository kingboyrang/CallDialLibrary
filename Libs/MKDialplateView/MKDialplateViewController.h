//
//  MKDialplateViewController.h
//  MKDialplateView
//
//  Created by chenzhihao on 15-5-21.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKDialplateView.h"
#import "MKCallRecordViewController.h"


//拨号盘输入值是否发生改变
#define KDialNumberViewValueChanged  @"KDialNumberViewValueChanged"

@interface MKDialplateViewController : UIViewController 

//回拨相关参数
//被叫人的电话号码
@property (nonatomic,copy) NSString *calleePhoneNumber;
//呼叫人的UID
@property (nonatomic,copy) NSString *callerUid;
//呼叫人密码
@property (nonatomic,copy) NSString *callerPwd;
//品牌
@property (nonatomic,copy) NSString *brandId;
//服务器地址
@property (nonatomic,copy) NSString *mainHttpServerAddress;
//呼叫人的电话号码
@property (nonatomic,copy) NSString *callerPhoneNumber;

//通话记录列表
@property (nonatomic,strong) MKCallRecordViewController *callRecordsListVc;

//显示拨号盘当前输入的电话号码字符串
@property (nonatomic,strong) UIView *showDialNumberView;

//拨号盘view
@property (nonatomic,strong) MKDialplateView *dialplateView;

/**
 *  @brief  重新布局，根据设置的frame进行重新布局
 */
- (void)UpdateUI;

/**
*  @brief  根据拨号盘进行重新布局
*/
- (void)subViewUpdateUI;

/**
 *  @brief  拨打电话
 */
- (void)dialCallWithNumber:(NSString*)phone;

//显示底部拨打
- (void)showDialplateViewStatus:(BOOL)status;

@end
