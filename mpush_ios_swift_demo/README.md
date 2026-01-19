# 阿里云移动推送Demo APP iOS Swift 版

[![platform](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](https://mhub.console.aliyun.com/#/download)
[![pod](https://img.shields.io/badge/pod-support-brightgreen.svg)](https://github.com/aliyun/aliyun-specs)
[![language](https://img.shields.io/badge/language-Swift-orange.svg)](https://mhub.console.aliyun.com/#/download)
[![website](https://img.shields.io/badge/website-CloudPush-red.svg)](https://www.aliyun.com/product/cps)


<div align="center">
<img src="assets/push-logo.png">
</div>

> 阿里云移动推送（Alibaba Cloud Mobile Push）是基于大数据的移动智能推送服务，帮助App快速集成移动推送的功能，在实现高效、精确、实时的移动推送的同时，极大地降低了开发成本。让开发者最有效地与用户保持连接，从而提高用户活跃度、提高应用的留存率。

## 产品特性
- 高效稳定——与手机淘宝使用相同架构，基于阿里集团高可用通道。该通道日均消息发送量可达30亿，目前活跃使用的用户达1.8亿。
- 高到达率——Android 智能通道保活，多通道支持保证推送高到达率。
- 精确推送——基于阿里大数据处理技术，实现精确推送。
- 应用内消息推送——支持 Android 与 iOS 应用内私有通道，保证透传消息高速抵达。

## 使用方法

### 1. 创建APP

您首先需要登入移动推送控制台，创建一个APP实体以对应您准备使用的Demo APP。关于APP创建的指引文档可以参考：[创建App](https://help.aliyun.com/document_detail/30054.html?spm=5176.doc30054.3.2.0xGnCV)。

创建完APP后，如果您需要使用iOS通知功能，您还需要配置您的iOS平台的相关信息，如下图所示：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush4.png)

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush5.png)

关于推送证书更多的细节参见文档：[iOS推送证书配置](https://help.aliyun.com/document_detail/30071.html?spm=5176.product30047.6.624.SfbchI)。

### 2. 下载Demo工程

- 将本工程Clone到本地：

```
git clone git@github.com:aliyun/alicloud-ios-demo.git
```

- Xcode加载后您可以看到如下目录：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush1.png)

其中mpush_ios_swift_demo即为移动推送的Demo APP。

mpush_ios_swift_demo已经完成了移动推送SDK的集成工作，但我们还是建议您仔细阅读移动推送的集成文档：[移动推送 - iOS集成文档](https://help.aliyun.com/document_detail/30072.html?spm=5176.doc30064.6.111.EelXR2)

**当您在使用您自己的APP集成移动推送遇到问题时，您可以对比下demo APP的配置情况。**

### 3. 配置工程

- 修改签名证书，`mpush_ios_swift_demo`、`mpush_service_extension`和`mpush_content_extension`都要修改。

![](http://ams-test-junmo.oss-cn-hangzhou.aliyuncs.com/push_demo/Snip20170112_1.png)

- 修改应用`Bundle Identifier`，`mpush_ios_swift_demo`、`mpush_service_extension`和`mpush_content_extension`都要修改。

### 4. 配置APP信息

- 为了使Demo APP能够正常运行，您还需要配置您的appkey/appsecret信息。您可以在移动推送控制台，您在第一步创建的APP中找到它们，如图所示：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush2.png)

在下述初始化代码中用您的appkey/appsecret替换`******`字段占据的参数。

```swift
let testAppKey = "******"
let testAppSecret = "******"
// SDK初始化
CloudPushSDK.asyncInit(testAppKey, appSecret: testAppSecret) { (res) in
    if (res!.success) {
        print("Push SDK init success, deviceId: \(CloudPushSDK.getDeviceId()!)")
    } else {
        print("Push SDK init failed, error: \(res!.error!).")
    }
}
```

完成上述替换后，您的Demo APP就能够正常收发应用内消息和APNs通知了。

## 联系我们

-   官网：[移动推送](https://www.aliyun.com/product/cps)
-   钉钉技术支持：35248489（钉钉群号）
-   官方技术博客：[阿里云移动服务](https://yq.aliyun.com/teams/32)
