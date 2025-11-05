//
//  AlamofireHttpsWithSNIScenario.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/6/3.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit
import Alamofire
import AlicloudHTTPDNS

@objcMembers class AlamofireHttpsWithSNIScenario: NSObject {

    static let sharedSession: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [HttpDnsNSURLProtocolImpl.classForCoder()]
        return Session(configuration: configuration)
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
        let result = httpDnsService.resolveHostSyncNonBlocking(host, by: .auto)

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
