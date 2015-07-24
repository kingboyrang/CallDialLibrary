//
//  MKContact.m
//  MKContact
//
//  Created by wulanzhou on 15/6/15.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "MKContact.h"
#import "ContactManager.h"
#import "ContactUtils.h"

@interface MKContact (){
    UIImage *_headImage;
}

@end


@implementation MKContact

@synthesize defaultHeadPhotoImage=_headImage;

+ (MKContact *)shareInstance
{
    static dispatch_once_t  onceToken;
    static MKContact * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[MKContact alloc] init];
    });
    return sSharedInstance;
}

- (id)init{
    if (self=[super init]) {
        
        _headImage=[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
    }
    return self;
}

/**
 *  @author wulanzhou, 15-02-28 10:02:40
 *
 *  @brief  加载联系人归属地
 */
+ (void)loadContactAttribution
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *filePath = [bundle pathForResource:@"upbkAtt" ofType:@"dat"];
    [[ContactManager shareInstance].myPhoneOwnerShipEngine loadDataWithFilePath:filePath];
    
    [ContactUtils setCurrentCountryCode];
}

/**
 *  @author wulanzhou, 15-06-15 04:57:40
 *
 *  @parm   userId  用户Id
 *  @brief          创建用户通话记录数据库
 */
+ (void)createDataBaseWithUserId:(NSString*)userId{
    //创建用户数据库
    [[WldhDBManager shareInstance] createUserDatabase:userId];
}

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
+ (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type;
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    //NSData *imageData=[NSData dataWithContentsOfFile:imagePath];
    //return [[UIImage alloc] initWithContentsOfFile:imagePath];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
