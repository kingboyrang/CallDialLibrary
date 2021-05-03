//
//  GlobalPublicDefine.h
//  SmartHall
//
//  Created by kingboyrang on 2020/8/15.
//  Copyright © 2020 kingboyrang. All rights reserved.
//

#ifndef GlobalPublicDefine_h
#define GlobalPublicDefine_h

//获取iOS版本号
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue]
//获取window
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window]

//获取屏幕宽度
#define kScreenWidth             [[UIScreen mainScreen] bounds].size.width
//获取屏幕高度
#define kScreenHeight            [[UIScreen mainScreen] bounds].size.height


//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
 
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为X系列
//判断是否为iPhone X系列
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 状态栏高度
#define kStatusBarHeight         (IPHONE_X ? 44.f : 20.f)
// 顶部导航栏高度
#define kNavigationBarHeight     44.f
#define kNavigationBarRealHeight (kNavigationBarHeight + kStatusBarHeight)

// 顶部安全距离
#define kSafeAreaTopHeight      (IPHONE_X ? 88.f : 64.f)
// 底部安全距离
#define kSafeAreaBottomHeight   (IPHONE_X ? 34.f : 0.f)
// Tabbar高度
#define kTabbarHeight           49.f
#define kTabbarRealHeight       (kTabbarHeight + kSafeAreaBottomHeight)

// 去除上下导航栏剩余中间视图高度
#define ContentHeight           (kScreenHeight - kSafeAreaTopHeight - kSafeAreaBottomHeight - kTabbarHeight)


//获取temp
#define kPathTemp NSTemporaryDirectory()
 
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
 
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
 
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
 
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
 
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  //十六进制颜色



#endif /* GlobalPublicDefine_h */
