//
//  CZRequestHeaderKey.h
//  CZVOIP
//
//  Created by wulanzhou-mini on 15-1-29.
//  Copyright (c) 2015年 wulanzhou-mini. All rights reserved.
//

#ifndef CZVOIP_CZRequestHeaderKey_h
#define CZVOIP_CZRequestHeaderKey_h

typedef enum{
    CZServiceNone=0,
    CZServiceRegister,   //注册(post请求)
    CZServiceQueryUserExist, //查询用户是否存在(post请求)
    CZServiceLogin,       //登录(post请求)
    CZServiceLoginOut,       //登出(post请求)
    CZServiceEditPassword,   //修改密码(put请求)
    CZServiceResetPwdApply, //根据短信重置密码(put请求)
    CZServicePhoneSMS,       //发送手机短信(post请求)
    CZServiceVerifyPhoneMsg, //验证手机短信(post请求)
    CZServiceMyMessage, //我的信息(读取或修改)(读取post请求,修改put请求)
    CZServiceAuthToken, //获取token(post请求)
    CZServiceGroupMessage, //获取组信息(post请求)
    CZServiceGroupList, //获取组列表(post请求)
    CZServiceAddGroup, //添加组(post请求)
    CZServiceDeleteGroup, //删除组(post请求)
    CZServiceUpdateGroup, //更新组(post请求)
    CZServiceQueryDetailGroup, //查询详情组(post请求)
    CZServiceVeritySMS, //短信验证(post请求)
    CZServiceAccountInfo, //取得帐户信息(post请求)
    CZServiceAccountBalbance, //取得帐户余额(post请求)
    CZServiceProductList, //产品列表(post请求)
    CZServiceProductDetail, //产品明细(post请求)
    CZServiceGoodsList, //商品列表(post请求)
    CZServiceGoodsDetail, //商品明细(post请求)
    CZServiceGoodsPresenting, //商品赠送(post请求)
    CZServiceGoodsOrder, //商品预定(post请求)
    CZServiceGoodsReturn, //商品退订(post请求)
    CZServiceGoodsDueList, //即将实效的商品列表(post请求)
    CZServiceFriendsList, //好友列表(post请求)
    CZServiceFriendsMessage, //好友信息(post请求)
    CZServiceAddFriends, //添加好友(post请求)
    CZServiceContactCallLogs, //通话记录(post请求)
    CZServicePassClientSync, //从云之讯同步client信息(post请求)
    CZServicePassClientDetail, //取得client详情信息(post请求)
    CZServiceApplyPassClient, //申请client(post请求)
    CZServiceMessageList, //获取消息列表(post请求)
    CZServiceMessageDetail, //获取消息详情(post请求)
    CZServiceSecretaryContact,//小秘书电话(post请求)
    CZServiceMessageReadCount,//消息访问次数(post请求)
    CZServiceQRCodeContent,//二维码内容(post请求)
    CZServiceAddressBookVersion,//通讯录版本(post请求)
    CZServiceAddressBookBackUp,//通讯录备份(post请求)
    CZServiceAddressBookRestore,//通讯录列表(post请求)
    CZServiceChargeCard,//充值卡充值(post请求)
    CZServiceUploadLogs,//上传日志(post请求)
    CZServiceLogsList,//日志列表(post请求)
    CZServiceLogsDetail,//日志详情(post请求)
    CZServicePhoneAttribute //号码归属地(post请求)

}CZServiceRequestType;

#endif
