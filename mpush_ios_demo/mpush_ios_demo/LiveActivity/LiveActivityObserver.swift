//  LiveActivityObserver.swift
//  mpushExtension
//
//  Created by Miracle on 2025/3/27.
//  Copyright © 2025 alibaba. All rights reserved.
//

import UIKit
import ActivityKit

class TokenManager {
    static let shared = TokenManager()

    // 外卖模型的token
    var takeoutStartToken: String = ""
    var takeoutPushToken: String = ""

    // 打车模型的token
    var taxiStartToken: String = ""
    var taxiPushToken: String = ""


    // 私有初始化器，防止外部创建实例
    private init() {}
}

class LiveActivityObserver: NSObject {
    @objc func observeActivityTokenAndState() {
        takeoutObserver()
        taxiObserver()
    }
    
    /// 外卖模型监听
    func takeoutObserver() {
        Task {
            if #available(iOS 17.2, *) {
                for await tokenData in Activity<mpushTakeoutAttributes>.pushToStartTokenUpdates {
                    let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
                    if (TokenManager.shared.takeoutStartToken != mytoken) {
                        TokenManager.shared.takeoutStartToken = mytoken;
                        NSLog("Activity startToken=\(mytoken) ")
                        CloudPushSDK.registerLiveActivityStartToken(tokenData, forActivityAttributes: "mpushTakeoutAttributes") { res in
                            print("Activity register start token result: \(res.success)")
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }

        Task {
            if #available(iOS 16.2, *) {
                for await activity in Activity<mpushTakeoutAttributes>.activityUpdates {
                    print("===== Observing the activity: \(activity.id) \(activity.attributes) ==========")
                    MsgToolBox.showAlert("activity.id", content: activity.id)

                    Task {
                        for await tokenData in activity.pushTokenUpdates {
                            let token = tokenData.map { String(format: "%02x", $0) }.joined()
                            print("==== pushToken = \(token)")
                            if TokenManager.shared.takeoutPushToken != token {
                                TokenManager.shared.takeoutPushToken = token
                                print("Observer Activity pushToken: \(activity.id) token: \(token)")
                                CloudPushSDK.registerLiveActivityPushToken(tokenData, forActivityId: activity.id) { res in
                                    print("Activity register push token result: \(res.success)")
                                }
                            }
                        }
                    }

                    Task {
                        for await state in activity.activityStateUpdates {
                            print("Observer Activity state: \(activity.id) state: \(state)")
                            CloudPushSDK.syncLiveActivityState("\(state)", forActivityId: activity.id) { res in
                                print("Sync state result: \(res.success)")
                            }
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }

    func taxiObserver() {
        Task {
            if #available(iOS 17.2, *) {
                for await tokenData in Activity<mpushTaxitAttributes>.pushToStartTokenUpdates {
                    let mytoken = tokenData.map { String(format: "%02x", $0) }.joined()
                    if (TokenManager.shared.taxiStartToken != mytoken) {
                        TokenManager.shared.taxiStartToken = mytoken;
                        NSLog("Activity startToken=\(mytoken) ")
                        CloudPushSDK.registerLiveActivityStartToken(tokenData, forActivityAttributes: "mpushTaxitAttributes") { res in
                            print("Activity register start token result: \(res.success)")
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }

        Task {
            if #available(iOS 16.2, *) {
                for await activity in Activity<mpushTaxitAttributes>.activityUpdates {
                    print("===== Observing the activity: \(activity.id) \(activity.attributes) ==========")
                    MsgToolBox.showAlert("activity.id", content: activity.id)

                    Task {
                        for await tokenData in activity.pushTokenUpdates {
                            let token = tokenData.map { String(format: "%02x", $0) }.joined()
                            print("==== pushToken = \(token)")
                            if TokenManager.shared.taxiPushToken != token {
                                TokenManager.shared.taxiPushToken = token
                                print("Observer Activity pushToken: \(activity.id) token: \(token)")
                                CloudPushSDK.registerLiveActivityPushToken(tokenData, forActivityId: activity.id) { res in
                                    print("Activity register push token result: \(res.success)")
                                }
                            }
                        }
                    }

                    Task {
                        for await state in activity.activityStateUpdates {
                            print("Observer Activity state: \(activity.id) state: \(state)")
                            CloudPushSDK.syncLiveActivityState("\(state)", forActivityId: activity.id) { res in
                                print("Sync state result: \(res.success)")
                            }
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

