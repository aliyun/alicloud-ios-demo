//
//  AppDelegate.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2021/2/26.
//

#import "AppDelegate.h"
#import <AlicloudCloudCode/AliCloudCodeAdSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

static NSString *const CHANNELID = @"TEST_TENANT";
static NSString *const MEDIAID = @"566389535148903424";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     
     iOS14 IDFA 获取有所改变
     App Tracking Transparency（ATT）适用于请求用户授权，访问与应用相关的数据以跟踪用户或设备。
     https://developer.apple.com/documentation/apptrackingtransparency
     需要在Info.plist，添加 NSUserTrackingUsageDescription 字段和自定义文案描述。
     是否适配ATT需要用户自己考虑，建议客户申请IDFA权限
     SDK内部只会获取IDFA，不会主动申请获取权限
     */
    if (@available(iOS 14, *)) {
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        switch (status) {
            case ATTrackingManagerAuthorizationStatusDenied:
            {
                NSLog(@"用户拒绝IDFA获取");
            }
                break;
            case ATTrackingManagerAuthorizationStatusAuthorized:
            {
                NSLog(@"用户允许IDFA获取");
            }
                
                break;
            case ATTrackingManagerAuthorizationStatusNotDetermined:
            {
                NSLog(@"当前权限用户未做选择");
                //这里需要主动申请权限 需要提前在Info.plist，添加 NSUserTrackingUsageDescription 字段和自定义文案描述，用于系统弹窗说明
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                }];
            }
                break;
            default:
                break;
        }
    } else {
        // Fallback on earlier versions
        if ([ASIdentifierManager.sharedManager isAdvertisingTrackingEnabled]) {
            //获取idfa
            NSString *idfa = [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
        } else {
            NSLog(@"用户已限制IDFA获取");
        }
    }
    
    //开启内部日志功能
    [AliCloudCodeAdSDK setLogEnable:YES];
    //设置渠道号、媒体号
    [AliCloudCodeAdSDK setChannelID:CHANNELID mediaID:MEDIAID];
    //SDK启动设置
    [AliCloudCodeAdSDK sdkInit:^(BOOL isSuccess, NSError * _Nonnull error) {
        if (isSuccess) {
            //SDK 初始化成功
        } else {
            //SDK 初始化失败
            NSLog(@"失败原因：%@", error.description);
        }
    }];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
