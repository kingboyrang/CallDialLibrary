//
//  CZRequestBaseArgs.h
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CZRequestHeaderKey.h"



//请求方式
typedef enum {
   ServiceHttpGet=0,
   ServiceHttpPost,
   ServiceHttpPut,
   ServiceHttpDelete
}ServiceHttpWay;


@class ASIHTTPRequest;

@interface CZRequestArgs : NSObject

/**
 *  服务地址
 */
@property (nonatomic,copy)     NSString *httpServer;
/**
 *  agw版本,默认值为01
 */
@property (nonatomic,copy)     NSString *agwVersion;

/**
 *  请求业务类型
 */
@property (nonatomic,assign)   CZServiceRequestType serviceType;

/**
 *  请求方式post,get,put,delete,默认请求方式为post
 */
@property (nonatomic,assign)   ServiceHttpWay httpway;

/**
 *  用户Id号
 */
@property (nonatomic,strong)   NSString *userId;


/**
 *  用户请求唯一key,默认值由[时间+serviceType]组成
 */
@property (nonatomic,readonly) NSString *requestKey;


/**
 *  基于参数data封装(其它参数)
 *
 *  @param firstObject 可变参数 key与value组成
 */
-(void)paramWithObjectsAndKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  一次性设置所有请求参数
 *
 *  @param params 请求参数 key与value组成
 */
-(void)addParamWithDictionary:(NSDictionary*)params;


/**
 *  可重设请求的URL
 *
 *  @param aRequestURL 重设URL方法
 */
- (void)setCZRequestURL:(NSURL*(^)())aRequestURL;
/**
 *  可重设请求的传递PostData
 *
 *  @param aRequestData 重设的PostData方法
 */
- (void)setCZRequestPostData:(NSData*(^)())aRequestData;

/**
 *  动态添加属性值
 *
 *  @param propertyName 属性名
 *  @param value        属性值
 */
- (void)addAssociatedWithPropertyName:(NSString *)propertyName withValue:(id)value;
/**
 *  取得动态属性值
 *
 *  @param propertyName 属性名
 *
 *  @return 属性值
 */
- (id)getAssociatedValueWithPropertyName:(NSString *)propertyName;

/**
 *  取得请求的URL
 *
 *  @return 取得请求的URL
 */
- (NSURL*)GetRequestURL;
/**
 *  取得请求的传递数据
 *
 *  @return 取得Post数据
 */
- (NSData*)GetPostData;

/**
 *  取得请求asi对象
 *
 *  @return 取得请求asi对象
 */
- (ASIHTTPRequest*)GetHttpRequest;

@end
