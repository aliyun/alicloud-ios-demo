# 阿里云推送App demo ios版 Quick Start

## 0x00 前言
能看到该文档，说明您已经至少建立了一个App，准备开始体验阿里云推送的便捷服务，在将SDK应用于您的App之前，建议您先使用该App Demo简单的熟悉一下SDK的使用方法和效果。根据下面的步骤进行操作，您最后可以制作出一个可以运行的App Demo，Let's go

## 0x01 需要准备的材料
- OneSDK压缩包
- 安全的appKey与appSecret
- App Demo源码
- Xcode

## 0x02 附件SDK Framework和bundle
使用Xcode打开本Demo源码包中的`mpush_ios_demo.xcodeproj`文件，或者可以在`Finder`中双击该文件，即可在Xcode中打开工程。打开后的效果如下：

![](http://public.cdn.zhilong.me/aliyun_0x01打开app.png)

这时候，工程中是没有sdk和安全加固图片的，我们打开刚刚在创建应用的时候，下载的`OneSDK`压缩包：

![](http://public.cdn.zhilong.me/aliyun_onesdk压缩包中内容.png)

如果您下载的sdk包中文件不全或者文件名与截图中不符，请重新登陆[移动开发平台](http://mobile.console.aliyun.com/)应用页面下载。

===
下面开始导入SDK：

### 1. 导入Bundle ：
在Xcode中工程信息配置页面，点击`Build Phases`选项卡:

![](http://public.cdn.zhilong.me/aliyun_选择buildphres.png)

然后点击展开`Copy Bundle Resources`选项：点击下方的加号添加Bundle，在弹出的页面中，点击`Add Other...`按钮，在弹出的文件选择器中进入刚刚下载的SDK目录，选中`ALBB.bundle` ，请勿修改文件名，然后点击`open`，在新弹出的页面中选择`Copy items if needed`后点击`Finish`:

![](http://public.cdn.zhilong.me/aliyun_屏幕快照 2015-04-13 上午11.11.13.png)

至此完成了`bundle`的导入。


### 2. 导入SDK Framework：
在Xcode中工程信息配置页面中，点击`General`选项卡：滑动页面，展开最下方的`Linked Frameworks and Libraries`选项卡，点击左下角的加号，在打开的文件选择器中选择OneSDK目录中除了`ALBB.bundle`以外所有的`*.framework`文件。

## 0x03 编译配置
至此，SDK的配置就结束了，如果编译期间出现『link -o error』之类的错误，请确认下Xcode中工程信息页面中`Build settings`选项卡中的`Linking`配置项中是否有`Other Linker Flags`，如果没有请添加该项，内容为`-ObjC`


### 0x04 替换appKey与appSecret

1. 打开列表页面-->应用证书-->appKey, appSecret,填入下面的初始化配置。

>附图示获取appKey, appSecret
![appkey](http://aliyun-cps-demo.oss-cn-hangzhou.aliyuncs.com/%E5%BA%94%E7%94%A8%E8%AF%81%E4%B9%A6.png
)

2. 替换默认的配置

```
    [[ALBBSDK sharedInstance] setALBBSDKEnvironment:ALBBSDKEnvironmentRelease];
    [[ALBBSDK sharedInstance] asyncInit:@"********" appSecret:@"*********" :^{
        NSLog(@"init one sdk success %@", [CloudPushSDK getDeviceId]);
    }failedCallback:^(NSError *error){
        NSLog(@"error is %@", error);
    }];
```
