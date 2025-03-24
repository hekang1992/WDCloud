//
//  PropertyLineHotView.swift
//  问道云
//
//  Created by 何康 on 2025/3/21.
//

import UIKit
import TagListView
import SkeletonView
import TYAlertController

class PropertyLineHotView: BaseView {
    
    var modelArray: [DataModel]?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(PropertyListViewCell.self, forCellReuseIdentifier: "PropertyListViewCell")
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PropertyLineHotView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let label = UILabel()
        label.text = "热门搜索"
        label.textColor = .init(cssStr: "#333333")
        label.font = .regularFontOfSize(size: 13)
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(25)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListViewCell", for: indexPath) as! PropertyListViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.model = model
        cell.cellBlock = { [weak self] in
            guard let self = self else { return }
            self.tableView(tableView, didSelectRowAt: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.modelArray?[indexPath.row] {
            let cell = tableView.cellForRow(at: indexPath) as! PropertyListViewCell
            self.checkInfo(from: model, cell: cell)
        }
    }

}

extension PropertyLineHotView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PropertyListViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

/** 网络数据请求 */
extension PropertyLineHotView {
    
    //添加监控
    private func checkInfo(from model: DataModel, cell: PropertyListViewCell) {
        let entityType = "1"
        let entityId = model.entityId ?? ""
        let entityName = model.entityName ?? ""
        let dict = ["entityType": entityType,
                    "entityId": entityId,
                    "entityName": entityName]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/equity-property/check",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let vc = ViewControllerUtils.findViewController(from: self)
                    let bothVc = PropertyLineBothViewController()
                    let enityId = model.entityId ?? ""
                    let companyName = model.entityName ?? ""
                    bothVc.enityId.accept(enityId)
                    bothVc.companyName.accept(companyName)
                    bothVc.logoUrl = model.logoUrl ?? ""
                    bothVc.monitor = model.monitor ?? false
                    vc?.navigationController?.pushViewController(bothVc, animated: true)
                }else if success.code == 702 {
                    let vc = ViewControllerUtils.findViewController(from: self)
                    let buyVipView = PopBuyVipView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 400))
                    buyVipView.bgImageView.image = UIImage(named: "poponereportimge")
                    let alertVc = TYAlertController(alert: buyVipView, preferredStyle: .alert)!
                    buyVipView.cancelBlock = {
                        vc?.dismiss(animated: true)
                    }
                    buyVipView.buyOneBlock = {
                        //跳转购买单次会员
                        vc?.dismiss(animated: true, completion: {
                            let oneVc = BuyOnePropertyLineViewController()
                            oneVc.entityType = 1
                            oneVc.entityId = model.entityId ?? ""
                            oneVc.entityName = model.entityName ?? ""
                            //刷新列表
                            oneVc.refreshBlock = { [weak self] in
                                guard let self = self else { return }
                                addUnioInfo(form: model.entityId ?? "")
                                model.monitor = true
                                cell.monitoringBtn.setImage(UIImage(named: "propertyhavjiank"), for: .normal)
                            }
                            vc?.navigationController?.pushViewController(oneVc, animated: true)
                        })
                    }
                    buyVipView.buyVipBlock = {
                        //跳转购买会员
                        vc?.dismiss(animated: true, completion: {
                            let memVc = MembershipCenterViewController()
                            vc?.navigationController?.pushViewController(memVc, animated: true)
                        })
                    }
                    vc?.present(alertVc, animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //添加关联方信息
    func addUnioInfo(form entityId: String) {
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/relation",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
