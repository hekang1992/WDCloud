//
//  RiskListPeopleView.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//  只有人员

import UIKit
import RxRelay

class RiskListPeopleView: BaseView {
    
    //被搜索的文字,根据这个文字,去给cell的namelabel加上颜色
    var searchWordsRelay = BehaviorRelay<String?>(value: nil)
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .clear
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F8F8F8")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TwoRiskListOnlyPeopleCell.self, forCellReuseIdentifier: "TwoRiskListOnlyPeopleCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RiskListPeopleView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.value?.personData?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListOnlyPeopleCell") as? TwoRiskListOnlyPeopleCell
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        let model = dataModel.value?.personData?.items?[indexPath.row]
        model?.searchStr = self.searchWordsRelay.value ?? ""
        cell?.model.accept(model)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let numStr = String(dataModel.value?.personData?.total ?? 0)
        let headView = UIView()
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        // 设置搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: numStr, fullText: "搜索到\(numStr)条结果", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        return headView
    }
    
}
