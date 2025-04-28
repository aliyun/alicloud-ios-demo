import SwiftUI

struct CrashView: View {
    @State private var isLoading = false
    
    func triggerSwiftCrash() {
        let someNilString: String? = nil
        // 强制解包 nil，触发 crash
        let forcedValue: String = someNilString!
        print("Value: \(forcedValue)")
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
