//
//  ALHttpsWithSNIScene.swift
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/5/28.
//  Copyright © 2024 alibaba. All rights reserved.
//

import UIKit
import AlicloudHttpDNS
import Alamofire

class ALHttpsWithSNIScene: NSObject {

    class func beginQuery(originalUrl: String, completionHandler: (_ ip:String,_ text:String) -> Void) {

        //组装提示信息
        var tipsInfo: String = ""

        let httpdns = HttpDnsService.sharedInstance()

        let url = NSURL(string: originalUrl)

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

        var sessionManager: Session = AF
        var requestUrl = originalUrl

        if validIp != nil {
            requestUrl = originalUrl.replacingOccurrences(of: url?.host ?? "", with: validIp!)

            let configuration = URLSessionConfiguration.af.default
            configuration.protocolClasses = [HttpDnsNSURLProtocolImpl.classForCoder()]
            sessionManager = Session(configuration: configuration)

            print("Get IP(\(validIp!) for host(\(url?.host ?? "") from HTTPDNS Successfully!")
            tipsInfo = "Get IP(\(validIp!) for host(\(url?.host ?? "") from HTTPDNS Successfully!"
        } else {
            print("Get IP for host(%@) from HTTPDNS failed!", url?.host ?? "")
            tipsInfo = "Get IP for host(\(url?.host ?? "") from HTTPDNS failed!"
        }

        var header = HTTPHeaders()
        header.add(name: "host", value: url?.host ?? "")
        sessionManager.request(requestUrl, method: .get, headers: header).response { response in
            print("request：\(String(describing: response.request))")
            print("请求结果：\(String(describing: response))")
        }

    }
}
