//
//  ActivitiesTableViewCell.swift
//  mpush_ios_demo
//
//  Created by Miracle on 2025/3/31.
//  Copyright © 2025 alibaba. All rights reserved.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {
    // MARK: - ActionCallBack

    var endActionCallback: (() -> Void)?
    var detailActionCallback: (() -> Void)?

    // MARK: - UI组件

    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "状态"
        label.textColor = UIColor.init(hexString: "#999CA3")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusDotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "#29A64E")
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let statusValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.init(hexString: "#29A64E")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let modelTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "数据模型"
        label.textColor = UIColor.init(hexString: "#999CA3")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let modelValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.init(hexString: "#4B4D52")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let idTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "活动ID"
        label.textColor = UIColor.init(hexString: "#999CA3")
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let idValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.init(hexString: "#4B4D52")
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var endButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("结束", for: .normal)
        button.setTitleColor(UIColor.init(hexString: "#4B4D52"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor.init(hexString: "#EBF0FF")
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(endActivityAction), for: .touchUpInside)
        return button
    }()

    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("查看详情", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = UIColor.init(hexString: "#4253F7")
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(viewDetailAction), for: .touchUpInside)
        return button
    }()

    // MARK: -初始化方法

    class func cellWith(reuseIdentifier: String?, endAction: (() -> Void)? = nil,
                        detailAction:(() -> Void)? = nil) -> ActivitiesTableViewCell {
        let cell = ActivitiesTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.endActionCallback = endAction
        cell.detailActionCallback = detailAction
        return cell
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - 设置UI

    private func setupUI() {
        // 添加圆角和边框
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.init(hexString: "#E6E8EB").cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white

        // 添加子视图
        contentView.addSubview(statusTitleLabel)
        contentView.addSubview(statusDotView)
        contentView.addSubview(statusValueLabel)

        contentView.addSubview(modelTitleLabel)
        contentView.addSubview(modelValueLabel)
        contentView.addSubview(idTitleLabel)
        contentView.addSubview(idValueLabel)
        contentView.addSubview(endButton)
        contentView.addSubview(detailButton)

        //设置约束
        NSLayoutConstraint.activate([
            // 状态标签
            statusTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            statusTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            statusTitleLabel.widthAnchor.constraint(equalToConstant: 60),

            // 状态指示点
            statusDotView.centerYAnchor.constraint(equalTo: statusTitleLabel.centerYAnchor),
            statusDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            statusDotView.widthAnchor.constraint(equalToConstant: 4),
            statusDotView.heightAnchor.constraint(equalToConstant: 4),

            // 状态值文本
            statusValueLabel.centerYAnchor.constraint(equalTo: statusTitleLabel.centerYAnchor),
            statusValueLabel.leadingAnchor.constraint(equalTo: statusDotView.trailingAnchor, constant: 4),

            // 数据模型标签
            modelTitleLabel.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: 10),
            modelTitleLabel.leadingAnchor.constraint(equalTo: statusTitleLabel.leadingAnchor),
            modelTitleLabel.widthAnchor.constraint(equalTo: statusTitleLabel.widthAnchor),

            // 数据模型值
            modelValueLabel.centerYAnchor.constraint(equalTo: modelTitleLabel.centerYAnchor),
            modelValueLabel.leadingAnchor.constraint(equalTo: statusValueLabel.leadingAnchor),
            modelValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),

            // 活动ID标签
            idTitleLabel.topAnchor.constraint(equalTo: modelTitleLabel.bottomAnchor, constant: 10),
            idTitleLabel.leadingAnchor.constraint(equalTo: statusTitleLabel.leadingAnchor),
            idTitleLabel.widthAnchor.constraint(equalTo: statusTitleLabel.widthAnchor),

            // 活动ID值
            idValueLabel.centerYAnchor.constraint(equalTo: idTitleLabel.centerYAnchor),
            idValueLabel.leadingAnchor.constraint(equalTo: statusValueLabel.leadingAnchor),
            idValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),

            // 结束按钮
            endButton.topAnchor.constraint(equalTo: idTitleLabel.bottomAnchor, constant: 25),
            endButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            endButton.widthAnchor.constraint(equalToConstant: 80),
            endButton.heightAnchor.constraint(equalToConstant: 40),
            endButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            // 查看详情按钮
            detailButton.centerYAnchor.constraint(equalTo: endButton.centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            detailButton.widthAnchor.constraint(equalToConstant: 80),
            detailButton.heightAnchor.constraint(equalToConstant:40)
        ])
    }

    // MARK: -公共方法

    func configure(status: String, modelName: String, activityId: String) {
        statusValueLabel.text = status
        modelValueLabel.text = modelName
        idValueLabel.text = activityId
        endButton.isHidden = false

        // 根据状态调整显示
        var dotColor = UIColor.init(hexString: "#29A64E")
        var valueColor = UIColor.init(hexString: "#29A64E")

        switch status.lowercased() {
        case "active":
            dotColor = UIColor.init(hexString: "#29A64E")
            valueColor = UIColor.init(hexString: "#29A64E")
        case "ended":
            dotColor = UIColor.init(hexString: "#C82727")
            valueColor = UIColor.init(hexString: "#C82727")
            endButton.isHidden = true
        case "dismissed":
            dotColor = UIColor.init(hexString: "#9DA3BC")
            valueColor = UIColor.init(hexString: "#9DA3BC")
            endButton.isHidden = true
        case "stale":
            dotColor = UIColor.init(hexString: "#F0891C")
            valueColor = UIColor.init(hexString: "#F0891C")
        default:
            dotColor = UIColor.init(hexString: "#29A64E")
            valueColor = UIColor.init(hexString: "#29A64E")
        }

        statusDotView.backgroundColor = dotColor
        statusValueLabel.textColor = valueColor
    }


    // MARK: - Action

    @objc private func endActivityAction() {
        endActionCallback?()
    }

    @objc private func viewDetailAction() {
        detailActionCallback?()
    }


}
