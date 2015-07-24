//
//  CZServiceManager.m
//  CZMini
//
//  Created by mini1 on 14-5-29.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "CZServiceManager.h"
#import "CZMyLog.h"
@interface CZServiceManager (){
    NSMutableDictionary *_requestDict;
    void (^BlockFinishedServiceManager) (NSDictionary *resultDic);
}
@end

@implementation CZServiceManager

+ (CZServiceManager *)shareInstance
{
    static dispatch_once_t  onceToken;
    static CZServiceManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[CZServiceManager alloc] init];
    });
    return sSharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _requestDict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self;
}

- (void)requestServiceWithRequestMethod:(ServiceHttpWay)httpMethod requestServiceParams:(NSDictionary*)params requestServiceType:(CZServiceRequestType)requestType completed:(void(^)(NSDictionary *userInfo))finished{

    @synchronized(_requestDict)
    {
        CZRequestArgs *args=[[CZRequestArgs alloc] init];
        args.serviceType=requestType;
        args.httpway=httpMethod;
        [args addParamWithDictionary:params];
        [self requestServiceWithArgs:args completed:finished];
    }

}


/**
 *  request请求(无参请求)
 *
 *  @param params           请求参数
 *  @param requestType      请求类型
 *  @param completed        请求完成的block
 *
 */
- (void)requestServiceWithDictionary:(NSDictionary*)params requestServiceType:(CZServiceRequestType)requestType completed:(void(^)(NSDictionary *userInfo))finished{
    @synchronized(_requestDict)
    {
        CZRequestArgs *args=[[CZRequestArgs alloc] init];
        args.serviceType=requestType;
        [args addParamWithDictionary:params];
        [self requestServiceWithArgs:args completed:finished];
    }
}

/**
 *  request请求(无参请求)
 *
 *  @param requestType      请求类型
 *  @param completed        请求完成的block
 *
 */
- (void)requestServiceWithType:(CZServiceRequestType)requestType completed:(void(^)(NSDictionary *userInfo))finished{
    
    @synchronized(_requestDict)
    {
        CZRequestArgs *args=[[CZRequestArgs alloc] init];
        args.serviceType=requestType;
        [self requestServiceWithArgs:args completed:finished];
    }
}

/**
 *  request请求
 *
 *  @param args             请求参数对象
 *  @param completed        请求完成的block
 *
 */
- (void)requestServiceWithArgs:(CZRequestArgs*)args completed:(void(^)(NSDictionary *userInfo))finished{
    
    @synchronized(_requestDict)
    {
        CZRequestObj *requestObj = [[CZRequestObj alloc] init];
        [_requestDict setObject:requestObj forKey:args.requestKey];
        [requestObj requestService:args delegate:self];
        
        BlockFinishedServiceManager=finished;
    }
}

/**
 *  request请求停止
 *
 *  @param requestName  停止请求名称
 *
 */
- (void)stopRequestWithName:(NSString*)requestName{
    @synchronized(_requestDict)
    {
        CZRequestObj *tempRequest = [_requestDict objectForKey:requestName];
        if(tempRequest)
        {
            [tempRequest stopRequest];
            [_requestDict removeObjectForKey:requestName];
        }
    }
}
#pragma mark -CZRequestObjDelegate Methods
- (void)CZRequestFailed:(CZRequestObj *)requestObj error:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary * dic=[NSDictionary dictionaryWithObjectsAndKeys:
                        error.code==-999?@"返回数据为空":@"服务请求失败!",@"val",
                        @"-9999",@"flag",nil];
    [self CZRequestFinished:requestObj resultDict:dic];
    [CZMyLog writeLog:[NSString stringWithFormat:@"%@",dic]];
    if (BlockFinishedServiceManager) {
        BlockFinishedServiceManager(dic);
    }
}

- (void)CZRequestFinished:(CZRequestObj*)requestObj resultDict:(NSDictionary *)resultDict
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithDictionary:resultDict];
    [_requestDict removeObjectForKey:requestObj.requestArgs.requestKey];
    [CZMyLog writeLog:[NSString stringWithFormat:@"%@",resultDict]];
    if (BlockFinishedServiceManager) {
        BlockFinishedServiceManager(userInfo);
    }
}
@end
