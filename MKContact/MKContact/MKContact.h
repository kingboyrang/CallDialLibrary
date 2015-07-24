//
//  MKContact.h
//  MKContact
//
//  Created by wulanzhou on 15/6/15.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKContact : NSObject

/**
 *  默认用户头像
 */
@property (nonatomic,readonly) UIImage *defaultHeadPhotoImage;

/**
 *  单例
 *
 *  @return
 */
+ (MKContact *)shareInstance;


/**
 *  @author wulanzhou, 15-06-15 04:57:40
 *
 *  @brief  加载联系人归属地
 */
+ (void)loadContactAttribution;

/**
 *  @author wulanzhou, 15-06-15 04:57:40
 *
 *  @parm   userId  用户Id
 *  @brief          创建用户通话记录数据库
 */
+ (void)createDataBaseWithUserId:(NSString*)userId;

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
+ (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type;
@end
