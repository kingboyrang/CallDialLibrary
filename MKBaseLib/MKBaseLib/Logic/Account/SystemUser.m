//
//  SystemUser.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-22.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "SystemUser.h"
#import "CacheDataUtil.h"
#import "CZRequestHandler.h"
#define kCZSystemUserCacheKey @"kCZSystemUserCacheKey"

@implementation SystemUser

- (id)init{
    if (self=[super init]) {
        self.name=@"";
        self.phone=@"";
        self.userId=@"";
        self.password=@"";
        self.yunToken=@"";
        self.token=@"";
        self.tokenValidDate=@"";
        self.clientNubmer=@"";
        self.clientPassword=@"";
        self.isLogin=NO;
    }
    return self;
}

+ (SystemUser*)shareInstance{
    SystemUser *config=[CacheDataUtil unarchiveValueForKey:kCZSystemUserCacheKey];
    if (config==nil) {
         config=[[SystemUser alloc] init];
    }
    return config;
}

/**
 *  字典转换为对象
 *  @param dic 登录成功后的字典内容
 *  @reutrn    字典转对象
 */
- (id)initWithDictionary:(NSDictionary*)dic{
    if (self=[super init]) {
        if (dic&&[dic count]>0) {
            self.userId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
            self.token=[dic objectForKey:@"token"];
            self.yunToken=[dic objectForKey:@"ucpaas_slc"];
            self.clientNubmer=[dic objectForKey:@"paas_client_number"];
            self.clientPassword=[dic objectForKey:@"paas_client_pwd"];
            self.tokenValidDate=[dic objectForKey:@"token_valid_to"];
        }
        
    }
    return self;
}

/**
 *  用户信息保存
 */
- (void)saveUser{    
    [CacheDataUtil setValueArchiver:self forKey:kCZSystemUserCacheKey];
    if (self.userId&&[self.userId length]>0&&self.password&&[self.password length]>0) {
        [CZRequestHandler setUserId:self.userId];
    }
}

/**
 *  用户信息删除
 */
- (void)removeUser{
    [CacheDataUtil removeForKey:kCZSystemUserCacheKey];
    [CZRequestHandler removeAccount];
}
@end
