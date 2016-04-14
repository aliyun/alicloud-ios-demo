## alicloud-ios-demo
本工程给出了阿里云移动服务相关产品的使用DEMO，欢迎参考与使用。
注：demo中的账号信息配置只为方便demo例程的运行，真实产品中我们建议您使用安全黑匣子或其他方式保障密钥的安全性。

### oss_ios_demo
oss_ios_demo给出了OSS iOS SDK的使用示例。
运行demo前请在`AliyunOSSDemo.m`文件中填入您的账号信息（仅用于测试，其他鉴权模式参考demo中的credential实现）：

```
NSString * const AccessKey = @"**************";
NSString * const SecretKey = @"**************";
```

### man_ios_demo
man_ios_demo给出了数据分析服务（Mobile Analytics） iOS SDK的使用示例。
运行demo前请在`AppDelegate.m`文件中填入您的账号信息：

```
NSString * testAppKey = @"*********";
NSString * testAppSecret = @"**************";
```

### mac_ios_demo
mac_ios_demo给出了移动加速服务（Mobile Accelerator） iOS SDK的使用示例。

### httpdns_ios_demo
httpdns_ios_demo给出了HTTPDNS iOS SDK的使用示例。

### httpdns_api_demo
httpdns_api_demo给出了HTTPDNS API的使用示例。
