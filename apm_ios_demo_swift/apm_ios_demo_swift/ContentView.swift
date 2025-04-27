import SwiftUI

struct ContentView: View {
    @State private var displayedVersion: String = "读取SDK版本"
    @State private var displayedLoggerLevel: String = "读取SDK日志级别"
    
    @State private var userNick1: String = ""
    @State private var userId1: String = ""
    @State private var remoteLog: String = ""
    
    @State private var isLoading = false

    func triggerSwiftCrash() {
        let someNilString: String? = nil
        // 强制解包 nil，触发 crash
        let forcedValue: String = someNilString!
        print("Value: \(forcedValue)")
    }
    
    func networkRequest() async {
        for i in 0..<10 {
            DispatchQueue.global(qos: .default).async {
                let urlStr = "https://www.taobao.com/"
                let request = NSMutableURLRequest(url: URL(string: urlStr)!)
                
                let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request as URLRequest) { data, response, error in
                    if let error = error {
                        let str = "触发:\(urlStr)，error:\(error.localizedDescription)"

                    } else {

                    }
                }
                task.resume()
            }
        }
        
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Button("触发OC崩溃测试") {
                        CrashHelper.triggerCrash()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("触发Swift崩溃测试") {
                        triggerSwiftCrash()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("触发C++崩溃测试") {
                        triggerCppCrash()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("触发卡顿") {
                        isLoading = true
                        Thread.sleep(forTimeInterval: 6)
                        isLoading = false
                    }
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(displayedVersion)
                    .padding()
                    .font(.title) // 设置字体大小
                    .foregroundColor(.black)
                    Button("读取SDK版本") {
                        self.displayedVersion = EAPMVersion()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    HStack {
                        TextField("请输入userNick", text: $userNick1)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // 添加边框样式
                            .padding(.horizontal)
                        Button("更新userNick") {
                            EAPMApm.apm()!.setUserNick(userNick: "\(userNick1)")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    HStack {
                        TextField("请输入userId", text: $userId1)
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // 添加边框样式
                            .padding(.horizontal)
                        Button("更新userId") {
                            EAPMApm.apm()!.setUserId(userId: "\(userId1)")
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button("触发自定义日志") {
                        let crashAnalysis = CrashAnalysis.crashAnalysis()
                        crashAnalysis.log("用户点击了自定义日志按钮")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("设置自定义维度") {
                        let crashAnalysis = CrashAnalysis.crashAnalysis()
                        crashAnalysis.setCustomValue("设置自定义维度", forKey: "维度类型")
                        crashAnalysis.setCustomKeysAndValues([
                            "设备型号": UIDevice.current.model,
                            "系统版本": UIDevice.current.systemVersion
                        ])
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("记录自定义异常") {
                        let crashAnalysis = CrashAnalysis.crashAnalysis()
                        let error = NSError(
                            domain: "customError",
                            code: 10001,
                            userInfo: [
                                "key": "value",
                            ]
                        )
                        crashAnalysis.record(error: error, userInfo: [
                            "key1": "value1",
                            "key2": "value2"
                        ])
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text(displayedLoggerLevel)
                    .padding()
                    .font(.title) // 设置字体大小
                    .foregroundColor(.black)
                    Button("读取SDK日志级别") {
                        self.displayedLoggerLevel = String("\(EAPMConfiguration.shared.loggerLevel())".dropFirst(15))
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("设置SDK日志级别Debug") {
                        EAPMSetLoggerLevelDebug()
                    }
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("设置SDK日志级别Error") {
                        EAPMSetLoggerLevelError()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("设置SDK日志级别Notice") {
                        EAPMSetLoggerLevelNotice()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("设置SDK日志级别Warning") {
                        EAPMSetLoggerLevelWarning()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("记录远程日志") {
                        let log = RemoteLogFactory.createLog(moduleName: "TestingModule")
                        log.error("error message")
                        log.warn("warn message")
                        log.debug("debug message")
                        log.info("info message")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Button("日志主动上报") {
                        RemoteLog.updateLogLevel(EAPMRemoteLogLevel.error)
                        RemoteLog.uploadTLog("日志主动上报111")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    NavigationLink(
                        destination: SecondView(),
                        label: {
                            Text("进入新页面")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    
                    Button("发送网络请求") {
                        Task {
                            await networkRequest()
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .simultaneousGesture(TapGesture().onEnded {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }, including: .all)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
