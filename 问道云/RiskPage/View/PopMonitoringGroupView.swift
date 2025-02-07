//
//  PopMonitoringGroupView.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  弹出企业group

import UIKit

class PopMonitoringGroupView: BaseView {
    
    var block: ((rowsModel) -> Void)?

    var groupArray: [rowsModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F6F6F6")
        return bgView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(tableView)
        bgView.addSubview(cancelBtn)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(300)
        }
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(250)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopMonitoringGroupView: UITableViewDelegate, UITableViewDataSource {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 5)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.groupArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = model?.groupname ?? ""
        cell.textLabel?.font = .mediumFontOfSize(size: 15)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.groupArray?[indexPath.row] {
            self.block?(model)
        }
    }
    
}
