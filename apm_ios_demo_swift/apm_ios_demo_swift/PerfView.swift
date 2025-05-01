import SwiftUI

struct PerfView: View {
    
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
