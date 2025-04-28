import SwiftUI

struct BasicView: View {
    @State private var displayedVersion: String = "SDK版本"
    @State private var displayedLoggerLevel: String = "SDK日志级别"
    
    @State private var userNick1: String = ""
    @State private var userId1: String = ""

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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

