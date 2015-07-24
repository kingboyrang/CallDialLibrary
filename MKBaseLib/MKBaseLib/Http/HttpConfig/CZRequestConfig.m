//
//  CZRequestConfig.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-15.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CZRequestConfig.h"
#import <objc/runtime.h>
@implementation CZRequestConfig

- (id)init{
    if (self=[super init]) {
        self.httpServer=@"";
        self.agwVersion=@"01";
        //self.appVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        self.userId=@"";
    }
    return self;
}

//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        //获取类中所有成员变量名
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [decoder decodeObjectForKey:strName];
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}
//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
    free(ivar);
}
@end
