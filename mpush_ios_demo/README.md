# 阿里云移动推送Demo APP iOS版 Quick Start

## 0x00 前言
在将SDK应用于您的App之前，建议您先使用该Demo APP简单的熟悉一下SDK的使用方法和效果。根据下面的步骤进行操作，您最后可以制作出一个可以使用移动推送服务的Demo APP，Let's go！

## 0x01 快速体验

#### 创建APP

您首先需要登入移动推送控制台，创建一个APP实体以对应您准备使用的Demo APP。关于APP创建的指引文档可以参考：

>https://help.aliyun.com/document_detail/30054.html?spm=5176.doc30054.3.2.0xGnCV

创建完APP后，如果您需要使用iOS通知功能，您还需要配置您的iOS平台的相关信息，如下图所示：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush4.png)

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush5.png)

关于推送证书更多的细节参见`推送通知`章节。

#### 下载Demo工程

当您将移动服务工程git clone到本地，并通过Xcode加载后您可以看到如下目录：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush1.png)

其中mpush_ios_demo即为移动推送的Demo APP。

mpush_ios_demo已经完成了移动推送SDK的集成工作，但我们还是建议您仔细阅读移动推送的集成文档

>https://help.aliyun.com/document_detail/30072.html?spm=5176.doc30064.6.111.EelXR2

**当您在使用您自己的APP集成移动推送遇到问题时，您可以对比下demo APP的配置情况。**

#### 配置APP信息

为了使Demo APP能够正常运行，您还需要配置您的appkey/appsecret信息。您可以在移动推送控制台，您在第一步创建的APP中找到它们，如图所示：

![appkey](http://test-bucket-lingbo.oss-cn-hangzhou.aliyuncs.com/mpush2.png)

在下述初始化代码中用您的appkey/appsecret替换`******`字段占据的参数。

```
static NSString *const testAppKey = @"******";
static NSString *const testAppSecret = @"******";
// SDK初始化
[CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
    if (res.success) {
        NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
    } else {
        NSLog(@"Push SDK init failed, error: %@", res.error);
    }
}];
```

完成上述替换后，您的Demo APP就能够正常收发应用内消息了。

#### 推送通知

为了完成通知的推送，您还需要一些额外的工作，即iOS推送证书的配置。推送证书配置的指导文档请参考：

>https://help.aliyun.com/document_detail/30071.html?spm=5176.doc30072.6.110.MFxag9

> 注意: iOS不允许在模拟器环境下进行通知推送。
