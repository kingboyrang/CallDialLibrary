//
//  SystemUser.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZBaseObject.h"

/**
 * 登录用户信息
 */
@interface SystemUser : CZBaseObject

+ (SystemUser*)shareInstance;

/**
 *  用户名称
 */
@property (nonatomic,strong) NSString *name;

/**
 *  手机号码
 */
@property (nonatomic,strong) NSString *phone;

/**
 *  服务器交互请求的token
 */
@property (nonatomic,strong) NSString *token;

/**
 *  服务器交互请求的token有效时间
 */
@property (nonatomic,strong) NSString *tokenValidDate;

/**
 *  用户UID号
 */
@property (nonatomic,strong) NSString *userId;

/**
 *  用户密码
 */
@property (nonatomic,strong) NSString *password;

/**
 *  云之讯token
 */
@property (nonatomic,strong) NSString *yunToken;

/**
 *  云之讯client number
 */
@property (nonatomic,strong) NSString *clientNubmer;

/**
 *  云之讯client password
 */
@property (nonatomic,strong) NSString *clientPassword;

/**
 *  是否登陆
 */
@property (nonatomic,assign) BOOL isLogin;


/**
 *  字典转换为对象
 *  @param dic 登录成功后的字典内容
 *  @reutrn    字典转对象
 */
- (id)initWithDictionary:(NSDictionary*)dic;

/**
 *  用户信息保存
 */
- (void)saveUser;
/**
 *  用户信息删除
 */
- (void)removeUser;

@end
