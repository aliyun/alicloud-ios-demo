//
//  mpushTaxiLiveActivity.swift
//  mpushExtensionExtension
//
//  Created by Miracle on 2025/3/31.
//  Copyright © 2025 alibaba. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct mpushTaxiAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // 行程状态，"1"-接单中, "2"-前往中, "3"-行程中, "4"-已完成
        var status: String?
        // 剩余距离（单位：米）
        var distance: String?
        // 预计到达时间（单位：分钟）
        var eta: String?
        // 提示语
        var prompt: String?
    }

    // 打车软件名称
    var appName: String
    // 打车软件logo
    var appLogo: String
}


@available(iOS 16.1, *)
struct mpushTaxiLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: mpushTaxiAttributes.self) { context in
            // Lock screen/banner UI goes here
            TaxiLockStatusView(attributes: context.attributes, state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    TaxiExpandedView(attributes: context.attributes, state: context.state)
                }
            } compactLeading: {
                // 左侧显示打车软件的logo和名称
                HStack {
                    let imageName = context.attributes.appLogo
                    // 尝试从Assets中加载该名称的图片
                    if UIImage(named: imageName) != nil {
                        // 本地Assets中存在该图片
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:36, height: 36)
                            .cornerRadius(18)
                    } else {
                        // 本地Assets中不存在该图片，使用默认shop图片
                        Image("car")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 36, height:36)
                            .cornerRadius(18)
                    }
                    Text(context.attributes.appName).font(.system(size: 12)).lineLimit(1)
                }
            } compactTrailing: {
                // 右侧显示对应状态
                Text(statusTitle(state: context.state)).font(.system(size: 12)).lineLimit(1)
            } minimal: {
                // 显示对应状态
                Text(statusTitle(state: context.state)).font(.system(size: 12)).lineLimit(1)
            }
            .widgetURL(URL(string: "pocdemo://dynamicisland"))
            .keylineTint(Color.red)
        }
    }

    func statusTitle(state: mpushTaxiAttributes.ContentState) -> String {
        switch state.status {
        case "1": 
            return "接单中"
        case "2":
            return "前往中"
        case "3":
            return "行程中"
        case "4":
            return "已完成"
        default:
            return "接单中"
        }
    }
}

@available(iOS 16.1, *)
struct TaxiLockStatusView: View {
    let attributes: mpushTaxiAttributes
    let state: mpushTaxiAttributes.ContentState

    var body: some View {
        HStack(spacing: 12) {
            // 左侧显示打车软件图标与名称（所有状态都显示）
            VStack(alignment: .center) {
                let imageName = attributes.appLogo
                // 尝试从Assets中加载该名称的图片
                if UIImage(named: imageName) != nil {
                    // 本地Assets中存在该图片
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:36, height: 36)
                        .cornerRadius(18)
                } else {
                    // 本地Assets中不存在该图片，使用默认car图片
                    Image("car")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 36, height:36)
                        .cornerRadius(18)
                }
                Text(attributes.appName).font(.system(size: 12)).lineLimit(1)
            }.frame(width:60)

            // 中间和右侧内容，根据状态显示不同内容
            VStack(alignment: .leading, spacing: 4) {
                switch state.status {
                case "1":
                    // 已接单
                    Text("司机已接单").font(.system(size: 16, weight: .medium))
                    if !(state.prompt?.isEmpty ?? true) {
                        Text(state.prompt!).font(.system(size: 13)).foregroundColor(.secondary)
                    }
                case "2":
                    // 前往中
                    if !(state.eta?.isEmpty ?? true) {
                        Text("预计\(state.eta!)分钟到达").font(.system(size: 16, weight: .medium))
                    }
                    if !(state.distance?.isEmpty ?? true) {
                        Text("距您\(state.distance!)米").font(.system(size: 13)).foregroundColor(.secondary)
                    }
                case "3":
                    // 行程中
                    Text("行程进行中").font(.system(size: 16, weight: .medium))
                    if let distanceString = state.distance, !distanceString.isEmpty {
                        if let distanceValue = Double(distanceString) {
                            let km = String(format: "%.1f", distanceValue / 1000.0)
                            Text("剩余\(km)公里").font(.system(size: 13)).foregroundColor(.secondary)
                        } else {
                            Text("未知").font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    }
                case "4":
                    //已送达
                    Text("行程已完成").font(.system(size: 16, weight: .medium))
                    if !(state.prompt?.isEmpty ?? true) {
                        Text(state.prompt!).font(.system(size: 13)).foregroundColor(.secondary)
                    }
                default:
                    Text("行程状态未知").font(.system(size: 16, weight: .medium))
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

// 扩展模式视图
@available(iOS 16.1, *)
struct TaxiExpandedView: View {
    let attributes: mpushTaxiAttributes
    let state: mpushTaxiAttributes.ContentState

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 12) {
                // 左侧显示打车软件图标与名称（所有状态都显示）
                VStack(alignment: .center) {
                    let imageName = attributes.appLogo
                    // 尝试从Assets中加载该名称的图片
                    if UIImage(named: imageName) != nil {
                        // 本地Assets中存在该图片
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:36, height: 36)
                            .cornerRadius(18)
                    } else {
                        // 本地Assets中不存在该图片，使用默认car图片
                        Image("car")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 36, height:36)
                            .cornerRadius(18)
                    }
                    Text(attributes.appName).font(.system(size: 12)).lineLimit(1)
                }.frame(width:60)

                // 中间和右侧内容，根据状态显示不同内容
                VStack(alignment: .leading, spacing: 4) {
                    switch state.status {
                    case "1":
                        // 已接单
                        Text("司机已接单").font(.system(size: 16, weight: .medium))
                        if !(state.prompt?.isEmpty ?? true) {
                            Text(state.prompt!).font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    case "2":
                        // 前往中
                        if !(state.eta?.isEmpty ?? true) {
                            Text("预计\(state.eta!)分钟到达").font(.system(size: 16, weight: .medium))
                        }
                        if !(state.distance?.isEmpty ?? true) {
                            Text("距您\(state.distance!)米").font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    case "3":
                        // 行程中
                        Text("行程进行中").font(.system(size: 16, weight: .medium))
                        if let distanceString = state.distance, !distanceString.isEmpty {
                            if let distanceValue = Double(distanceString) {
                                let km = String(format: "%.1f", distanceValue / 1000.0)
                                Text("剩余\(km)公里").font(.system(size: 13)).foregroundColor(.secondary)
                            } else {
                                Text("未知").font(.system(size: 13)).foregroundColor(.secondary)
                            }
                        }
                    case "4":
                        //已送达
                        Text("行程已完成").font(.system(size: 16, weight: .medium))
                        if !(state.prompt?.isEmpty ?? true) {
                            Text(state.prompt!).font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    default:
                        Text("行程状态未知").font(.system(size: 16, weight: .medium))
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer().frame(height: 8)
            //打开应用按钮
            Button(action: {}) {
                HStack {
                    Image("openDemo").resizable().aspectRatio(contentMode: .fit).frame(width: 36, height: 20)
                    Text("Open the Demo App")
                }.frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
            }.frame(width: 300, height: 60)
        }
    }
}
