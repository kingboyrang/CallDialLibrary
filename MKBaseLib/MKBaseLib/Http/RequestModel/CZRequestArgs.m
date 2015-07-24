//
//  CZRequestBaseArgs.m
//  CZBaseFramework
//
//  Created by wulanzhou-mini on 15-5-13.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#import "CZRequestArgs.h"
#import "CZRequestHandler.h"
#import "ASIHTTPRequest.h"
#import "CZMyLog.h"
#import <objc/runtime.h>

@interface CZRequestArgs (){
    NSURL* (^BlockRequestURL)();
    NSData* (^BlockRequestPostData)();
    
    NSMutableDictionary *postDataDic_;
    NSString *requestKey_;
}
@property (nonatomic,readonly) NSMutableDictionary *postDataDic;
@property (nonatomic,strong) NSMutableArray *postParams;
@end


@implementation CZRequestArgs
@synthesize postDataDic=postDataDic_;
@synthesize requestKey=requestKey_;


- (id)init{
    if (self=[super init]) {
        self.postParams=[[NSMutableArray alloc] initWithCapacity:0];
        postDataDic_=[NSMutableDictionary dictionaryWithCapacity:0];
        
        self.serviceType=CZServiceNone;
        self.httpway=ServiceHttpPost;
        
        CZRequestConfig *config=[CZRequestHandler shareRequestConfig];
        self.httpServer=config.httpServer;
        self.agwVersion=config.agwVersion;
        self.userId=config.userId;
    }
    return self;
}
- (NSString*)requestKey{
    if (requestKey_&&[requestKey_ length]>0) {
        return requestKey_;
    }
    NSString *key = [NSString stringWithFormat:@"%d_%@",
                     self.serviceType,
                     [NSDate date]];
    
    requestKey_=key;
    return requestKey_;
}
/**
 *  基于参数(data=)封装
 *
 *  @param firstObject 可变参数 key与value组成
 */
-(void)paramWithObjectsAndKeys:(NSString*)firstObject, ... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *values=[NSMutableArray arrayWithCapacity:0];
    NSMutableArray *keys=[NSMutableArray arrayWithCapacity:0];
    NSInteger index=0;
    va_list args;
    va_start(args,firstObject);
    if(firstObject)
    {
        [values addObject:firstObject];
        index++;
        NSString *otherString;
        while((otherString=va_arg(args,NSString*)))
        {
            if (index%2==0){
                [values addObject:otherString];
            }else{
                //依次取得所有参数
                [keys addObject:otherString];
            }
            index++;
        }
    }
    va_end(args);
    
    NSAssert([values count]==[keys count], @"paramWithObjectsAndKeys方法设置的key与value不匹配!");
    
    if([keys count]>0&&[values count]>0)
    {
        for(NSInteger i=0;i<[values count];i++)
        {
            [self setParamValue:[values objectAtIndex:i] name:[keys objectAtIndex:i]];
        }
    }
}

/**
 *  一次性设置所有请求参数
 *
 *  @param params 请求参数 key与value组成
 */
-(void)addParamWithDictionary:(NSDictionary*)params{
    if(params&&[params count]>0){
        [postDataDic_ addEntriesFromDictionary:params];
    }
}


/**
 *  基于参数(data=)封装
 *
 *  @param value 参数值
 *  @param key   参数名
 */
- (void)setParamValue:(NSString*)value name:(NSString*)key{
    [self.postParams addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    [postDataDic_ setValue:value forKey:key];
}
#pragma mark -请求方法重写
- (void)setCZRequestURL:(NSURL*(^)())aRequestURL{
    BlockRequestURL=aRequestURL;
}
- (void)setCZRequestPostData:(NSData*(^)())aRequestData{
    BlockRequestPostData=aRequestData;
}
#pragma mark -动态添加属性
- (void)addAssociatedWithPropertyName:(NSString *)propertyName withValue:(id)value {
    id property = objc_getAssociatedObject(self, &propertyName);
    if(property == nil)    {
        property = value;
        objc_setAssociatedObject(self, &propertyName, property, OBJC_ASSOCIATION_RETAIN);
    }
}
- (id)getAssociatedValueWithPropertyName:(NSString *)propertyName {
    id property = objc_getAssociatedObject(self, &propertyName);
    return property;
}
#pragma mark - request url
- (NSString*)basicURLString{
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@",
                         self.httpServer,
                         self.agwVersion];
    
    NSAssert(self.httpServer!=nil||[self.httpServer length]!=0, @"请设置请求服务地址!");
    return baseUrl;
}
- (NSURL*)GetRequestURL{
    if (BlockRequestURL) {
        return BlockRequestURL();
    }
    return [NSURL URLWithString:[self requestURLString:[self basicURLString]]];
}
- (NSString*)requestURLString:(NSString*)baseUrl{
    NSString *strUrl = nil;
    
    switch (self.serviceType)
    {
        case CZServiceRegister:          //注册
            strUrl = [NSString stringWithFormat:@"%@/user/register", baseUrl];
            break;
        case CZServiceQueryUserExist:          //查询用户是否存在
            strUrl = [NSString stringWithFormat:@"%@/user/exists", baseUrl];
            break;
        case CZServiceLogin:      //登录
            strUrl = [NSString stringWithFormat:@"%@/user/login", baseUrl];
            break;
        case CZServiceLoginOut:      //登出
            strUrl = [NSString stringWithFormat:@"%@/user/logout", baseUrl];
            break;
        case CZServiceEditPassword:      //修改密码
            strUrl = [NSString stringWithFormat:@"%@/user/passwd", baseUrl];
            break;
        case CZServiceResetPwdApply://重置密码请求
        {
            strUrl = [NSString stringWithFormat:@"%@/user/reset_passwd", baseUrl];
        }
            break;
        case CZServiceVerifyPhoneMsg://验证手机短信
        {
            strUrl = [NSString stringWithFormat:@"%@/user/verify_msg", baseUrl];
        }
            break;
        case CZServicePhoneSMS://发送手机短信(post请求)
        {
            strUrl = [NSString stringWithFormat:@"%@/sms", baseUrl];
        }
            break;
        case CZServiceMyMessage://我的信息(读取或修改)
        {
            strUrl = [NSString stringWithFormat:@"%@/user/me", baseUrl];
        }
            break;
        
        case CZServiceAuthToken://获取token
        {
            strUrl = [NSString stringWithFormat:@"%@/auth/token", baseUrl];
        }
            break;
        case CZServiceGroupMessage://获取组信息
        {
            strUrl = [NSString stringWithFormat:@"%@/auth/token", baseUrl];
        }
            break;
        case CZServiceGroupList://获取组列表
        {
            strUrl = [NSString stringWithFormat:@"%@/console/group_list", baseUrl];
        }
            break;
        case CZServiceAddGroup://添加组
        {
            strUrl = [NSString stringWithFormat:@"%@/console/add_group", baseUrl];
        }
            break;
        case CZServiceDeleteGroup://删除组
        {
            strUrl = [NSString stringWithFormat:@"%@/console/delete_group", baseUrl];
        }
            break;
        case CZServiceUpdateGroup://更新组
        {
            strUrl = [NSString stringWithFormat:@"%@/console/update_group", baseUrl];
        }
            break;
        case CZServiceQueryDetailGroup://查询详情组
        {
            strUrl = [NSString stringWithFormat:@"%@/console/group_detail", baseUrl];
        }
            break;
        case CZServiceVeritySMS://短信验证
        {
            strUrl = [NSString stringWithFormat:@"%@/sms", baseUrl];
        }
            break;
        case CZServiceAccountInfo://取得帐户信息
        {
            strUrl = [NSString stringWithFormat:@"%@/account/info", baseUrl];
        }
            break;
        case CZServiceAccountBalbance://取得帐户余额
        {
            strUrl = [NSString stringWithFormat:@"%@/account/balance", baseUrl];
        }
            break;
        case CZServiceProductList://产品列表
        {
            strUrl = [NSString stringWithFormat:@"%@/product/list", baseUrl];
        }
            break;
        case CZServiceProductDetail://产品明细
        {
            strUrl = [NSString stringWithFormat:@"%@/product/%@", baseUrl,self.userId];
        }
            break;
        case CZServiceGoodsList://商品列表
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/list", baseUrl];
        }
            break;
        case CZServiceGoodsDetail://商品明细
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/%@", baseUrl,self.userId];
        }
            break;
        case CZServiceGoodsPresenting://商品赠送
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/presenting", baseUrl];
        }
            break;
        case CZServiceGoodsOrder://商品预定
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/buy", baseUrl];
        }
            break;
        case CZServiceGoodsReturn://商品退订
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/return", baseUrl];
        }
            break;
        case CZServiceGoodsDueList://即将实效的商品列表
        {
            strUrl = [NSString stringWithFormat:@"%@/merchandise/due_list", baseUrl];
        }
            break;
        case CZServiceFriendsList://好友列表
        {
            strUrl = [NSString stringWithFormat:@"%@/contact/friends", baseUrl];
        }
            break;
        case CZServiceFriendsMessage://好友信息
        {
            strUrl = [NSString stringWithFormat:@"%@/contact/friends/%@", baseUrl,self.userId];
        }
            break;
        case CZServiceAddFriends://添加好友
        {
            strUrl = [NSString stringWithFormat:@"%@/contact/friends/add", baseUrl];
        }
            break;
        case CZServiceContactCallLogs://通话记录
        {
            strUrl = [NSString stringWithFormat:@"%@/contact/call_logs", baseUrl];
        }
            break;
        case CZServicePassClientSync://从云之讯同步client信息
        {
            strUrl = [NSString stringWithFormat:@"%@/passClient/sync", baseUrl];
        }
            break;
        case CZServicePassClientDetail://取得client详情信息
        {
            strUrl = [NSString stringWithFormat:@"%@/passClient/detail", baseUrl];
        }
            break;
        case CZServiceApplyPassClient://申请client
        {
            strUrl = [NSString stringWithFormat:@"%@/passClient/new", baseUrl];
        }
            break;
        case CZServiceMessageList://获取消息列表
        {
            strUrl = [NSString stringWithFormat:@"%@/news/list", baseUrl];
        }
            break;
        case CZServiceMessageDetail://获取消息列表
        {
            strUrl = [NSString stringWithFormat:@"%@/news/%@", baseUrl,self.userId];
        }
            break;
        case CZServiceSecretaryContact://小秘书电话
        {
            strUrl = [NSString stringWithFormat:@"%@/news/contact", baseUrl];
        }
            break;
        case CZServiceMessageReadCount://消息访问次数
        {
            strUrl = [NSString stringWithFormat:@"%@/news/%@/count_read", baseUrl,self.userId];
        }
            break;
        case CZServiceQRCodeContent://二维码内容
        {
            strUrl = [NSString stringWithFormat:@"%@/qrcode/get_content", baseUrl];
        }
            break;
        case CZServiceAddressBookVersion://通讯录版本
        {
            strUrl = [NSString stringWithFormat:@"%@/address_book/version", baseUrl];
        }
            break;
        case CZServiceAddressBookBackUp://通讯录备份
        {
            strUrl = [NSString stringWithFormat:@"%@/address_book/backup", baseUrl];
        }
            break;
        case CZServiceAddressBookRestore://通讯录列表
        {
            strUrl = [NSString stringWithFormat:@"%@/address_book/restore", baseUrl];
        }
            break;
            
        case CZServiceChargeCard://充值卡充值
        {
            strUrl = [NSString stringWithFormat:@"%@/charge_card/charge", baseUrl];
        }
            break;
        case CZServiceUploadLogs://上传日志
        {
            strUrl = [NSString stringWithFormat:@"%@/logs/backup", baseUrl];
        }
            break;
        case CZServiceLogsList://日志列表
        {
            strUrl = [NSString stringWithFormat:@"%@/logs/list", baseUrl];
        }
            break;
        case CZServiceLogsDetail://日志详情
        {
            strUrl = [NSString stringWithFormat:@"%@/logs/%@", baseUrl,self.userId];
        }
            break;
        case CZServicePhoneAttribute://号码归属地
        {
            strUrl = [NSString stringWithFormat:@"%@/ultity/mobile_attribution", baseUrl];
        }
            break;
            
        default:
        {
            NSAssert(self.serviceType!=CZServiceNone, @"没有设置CZServiceRequestType请求业务!");
           break;
        }
            
    }
    
    return strUrl;
}
#pragma mark -post data
//传递数据
- (NSData*)GetPostData{
    
    if (BlockRequestPostData) {
        return BlockRequestPostData();
    }
    
    if ([postDataDic_ count]==0) {
        return [[NSData alloc] init];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDataDic_ options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
   
    
    [CZMyLog writeLog:[NSString stringWithFormat:@"%@",postDataDic_]];
    //NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    return tempJsonData;
}
#pragma mark -私有方法

- (NSString*)getRequestMethodName{
    if (self.httpway==ServiceHttpGet) {
        return @"GET";
    }else if (self.httpway==ServiceHttpPost){
       return @"POST";
    }else if(self.httpway==ServiceHttpPut){
       return @"Put";
    }else{
       return @"Delete";
    }
}

/**
 *  取得请求asi对象
 *
 *  @return 取得请求asi对象
 */
- (ASIHTTPRequest*)GetHttpRequest{
    NSURL *webURL=[self GetRequestURL];
    [CZMyLog writeLog:webURL.absoluteString];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:webURL];
    NSData *postData=[self GetPostData];
    [request setPostBody:[NSMutableData dataWithData:postData]];
    [request setRequestMethod:[self getRequestMethodName]];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setTimeOutSeconds:10];
    return request;
}
@end
