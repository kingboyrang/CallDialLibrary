//
//  MKContactViewController.h
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKContactBasicViewController.h"
@class ContactNode;
@interface MKContactViewController : MKContactBasicViewController

/**
 *  @brief  设置父视图控制器
 *
 *  @param parent   父视图控制器
 *
 */
- (void)setParentController:(UIViewController *)parent;

/**
 *  @brief  tableview row点击事件，默认跳转到联系人详情(MKContactDetailViewController类)，子类可重写
 */
- (void)selectedItemWithContactNode:(ContactNode*)node;

/**
 *  @brief  创建新的联系人
 */
- (void)createNewContact;

/**
 *  酷秘团队 点击事件
 */
- (void)coolTeamClick;

@end
