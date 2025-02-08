//
//  HistoryRiskDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/17.
//  自身风险

import UIKit
import JXPagingView
import DropMenuBar
import RxRelay

class HistoryRiskDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var name: String = ""
    
    var logo: String = ""
    
    var functionType: String = "2"// 1-自身风险，2-历史风险，3-日报，4-全部
    var dateType: String = ""
    var itemtype: String = "1"
    var allArray: [itemsModel]?
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RiskDetailViewCell.self, forCellReuseIdentifier: "RiskDetailViewCell")
        return tableView
    }()
    
    //法律风险view
    lazy var lawView: CompanyLawListView = {
        let lawView = CompanyLawListView()
        lawView.backgroundColor = .white
        lawView.isHidden = true
        lawView.oneBlock = { model1, model2 in
            let riskSecondVc = ComanyRiskMoreDetailViewController()
            riskSecondVc.itemsModel.accept(model1)
            riskSecondVc.listmodel.accept(model2)
            riskSecondVc.dateType = self.dateType
            riskSecondVc.itemtype = self.itemtype
            riskSecondVc.logo = self.logo
            riskSecondVc.name = self.name
            riskSecondVc.entityid = self.enityId
            self.navigationController?.pushViewController(riskSecondVc, animated: true)
        }
        
        lawView.block = { model in
            let riskSecondVc = ComanyRiskMoreDetailViewController()
            riskSecondVc.itemsModel.accept(model)
            riskSecondVc.dateType = self.dateType
            riskSecondVc.itemtype = self.itemtype
            riskSecondVc.logo = self.logo
            riskSecondVc.name = self.name
            riskSecondVc.entityid = self.enityId
            self.navigationController?.pushViewController(riskSecondVc, animated: true)
        }
        return lawView
    }()
    
    lazy var onelabel: PaddedLabel = {
        let onelabel = PaddedLabel()
        onelabel.text = "经营风险"
        onelabel.backgroundColor = .init(cssStr: "#547AFF")
        onelabel.textColor = .white
        onelabel.font = .mediumFontOfSize(size: 13)
        onelabel.isUserInteractionEnabled = true
        onelabel.layer.cornerRadius = 4
        onelabel.layer.masksToBounds = true
        onelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        onelabel.layer.borderWidth = 1
        onelabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        onelabel.textAlignment = .center
        return onelabel
    }()
    
    lazy var twolabel: PaddedLabel = {
        let twolabel = PaddedLabel()
        twolabel.text = "法律风险"
        twolabel.backgroundColor = .white
        twolabel.textColor = .init(cssStr: "#547AFF")
        twolabel.font = .mediumFontOfSize(size: 13)
        twolabel.isUserInteractionEnabled = true
        twolabel.layer.cornerRadius = 4
        twolabel.layer.masksToBounds = true
        twolabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        twolabel.layer.borderWidth = 1
        twolabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        twolabel.textAlignment = .center
        return twolabel
    }()
    
    lazy var threelabel: PaddedLabel = {
        let threelabel = PaddedLabel()
        threelabel.text = "财务风险"
        threelabel.backgroundColor = .white
        threelabel.textColor = .init(cssStr: "#547AFF")
        threelabel.font = .mediumFontOfSize(size: 13)
        threelabel.isUserInteractionEnabled = true
        threelabel.layer.cornerRadius = 4
        threelabel.layer.masksToBounds = true
        threelabel.textAlignment = .center
        threelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        threelabel.layer.borderWidth = 1
        threelabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return threelabel
    }()
    
    lazy var fourlabel: PaddedLabel = {
        let fourlabel = PaddedLabel()
        fourlabel.text = "舆情风险"
        fourlabel.textAlignment = .center
        fourlabel.backgroundColor = .init(cssStr: "#F5F5F5")
        fourlabel.textColor = .init(cssStr: "#547AFF")
        fourlabel.font = .mediumFontOfSize(size: 13)
        fourlabel.isUserInteractionEnabled = true
        fourlabel.layer.cornerRadius = 4
        fourlabel.layer.masksToBounds = true
        fourlabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        fourlabel.layer.borderWidth = 1
        fourlabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return fourlabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#333333")
        return numLabel
    }()
    
    lazy var maskView: UIView = {
        let maskView = UIView()
        maskView.layer.borderWidth = 1
        maskView.layer.borderColor = UIColor.init(cssStr: "#FF0000")?.cgColor
        maskView.backgroundColor = .init(cssStr: "#FF0000")?.withAlphaComponent(0.05)
        return maskView
    }()
    
    lazy var oneItemView: RiskNumView = {
        let oneItemView = RiskNumView()
        oneItemView.nameLabel.text = "高风险"
        oneItemView.numLabel.textColor = .init(cssStr: "#FF0000")
        oneItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return oneItemView
    }()
    
    lazy var twoItemView: RiskNumView = {
        let twoItemView = RiskNumView()
        twoItemView.nameLabel.text = "低风险"
        twoItemView.numLabel.textColor = .init(cssStr: "#333333")
        twoItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return twoItemView
    }()
    
    lazy var threeItemView: RiskNumView = {
        let threeItemView = RiskNumView()
        threeItemView.nameLabel.text = "提示信息"
        threeItemView.numLabel.textColor = .init(cssStr: "#FF0000")
        threeItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return threeItemView
    }()

    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    
    var startTime: String = ""//开始时间
    
    var endTime: String = ""//结束时间
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(numLabel)
        view.addSubview(whiteView)
        whiteView.addSubview(onelabel)
        whiteView.addSubview(twolabel)
        whiteView.addSubview(threelabel)
        whiteView.addSubview(fourlabel)
        view.addSubview(maskView)
        maskView.addSubview(oneItemView)
        maskView.addSubview(twoItemView)
        maskView.addSubview(threeItemView)
        view.addSubview(tableView)
        view.addSubview(lawView)
        
        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(22)
            make.height.equalTo(25)
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        maskView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
            make.height.equalTo(61.5)
        }
        
        let labelWidth = (SCREEN_WIDTH - 57) * 0.25
        onelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        twolabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(onelabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        threelabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        fourlabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        
        twoItemView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 61.5))
        }
        oneItemView.snp.makeConstraints { make in
            make.right.equalTo(twoItemView.snp.left)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 61.5))
        }
        threeItemView.snp.makeConstraints { make in
            make.left.equalTo(twoItemView.snp.right)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 61.5))
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(maskView.snp.bottom)
        }
        lawView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(maskView.snp.bottom)
        }
        // 绑定 onelabel 的点击事件
        onelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.onelabel)
                self?.itemtype = "1"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 twolabel 的点击事件
        twolabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "2")
                self?.updateSelectedLabel(self?.twolabel)
                self?.itemtype = "2"
                self?.getRiskLowDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 threelabel 的点击事件
        threelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.threelabel)
                self?.itemtype = "3"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 fourlabel 的点击事件
        fourlabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.fourlabel)
                self?.itemtype = "4"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        getRiskDetailInfo()
    }
    
    private func updateSelectedLabel(_ selectedLabel: PaddedLabel?) {
        // 重置所有 label 的背景颜色
        resetLabelBackgroundColors()
        // 设置被点击的 label 的背景颜色
        selectedLabel?.backgroundColor = .init(cssStr: "#547AFF")
        selectedLabel?.textColor = .white
        selectedLabel?.layer.borderWidth = 1
        selectedLabel?.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
    }
    
    private func resetLabelBackgroundColors() {
        [onelabel, twolabel, threelabel, fourlabel].forEach { label in
            label.backgroundColor = .white
            label.textColor = .init(cssStr: "#547AFF")
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        }
    }
    
}

extension HistoryRiskDetailViewController {
    
    //显示和隐藏
    private func hideLawOrTableView(form type: String) {
        if type == "2" {
            self.lawView.isHidden = false
            self.tableView.isHidden = true
        }else {
            self.lawView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    //获取风险信息
    private func getRiskDetailInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityid": enityId,
                    "functionType": functionType,
                    "itemtype": itemtype,
                    "dateType": dateType]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/riskDynamicslow",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    let rows = model.items ?? []
                    self.allArray = rows
                    self.tableView.reloadData()
                    self.refreshUI(from: model)
                    self.emptyView.removeFromSuperview()
                    if rows.isEmpty {
                        self.addNodataView(from: self.tableView)
                    }
                }
                break
            case .failure(_):
                self.addNodataView(from: self.tableView)
                break
            }
        }
    }
    
    //获取法律风险数据信息
    private func getRiskLowDetailInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityid": enityId,
                    "functionType": functionType,
                    "itemtype": itemtype,
                    "dateType": dateType]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/riskDynamicsbereLegalRisk",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    let rows = model.items ?? []
                    self.refreshUI(from: model)
                    self.emptyView.removeFromSuperview()
                    if rows.isEmpty {
                        self.addNodataView(from: self.lawView)
                    }
                }
                break
            case .failure(_):
                self.addNodataView(from: self.lawView)
                break
            }
        }
    }
    
    //数据刷新
    func refreshUI(from model: DataModel) {
        let count = String(model.sumTotal ?? 0)
        self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "历史累计风险:\(count)条", colorStr: "#FF0000")
        self.oneItemView.numLabel.text = model.riskGrade?.highRiskSum ?? "0"
        self.twoItemView.numLabel.text = model.riskGrade?.lowRiskSum ?? "0"
        self.threeItemView.numLabel.text = model.riskGrade?.hintRiskSum ?? "0"
        //法律风险数据
        if self.itemtype == "2" {
            let modelArray = model.items ?? []
            self.lawView.modelArray.accept(modelArray)
            self.lawView.numLabel.text = "案件信息(\(count))"
        }
        self.lawView.tableView.reloadData()
    }
    
}

extension HistoryRiskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RiskDetailViewCell", for: indexPath) as? RiskDetailViewCell else { return UITableViewCell() }
        let model = self.allArray?[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.namelabel.text = model?.itemname ?? ""
        cell.numlabel.text = "共\(model?.size ?? 0)条"
        if let model = model {
            cell.highLabel.text = "高风险(\(model.highCount ?? 0))"
            if model.highCount == 0 {
                cell.highLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                    make.left.equalTo(cell.namelabel.snp.right)
                })
            }
            cell.lowLabel.text = "低风险(\(model.lowCount ?? 0))"
            if model.lowCount == 0 {
                cell.lowLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                    make.left.equalTo(cell.highLabel.snp.right)
                })
            }
            cell.hitLabel.text = "提示(\(model.hintCount ?? 0))"
            if model.hintCount == 0 {
                cell.hitLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = self.allArray?[indexPath.row] else { return }
        let riskSecondVc = ComanyRiskMoreDetailViewController()
        riskSecondVc.itemsModel.accept(model)
        riskSecondVc.dateType = self.dateType
        riskSecondVc.itemtype = self.itemtype
        riskSecondVc.logo = self.logo
        riskSecondVc.name = self.name
        riskSecondVc.entityid = self.enityId
        self.navigationController?.pushViewController(riskSecondVc, animated: true)
    }
    
}

extension HistoryRiskDetailViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
