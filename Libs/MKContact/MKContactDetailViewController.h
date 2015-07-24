//
//  MKContactDetailViewController.h
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKContactBasicViewController.h"
#import "ContactNode.h"


@interface MKContactDetailViewController : MKContactBasicViewController

//联系人对象
@property (nonatomic,strong) ContactNode *aContact;

/**
 *  短信发送内容(子类化重写)
 *
 *  @return  返回要发送的默认短信内容
 */
- (NSString*)GetSendSMS;

/**
 *  @brief  根据电话号码拨打电话
 *
 *  @param phone 电话号码
 */
- (void)makeCall:(NSString *)phone;

@end

