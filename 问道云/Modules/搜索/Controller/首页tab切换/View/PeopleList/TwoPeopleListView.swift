//
//  TwoPeopleListView.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxRelay
import SkeletonView

class TwoPeopleListView: BaseView {
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var dataModelArray = BehaviorRelay<[itemsModel]?>(value: nil)
    
    //被搜索的文字,根据这个文字,去给cell的namelabel加上颜色
    var searchWordsRelay = BehaviorRelay<String?>(value: nil)
    
    var peopleBlock: ((itemsModel) -> Void)?
    
    var pageBlock: ((itemsModel) -> Void)?
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .clear
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(TwoPeopleNormalListCell.self, forCellReuseIdentifier: "TwoPeopleNormalListCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoPeopleListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataModelArray.value?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataModelArray.value?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoPeopleNormalListCell") as! TwoPeopleNormalListCell
        model?.searchStr = self.searchWordsRelay.value ?? ""
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model.accept(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let numStr = String(dataModel.value?.total ?? 0)
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        //搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: numStr, fullText: "搜索到\(numStr)位相关人员", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = dataModelArray.value?[indexPath.row] {
            let shareholderListCount = model.shareholderList?.count ?? 0
            let moduleId = model.moduleId ?? ""
            if moduleId == "14" {
                if shareholderListCount != 0 {//有合作伙伴
                    self.peopleBlock?(model)
                }else {
                    self.pageBlock?(model)
                }
            }else {
                if shareholderListCount != 0 {//有合作伙伴
                    self.peopleBlock?(model)
                }else {
                    self.peopleBlock?(model)
                }
            }
        }
    }
    
}

// MARK: - SkeletonTableViewDataSource
extension TwoPeopleListView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TwoPeopleNormalListCell"
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "TwoPeopleNormalListCell", for: indexPath) as! TwoPeopleNormalListCell
        cell.selectionStyle = .none
        return cell
    }
    
}
