## alicloud-ios-demo
本工程给出了[阿里云移动服务](http://ams.console.aliyun.com/)相关产品的使用DEMO，欢迎参考与使用。
注：demo中的账号信息配置只为方便demo例程的运行，真实产品中我们建议您使用安全黑匣子或其他方式保障密钥的安全性。

### oss_ios_demo
oss_ios_demo给出了[对象存储OSS](https://www.aliyun.com/product/oss) iOS SDK的使用示例。
运行demo前请在`AliyunOSSDemo.m`文件中填入您的账号信息（仅用于测试，其他鉴权模式参考demo中的credential实现）：

```
NSString * const AccessKey = @"******";
NSString * const SecretKey = @"******";
```

### man_ios_demo
man_ios_demo给出了[数据分析服务（Mobile Analytics）](https://www.aliyun.com/product/man) iOS SDK的使用示例。
运行demo前请在`AppDelegate.m`文件中填入您的账号信息：

```
NSString * testAppKey = @"******";
NSString * testAppSecret = @"******";
```

### mac_ios_demo
mac_ios_demo给出了[移动加速服务（Mobile Accelerator）](https://help.aliyun.com/document_detail/cdn/getting-started/mas/overview.html?spm=5176.product8314936_cdn.6.107.uMNMvV) iOS SDK的使用示例。

### httpdns_ios_demo
httpdns_ios_demo给出了[HTTPDNS](https://www.aliyun.com/product/httpdns) iOS SDK的使用示例。

### httpdns_api_demo
httpdns_api_demo给出了[HTTPDNS](https://www.aliyun.com/product/httpdns) API的使用示例。

### mpush_ios_demo
mpush_ios_demo给出了[移动推送服务（Mobile Push）](https://www.aliyun.com/product/cps) iOS SDK的使用示例。

运行demo前请在`AppDelegate.m`文件中填入您的账号信息：

```
static NSString *const testAppKey = @"******";
static NSString *const testAppSecret = @"******";
```

### mpush_ios_swift_demo
mpush_ios_swift_demo[移动推送服务（Mobile Push）](https://www.aliyun.com/product/cps) iOS SDK的使用示例。

运行demo前请在`AppDelegate.swift`文件中填入您的账号信息：

```
let testAppKey = "******"
let testAppSecret = "******"
```

### feedback_ios_demo

运行demo前请在 `YWLoginController.m`文件中填入您的账号信息：

 ```Objective-C
static NSString * const kAppKey = @"******";
static NSString * const kAppSecret = @"******";
 ```


