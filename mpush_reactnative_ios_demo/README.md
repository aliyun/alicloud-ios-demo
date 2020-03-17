## MPush ReactNative Demo
本工程是在 ReactNative 环境下接入阿里云移动推送 iOS SDK 的 demo 工程,具体的集成方式可以参考:[阿里云移动推送+ReactNative最佳实践](https://help.aliyun.com/document_detail/53574.html?spm=5176.product30047.6.654.J2kuze)

### 1. 使用方法
- 在工程目录下运行 "npm install" 指令, 安装依赖模块
- 依赖模块安装完成后运行  "react-native run-ios" 启动工程

### 如果编译报错 failed with exit code 2
- 改变 react native 监听端口的方法
- a.   在终端进入项目文件夹运行 :  lsof -i :8889
- a. 1在终端进入项目文件夹运行：react-native start --port 8889；
- b.   Xcode 里 search 所有的 8081 将它们替换为 8889 
- c.   Xcode TARDGETS --> React/React-tvOS --> build Phases --> Start Packager 里找到 替换掉 8081，操作完运行就正常了

### 需要 替换 项目中的 AliyunEmasServices-Info.plist 
