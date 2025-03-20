//
//  PopShareholdePhoneView.swift
//  问道云
//
//  Created by Andrew on 2025/3/17.
//

import UIKit

class PopShareholdePhoneView: BaseView {
    
    var dataList: [websitesListModel]? {
        didSet {
            guard let dataList = dataList else { return }
        }
    }
    
    var closeBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#27344C")
        descLabel.font = .mediumFontOfSize(size: 18)
        descLabel.textAlignment = .center
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(type: .custom)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.setTitleColor(.init(cssStr: "#307CFF"), for: .normal)
        closeBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        return closeBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ShareholdePhoneViewCell.self, forCellReuseIdentifier: "ShareholdePhoneViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(descLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(closeBtn)
        bgView.addSubview(tableView)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(35)
            make.height.equalTo(200)
        }
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18.5)
            make.height.equalTo(22)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-45)
        }
        closeBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(45)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(1)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top).offset(-1)
        }
        closeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.closeBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopShareholdePhoneView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataList?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareholdePhoneViewCell", for: indexPath) as! ShareholdePhoneViewCell
        cell.selectionStyle = .none
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList?[indexPath.row]
        let phoneNumber = model?.value ?? ""
        guard let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
            print("无法拨打电话或电话号码无效")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
