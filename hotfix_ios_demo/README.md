# 阿里云iOS热修复Demo

本Demo为阿里云iOS热修复Demo。

## 使用说明

### App创建配置

- 参考：[阿里云热修复 - 创建应用](https://help.aliyun.com/document_detail/53238.html?spm=5176.doc51434.6.545.2vaHXR)，创建阿里云App。
- 控制台使用说明参考：[阿里云热修复 - 管理后台使用说明](https://help.aliyun.com/document_detail/51434.html?spm=5176.doc53238.6.553.K9Qvqx)。

### Demo配置

- 执行`pod install`，从远程仓库拉取SDK。
- 替换`libs/`目录下的`AlicloudHotFix.framework`和`arp.framework`，SDK请联系工作人员提供。

- SDK初始化代码中，替换下列参数，参数从热修复控制台获取。

```objc
static NSString *const testAppId = <#Your AppId#>;
static NSString *const testAppSecret = <# Your AppSecret#>;
static NSString *const testAppRsaPrivateKey = <#Your Rsa Private Key#>;
```

### Demo功能说明

- 补丁加载测试：测试补丁加载是否生效。
- 拉取补丁：从服务端拉取补丁。
- 删除下载补丁：删除从服务端下载的存储在本地的补丁。
- 加载本地补丁文件：加载本地指定文件路径的补丁。
- 二维码扫描：扫描控制台二维码下载补丁做测试。

### 补丁上传

- 本Demo提供一个测试补丁，补丁文件为`patch`目录，可将`patch.zip`上传到热修复控制台。

### 测试

- 测试加载本Demo提供的补丁文件。
- 加载补丁前，点击`补丁加载测试`，打印以下Log并弹出提示框：

```
[TestClass] origin output.
```

- 加载补丁成功后，点击`补丁加载测试`，弹出提示框：

```
[TestClass] This is replaced output.
```
