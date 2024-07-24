//
//  AlamofireHttpsScenario.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/3.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit
import Alamofire
import AlicloudHttpDNS

@objcMembers class AlamofireHttpsScenario: NSObject {

    static let sharedSession: Session = {
        return Session(delegate: CustomerSessionDelegate())
    }()

    class func httpDnsQueryWithURL(originalUrl: String, completionHandler: @escaping (_ message: String) -> Void) {
        // 组装提示信息
        var tipsMessage: String = ""

        guard let url = NSURL(string: originalUrl), let originalHost = url.host else {
            print("Error: invalid url: \(originalUrl)")
            return;
        }

        let resolvedIpAddress = resolveAvailableIp(host: originalHost)

        var requestUrl = originalUrl
        if resolvedIpAddress != nil {
            requestUrl = requestUrl.replacingOccurrences(of: originalHost, with: resolvedIpAddress!)

            let log = "Resolve host(\(originalHost)) by HTTPDNS successfully, result ip: \(resolvedIpAddress!)"
            print(log)
            tipsMessage = log
        } else {
            let log = "Resolve host(\(originalHost) by HTTPDNS failed, keep original url to request"
            print(log)
            tipsMessage = log
        }

        // 发送网络请求
        sendRequestWithURL(requestUrl: requestUrl, host: originalHost) { message in
            tipsMessage = tipsMessage + "\n\n" + message
            completionHandler(tipsMessage)
        }
    }

    class func sendRequestWithURL(requestUrl: String, host: String, completionHandler: @escaping (_ message: String) -> Void) {
        // 因为域名里的host已经被替换成了ip，因此这里需要主动设置host头，确保后端服务识别正确
        var header = HTTPHeaders()
        header.add(name: "host", value: host)
        sharedSession.request(requestUrl, method: .get, encoding: URLEncoding.default, headers: header).validate().response { response in
            var responseStr = ""
            
            switch response.result {
            case .success(let data):
                if let data = data, !data.isEmpty {
                    let dataStr = String(data: data, encoding: .utf8) ?? ""
                    responseStr = "HTTP Response: \(dataStr)"
                } else {
                    responseStr = "HTTP Response: [Empty Data]"
                }
            case .failure(let error):
                responseStr = "HTTP request failed with error: \(error.localizedDescription)"
            }
            
            completionHandler(responseStr)
        }
    }

    class func resolveAvailableIp(host: String) -> String? {
        let httpDnsService = HttpDnsService.sharedInstance()
        let result = httpDnsService?.resolveHostSyncNonBlocking(host, by: .both)

        print("resolve host result: \(String(describing: result))")
        if result == nil {
            return nil
        }

        if result!.hasIpv4Address() {
            return result?.firstIpv4Address()
        } else if result!.hasIpv6Address() {
            return "[\(result!.firstIpv6Address())]"
        }
        return nil
    }
}

class CustomerSessionDelegate: SessionDelegate {

    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        let request = task.currentRequest
        let host = request?.value(forHTTPHeaderField: "host") ?? ""

        // 获取原始域名信息
        if !host.isEmpty  {
            // 使用Header中的Host
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if evaluate(serverTrust: challenge.protectionSpace.serverTrust, host: host) {
                    disposition = .useCredential
                    credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                } else {
                    disposition = .performDefaultHandling
                }
            } else {
                disposition = .performDefaultHandling
            }
        }
        completionHandler(disposition,credential)
    }

    func evaluate(serverTrust: SecTrust? , host: String? ) -> Bool {
        if serverTrust == nil {
            return false
        }

        // 创建证书校验策略
        var policies = [SecPolicy]()
        if host != nil {
            policies.append(SecPolicyCreateSSL(true, host! as CFString))
        } else {
            policies.append(SecPolicyCreateBasicX509())
        }

        // 绑定校验策略到服务端的证书上
        SecTrustSetPolicies(serverTrust!, policies as CFTypeRef)

        // 评估当前serverTrust是否可信任
        var result: SecTrustResultType = .invalid
        if SecTrustEvaluate(serverTrust!, &result) == errSecSuccess {
            // 官方建议在result = .unspecified 或 .proceed的情况下serverTrust可以被验证通过
            // 详情请参考Apple官方文档
            return result == .unspecified || result == .proceed
        } else {
            // 处理失败的情况
            return false
        }
    }
}
