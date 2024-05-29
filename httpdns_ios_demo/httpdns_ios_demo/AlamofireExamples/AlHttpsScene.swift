//
//  AlHttpsScene.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/27.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit
import Alamofire
import AlicloudHttpDNS

var host: String = ""

class AlHttpsScene: NSObject {

    func beginQuery(originalUrl: String, completionHandler: (_ ip:String,_ text:String) -> Void) {

        //组装提示信息
        var tipsInfo: String = ""

        let httpdns = HttpDnsService.sharedInstance()

        let url = NSURL(string: originalUrl)
        host = url?.host ?? ""

        let result = httpdns?.resolveHostSyncNonBlocking(url?.host, by: .both)
        print("resolve result: %@", result as Any)
        var validIp: String?

        if result != nil {
            if result!.hasIpv4Address() {
                //使用ip
                validIp = result?.firstIpv4Address()

                //使用ip列表
//                let ips = result?.ips
//                validIp = ips?.first
            } else if result!.hasIpv6Address() {
                //使用ip
                validIp = result?.firstIpv6Address()

                //使用ip列表
//                let ips = result?.ipv6s
//                validIp = ips?.first
            } else {
                //无有效ip
            }
        }

//        let trustPolicy = CompositeTrustEvaluator(evaluators: [CustomServerTrustEvaluating()])
//        let trustManager = ServerTrustManager(allHostsMustBeEvaluated: true, evaluators: [host:trustPolicy])

        var sessionManager = AF
        var requestUrl = originalUrl
        if validIp != nil {
            requestUrl = originalUrl.replacingOccurrences(of: url?.host ?? "", with: validIp!)
//            let serverTrustManager = ServerTrustManager(allHostsMustBeEvaluated: true, evaluators: [host:DisabledTrustEvaluator()])
//            sessionManager = Session(delegate: CustomSessionDelegate())
            sessionManager = Session(configuration: URLSessionConfiguration.af.default,serverTrustManager: CustomSeverTrustManager(allHostsMustBeEvaluated: true, evaluators: [:]))

            print("Get IP(\(validIp!) for host(\(url?.host ?? "") from HTTPDNS Successfully!")
            tipsInfo = "Get IP(\(validIp!) for host(\(url?.host ?? "") from HTTPDNS Successfully!"
        } else {
            print("Get IP for host(url?.host) from HTTPDNS failed!")
            tipsInfo = "Get IP for host(\(url?.host ?? "") from HTTPDNS failed!"
        }

        var header = HTTPHeaders()
        header.add(name: "host", value: url?.host ?? "")

//        AF.delegate
        sessionManager.request(requestUrl, method: .get, encoding: URLEncoding.default).response { response in
            print("request：\(String(describing: response.request))")
            print("请求结果：\(response.result)")
        }



    }

}


class CustomSessionDelegate: SessionDelegate {

    func attemptServerTrustAuthentication(with challenge: URLAuthenticationChallenge) -> (disposition: URLSession.AuthChallengeDisposition, credential: URLCredential?, error: AFError?) {

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

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

        return (disposition,credential,nil)
    }

//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        
//        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//        var credential: URLCredential?
//
////        let request = task.originalRequest
//        // 获取原始域名信息
//        if !host.isEmpty  {
//            // 使用Header中的Host
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                if evaluate(serverTrust: challenge.protectionSpace.serverTrust, host: host) {
//                    disposition = .useCredential
//                    credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                } else {
//                    disposition = .performDefaultHandling
//                }
//            } else {
//                disposition = .performDefaultHandling
//            }
//        }
//
//        completionHandler(disposition,credential)
//        
//    }

//    @objc override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//        var credential: URLCredential?
//
////        let request = task.originalRequest
//        // 获取原始域名信息
//        if !host.isEmpty  {
//            // 使用Header中的Host
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                if evaluate(serverTrust: challenge.protectionSpace.serverTrust, host: host) {
//                    disposition = .useCredential
//                    credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//                } else {
//                    disposition = .performDefaultHandling
//                }
//            } else {
//                disposition = .performDefaultHandling
//            }
//        }
//
//        completionHandler(disposition,credential)
//        
//    }

//    func evaluate(serverTrust: SecTrust? , host: String? ) -> Bool {
//        
//        if serverTrust == nil {
//            return false
//        }
//        
//        /*
//         * 创建证书校验策略
//         */
//        var policies = [SecPolicy]()
//        if host != nil {
//            policies.append(SecPolicyCreateSSL(true, host! as CFString))
//        } else {
//            policies.append(SecPolicyCreateBasicX509())
//        }
//        
//        /*
//         * 绑定校验策略到服务端的证书上
//         */
//        SecTrustSetPolicies(serverTrust!, policies as CFTypeRef)
//        
//        // 评估当前serverTrust是否可信任
//        var result: SecTrustResultType = .invalid
//        if SecTrustEvaluate(serverTrust!, &result) == errSecSuccess {
//            // 官方建议在result = .unspecified 或 .proceed的情况下serverTrust可以被验证通过
//            // 详情请参考Apple官方文档
//            return result == .unspecified || result == .proceed
//        } else {
//            // 处理失败的情况
//            return false
//        }
//        
//    }
}

extension CustomSessionDelegate {
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

//        let request = task.originalRequest
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

        /*
         * 创建证书校验策略
         */
        var policies = [SecPolicy]()
        if host != nil {
            policies.append(SecPolicyCreateSSL(true, host! as CFString))
        } else {
            policies.append(SecPolicyCreateBasicX509())
        }

        /*
         * 绑定校验策略到服务端的证书上
         */
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


class CustomSeverTrustManager: ServerTrustManager {

    func isIPv4(_ ipString: String?) -> Bool {
        guard let ipString = ipString else {
            return false
        }

        var addr = in_addr()
        var utf8String = ipString.cString(using: .utf8)
        let success = utf8String?.withUnsafeMutableBytes { ptr in
            inet_pton(AF_INET, ptr.baseAddress, &addr)
        }

        return success == 1
    }

    func isIPv6(_ ipString: String?) -> Bool {
        guard let ipString = ipString else {
            return false
        }

        var addr6 = in6_addr()
        var utf8String = ipString.cString(using: .utf8)
        let success = utf8String?.withUnsafeMutableBytes { ptr in
            inet_pton(AF_INET6, ptr.baseAddress, &addr6)
        }

        return success == 1
    }

    override func serverTrustEvaluator(forHost host: String) throws -> (any ServerTrustEvaluating)? {

        if isIPv4(host) || isIPv6(host) {
            return CustomServerTrustEvaluating()
        }

        return DefaultTrustEvaluator()
    }



}

class CustomServerTrustEvaluating: ServerTrustEvaluating {

    public func evaluate(_ trust: SecTrust, forHost host: String) throws {

        /*
         * 创建证书校验策略
         */
        var policies = [SecPolicy]()
        if !host.isEmpty {
            policies.append(SecPolicyCreateSSL(true, host as CFString))
        } else {
            policies.append(SecPolicyCreateBasicX509())
        }

        /*
         * 绑定校验策略到服务端的证书上
         */
        SecTrustSetPolicies(trust, policies as CFTypeRef)

        // 评估当前serverTrust是否可信任
        var result: SecTrustResultType = .invalid
        if SecTrustEvaluate(trust, &result) == errSecSuccess {
            // 官方建议在result = .unspecified 或 .proceed的情况下serverTrust可以被验证通过
            // 详情请参考Apple官方文档
            if result == .unspecified || result == .proceed {
                try trust.af.performValidation(forHost: "www.apple.com")
            } else {
                try trust.af.performDefaultValidation(forHost: host)
            }

        } else {
            try trust.af.performDefaultValidation(forHost: host)
        }
    }
}
