//
//  MessagePushCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2025/4/13.
//  消息推送设置

import UIKit

class MessagePushCenterViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "消息推送设置"
        return headView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .regularFontOfSize(size: 14)
        nameLabel.text = "接收消息总开关"
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 11)
        descLabel.text = "请前往手机设置中更改配置"
        return descLabel
    }()
    
    lazy var openBtn: UIButton = {
        let openBtn = UIButton(type: .custom)
        openBtn.contentHorizontalAlignment = .right
        openBtn.setTitle("已关闭", for: .normal)
        openBtn.setTitle("已开启", for: .selected)
        openBtn.setImage(UIImage(named: "righticonimage"), for: .normal)
        openBtn.setTitleColor(UIColor.init(cssStr: "#999999"), for: .normal)
        openBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        return openBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MessagePushListViewCell.self, forCellReuseIdentifier: "MessagePushListViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.height.equalTo(62.5)
        }
        
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(descLabel)
        whiteView.addSubview(openBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(15)
        }
        openBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(70.pix())
        }
        
        openBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.openSettings()
        }).disposed(by: disposeBag)
        
        // 监听应用回到前台的通知
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkAndUpdateUI),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        checkAndUpdateUI()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom).offset(5)
        }
    }
    
}

extension MessagePushCenterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nametitles = ["商查动态", "内容资讯", "优惠活动", "系统通知", "推送我可能感兴趣的内容"]
        let desctitles = ["开启后可接收公司和老板的动态风险", "开启后可接收商业热点、新闻舆情等", "开启后可接收会员优惠、用户福利、促销活动等", "开启后可接收平台的通知提醒", "开启后可接收更适合您的优质内容"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagePushListViewCell", for: indexPath) as! MessagePushListViewCell
        cell.nameLabel.text = nametitles[indexPath.row]
        cell.descLabel.text = desctitles[indexPath.row]
        return cell
    }
    
}

extension MessagePushCenterViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        openBtn.layoutButtonEdgeInsets(style: .right, space: 5)
    }
    
    @objc func checkAndUpdateUI() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    self.openBtn.isSelected = true
                    break
                case .denied:
                    self.openBtn.isSelected = false
                    break
                default:
                    break
                }
            }
        }
    }
    
}
