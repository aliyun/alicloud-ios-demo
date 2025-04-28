import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    NavigationLink(
                        destination: BasicView(),
                        label: {
                            Text("基础功能")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(
                        destination: CrashView(),
                        label: {
                            Text("崩溃分析")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(
                        destination: PerfView(),
                        label: {
                            Text("性能分析")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
                    
                    NavigationLink(
                        destination: RemoteLogView(),
                        label: {
                            Text("远程日志")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    )
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
