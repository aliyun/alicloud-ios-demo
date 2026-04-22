import SwiftUI
import AlicloudApmRemoteLog

enum RemoteLogLevel: String, Equatable {
    case error
    case warn
    case debug
    case info
}

struct RemoteLogEntry: Equatable {
    let level: RemoteLogLevel
    let message: String
}

@MainActor
final class RemoteLogFeatureViewModel: ObservableObject {
    private let overlayCoordinator: OverlayCoordinator
    private let writeRemoteLogs: (_ moduleName: String, _ entries: [RemoteLogEntry]) -> Void
    private let uploadRemoteLogs: (_ comment: String) -> Void

    init(
        overlayCoordinator: OverlayCoordinator,
        writeRemoteLogs: @escaping (_ moduleName: String, _ entries: [RemoteLogEntry]) -> Void = { moduleName, entries in
            let logger = RemoteLogFactory.createLog(moduleName: moduleName)
            for entry in entries {
                switch entry.level {
                case .error:
                    logger.error(entry.message)
                case .warn:
                    logger.warn(entry.message)
                case .debug:
                    logger.debug(entry.message)
                case .info:
                    logger.info(entry.message)
                }
            }
        },
        uploadRemoteLogs: @escaping (_ comment: String) -> Void = { comment in
            RemoteLog.uploadTLog(comment)
        }
    ) {
        self.overlayCoordinator = overlayCoordinator
        self.writeRemoteLogs = writeRemoteLogs
        self.uploadRemoteLogs = uploadRemoteLogs
    }

    func captureLogs() {
        writeRemoteLogs("YourModuleName", [
            RemoteLogEntry(level: .error, message: "error message"),
            RemoteLogEntry(level: .warn, message: "warn message"),
            RemoteLogEntry(level: .debug, message: "debug message"),
            RemoteLogEntry(level: .info, message: "info message"),
        ])

        overlayCoordinator.presentGuide(
            title: "日志回捞",
            statusText: "打日志成功",
            guideItems: [
                "在 EMAS 控制台「远程日志」模块，根据当前设备，创建回捞任务",
                "Demo App 切换前后台上报日志",
                "等待1-2分钟，在控制台查看日志",
            ]
        )
    }

    func uploadLogs() {
        writeRemoteLogs("YourModuleName", [
            RemoteLogEntry(level: .error, message: "主动上报日志内容"),
        ])
        uploadRemoteLogs("主动上报 bizComment")

        overlayCoordinator.presentGuide(
            title: "主动上报",
            statusText: "打日志成功",
            guideItems: [
                "等待1-2分钟，在 EMAS 控制台「远程日志」模块查看日志",
            ]
        )
    }
}
