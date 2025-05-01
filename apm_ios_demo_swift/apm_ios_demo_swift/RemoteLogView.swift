import SwiftUI

struct RemoteLogView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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

