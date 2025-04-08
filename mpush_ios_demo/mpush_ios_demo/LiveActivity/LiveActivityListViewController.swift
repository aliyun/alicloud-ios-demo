//
//  LiveActivityListViewController.swift
//  mpush_ios_demo
//
//  Created by Miracle on 2025/3/31.
//  Copyright © 2025 alibaba. All rights reserved.
//

import UIKit
import ActivityKit

class LiveActivityListViewController: UIViewController {

    @IBOutlet weak var activitiesListTableView: UITableView!

    var activities = [ActivityInfo]()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activitiesListTableView.delegate = self
        activitiesListTableView.dataSource = self

        observeActivities()

    }


    // MARK: - Action

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func refreshList(_ sender: Any) {
        getData()
    }
    
    // MARK: - 获取数据
    private func getData() {
        if #available(iOS 16.2, *) {
            activities.removeAll()
            activities.append(contentsOf: getTakeoutParams())
            activities.append(contentsOf: getTaxiParams())
            activitiesListTableView.reloadData()
        } else {
            // Fallback on earlier versions
        }
    }

    @available(iOS 16.2, *)
    private func getTaxiParams() -> [ActivityInfo] {
        let activities = Activity<mpushTaxiAttributes>.activities
        var infoArr = [ActivityInfo]()
        for activity in activities {
            var info = ActivityInfo()
            info.state = "\(activity.activityState)"
            info.modelName = "mpushTaxiAttributes"
            info.id = activity.id
            info.modelType = "打车"
            info.staleDate = activity.content.staleDate

            var staticParams = [String:String]()
            var dynamicParams = [String:String]()

            staticParams["appName"] = activity.attributes.appName
            staticParams["appLogo"] = activity.attributes.appLogo
            info.staticParams = staticParams

            dynamicParams["status"] = activity.contentState.status ?? "-"
            dynamicParams["distance"] = activity.contentState.distance ?? "-"
            dynamicParams["eta"] = activity.contentState.eta ?? "-"
            dynamicParams["prompt"] = activity.contentState.prompt ?? "-"
            info.dynamicParams = dynamicParams

            infoArr.append(info)
        }
        return infoArr
    }

    @available(iOS 16.2, *)
    private func getTakeoutParams() -> [ActivityInfo] {
        let activities = Activity<mpushTakeoutAttributes>.activities
        var infoArr = [ActivityInfo]()
        for activity in activities {
            var info = ActivityInfo()
            info.state = "\(activity.activityState)"
            info.modelName = "mpushTakeoutAttributes"
            info.id = activity.id
            info.modelType = "外卖"
            info.staleDate = activity.content.staleDate

            var staticParams = [String:String]()
            var dynamicParams = [String:String]()

            staticParams["appName"] = activity.attributes.merchantName
            staticParams["appLogo"] = activity.attributes.merchantLogo
            info.staticParams = staticParams

            dynamicParams["status"] = activity.contentState.status ?? "-"
            dynamicParams["distance"] = activity.contentState.distance ?? "-"
            dynamicParams["progress"] = activity.contentState.progress ?? "-"
            dynamicParams["prompt"] = activity.contentState.prompt ?? "-"
            info.dynamicParams = dynamicParams

            infoArr.append(info)
        }
        return infoArr
    }

    private func observeActivities() {
        if #available(iOS 16.1, *) {
            takeoutObserver()
            taxiObserver()
        } else {
            // Fallback on earlier versions
        }


    }

    /// 外卖模型监听
    private func takeoutObserver() {
        Task {
            if #available(iOS 16.2, *) {
                for await activity in Activity<mpushTakeoutAttributes>.activityUpdates {
                    Task {
                        for await _ in activity.contentUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
                            }
                        }
                    }

                    Task {
                        for await _ in activity.activityStateUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
                            }
                        }
                    }

                    Task {
                        for await _ in activity.pushTokenUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
                            }
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /// 打车模型监听
    private func taxiObserver() {
        Task {
            if #available(iOS 16.2, *) {
                for await activity in Activity<mpushTaxiAttributes>.activityUpdates {
                    Task {
                        for await _ in activity.contentUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
                            }
                        }
                    }

                    Task {
                        for await _ in activity.activityStateUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
                            }
                        }
                    }

                    Task {
                        for await _ in activity.pushTokenUpdates {
                            DispatchQueue.main.async {[weak self] in
                                self?.getData()
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


extension LiveActivityListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = activities[indexPath.section]

        let cell = ActivitiesTableViewCell.cellWith(reuseIdentifier: "ACTIVITIESCELLS") {
            if #available(iOS 16.2, *) {
                if info.modelName == "mpushTakeoutAttributes" {
                    let activities = Activity<mpushTakeoutAttributes>.activities
                    if let activity = activities.first(where: { $0.id == info.id }) {
                        Task {
                            let state = mpushTakeoutAttributes.ContentState(status: "4", distance: "0", progress: "0", prompt: "感谢使用智能出行")
                            await activity.end(.init(state: state, staleDate: nil))
                            self.getData()
                        }
                    }
                } else {
                    let activities = Activity<mpushTaxiAttributes>.activities
                    if let activity = activities.first(where: { $0.id == info.id }) {
                        Task {
                            let state = mpushTaxiAttributes.ContentState(status: "4", distance: "0", eta: "0", prompt: "欢迎使用，祝你生活愉快")
                            await activity.end(.init(state: state, staleDate: nil))
                            self.getData()
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        } detailAction: {
            let infoViewController = ActivityInfoViewController()
            infoViewController.activityInfo = info
            self.present(infoViewController, animated: true)
        }
        cell.configure(status: info.state, modelName: info.modelName, activityId: info.id)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
}
