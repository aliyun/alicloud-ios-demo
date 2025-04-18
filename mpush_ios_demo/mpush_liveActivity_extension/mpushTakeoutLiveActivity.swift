//
//  mpushTakeoutLiveActivity.swift
//  mpush_liveActivity_extension
//
//  Created by Miracle on 2025/3/27.
//  Copyright © 2025 alibaba. All rights reserved.
//

import ActivityKit
import WidgetKit
import SwiftUI


struct mpushTakeoutAttributes: ActivityAttributes {
    // 内容状态定义动态参数
    public struct ContentState: Codable, Hashable {
        // 配送状态，"1" - 备货中, "2" - 待配送, "3" - 配送中, "4" - 已完成
        var status: String?
        // 配送距离（单位：米）
        var distance: String?
        // 配送剩余时间（单位：分钟）
        var progress: String?
        // 提示语
        var prompt: String?
    }

    // 静态参数 - 创建后不会变化
    // 商家名称
    var merchantName: String
    // 商家图片
    var merchantLogo: String
}

@available(iOS 16.1, *)
struct mpushTakeoutLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: mpushTakeoutAttributes.self) { context in
            // Lock screen/banner UI goes here
            TakeoutLockStatusView(attributes: context.attributes, state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    TakeoutExpandedView(attributes: context.attributes, state: context.state)
                }
            } compactLeading: {
                // 左侧显示商家图片和名称
                HStack {
                    let imageName = context.attributes.merchantLogo
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
                        Image("shop")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 36, height:36)
                            .cornerRadius(18)
                    }
                    Text(context.attributes.merchantName).font(.system(size: 12)).lineLimit(1)
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

    func statusTitle(state: mpushTakeoutAttributes.ContentState) -> String {
        switch state.status {
        case "1":
            return "备货中"
        case "2":
            return "待配送"
        case "3":
            return "配送中"
        case "4":
            return "已完成"
        default:
            return "状态未知"
        }
    }
}

@available(iOS 16.1, *)
struct TakeoutLockStatusView: View {
    let attributes: mpushTakeoutAttributes
    let state: mpushTakeoutAttributes.ContentState

    var body: some View {
        HStack(spacing: 12) {
            // 左侧商家信息（所有状态都显示）
            VStack(alignment: .center) {
                let imageName = attributes.merchantLogo
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
                    Image("shop")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 36, height:36)
                        .cornerRadius(18)
                }
                Text(attributes.merchantName).font(.system(size: 12)).lineLimit(1)
            }.frame(width:60)

            // 中间和右侧内容，根据状态显示不同内容
            VStack(alignment: .leading, spacing: 4) {
                switch state.status {
                case "1":
                    // 备货中
                    Text("商家备货中").font(.system(size: 16, weight: .medium))
                    if let promptText = state.prompt, !promptText.isEmpty {
                        Text(promptText).font(.system(size: 13)).foregroundColor(.secondary)
                    }
                case "2":
                    // 待配送
                    Text("已备货，等待配送").font(.system(size: 16, weight: .medium))
                case "3":
                    // 配送中
                    Text("骑手配送中").font(.system(size: 16, weight: .medium))
                    HStack(spacing: 0) {
                        Text("距您\(checkIfNumeric(input: state.distance))米").font(.system(size:13)).foregroundColor(.secondary)

                        Text("，预计\(checkIfNumeric(input: state.progress))分钟送达").font(.system(size: 13)).foregroundColor(.secondary)
                    }
                case "4":
                    //已送达
                    Text("商品已送达").font(.system(size: 16, weight: .medium))
                    if let promptText = state.prompt, !promptText.isEmpty {
                        Text(promptText).font(.system(size: 13)).foregroundColor(.secondary)
                    }
                default:
                    Text("配送状态未知").font(.system(size: 16, weight: .medium))
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

// 扩展模式视图
@available(iOS 16.1, *)
struct TakeoutExpandedView: View {
    let attributes: mpushTakeoutAttributes
    let state: mpushTakeoutAttributes.ContentState

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center, spacing: 12) {
                // 左侧商家信息（所有状态都显示）
                VStack(alignment: .center) {
                    let imageName = attributes.merchantLogo
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
                        Image("shop")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 36, height:36)
                            .cornerRadius(18)
                    }
                    Text(attributes.merchantName).font(.system(size: 12)).lineLimit(1)
                }.frame(width:60)

                // 中间和右侧内容，根据状态显示不同内容
                VStack(alignment: .leading, spacing: 4) {
                    switch state.status {
                    case "1":
                        // 备货中
                        Text("商家备货中").font(.system(size: 16, weight: .medium))
                        if let promptText = state.prompt, !promptText.isEmpty {
                            Text(promptText).font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    case "2":
                        // 待配送
                        Text("已备货，等待配送").font(.system(size: 16, weight: .medium))
                    case "3":
                        // 配送中
                        Text("骑手配送中").font(.system(size: 16, weight: .medium))
                        HStack(spacing: 0) {
                            Text("距您\(checkIfNumeric(input: state.distance))米").font(.system(size:13)).foregroundColor(.secondary)

                            Text("，预计\(checkIfNumeric(input: state.progress))分钟送达").font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    case "4":
                        //已送达
                        Text("商品已送达").font(.system(size: 16, weight: .medium))
                        if let promptText = state.prompt, !promptText.isEmpty {
                            Text(promptText).font(.system(size: 13)).foregroundColor(.secondary)
                        }
                    default:
                        Text("配送状态未知").font(.system(size: 16, weight: .medium))
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

fileprivate func checkIfNumeric(input: String?) -> String {
    // 检查是否为nil或空字符串
    guard let input = input, !input.isEmpty else {
        return "未知"
    }

    // 创建匹配数字(包括小数和负数)的正则表达式
    let numericRegex = #"^-?([0-9]+(\.[0-9]*)?|\.[0-9]+)$"#

    // 检查字符串是否匹配正则表达式
    if let _ = input.range(of: numericRegex, options: .regularExpression) {
        return input
    } else {
        return "未知"}
}
