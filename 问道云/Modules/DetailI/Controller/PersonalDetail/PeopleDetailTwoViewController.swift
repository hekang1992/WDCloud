//
//  PeopleDetailTwoViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//

import UIKit
import JXPagingView
import MJRefresh

class PeopleDetailTwoViewController: WDBaseViewController {
    
    var pageNum: Int = 1
    
    var holdType: String = ""
    
    var isHistory: Int = 0
    
    var personId: String = ""
    
    var allArray: [rowsModel] = []
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var onelabel: PaddedLabel = {
        let onelabel = PaddedLabel()
        onelabel.text = "全部"
        onelabel.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        onelabel.textColor = .init(cssStr: "#547AFF")
        onelabel.font = .mediumFontOfSize(size: 13)
        onelabel.isUserInteractionEnabled = true
        onelabel.layer.cornerRadius = 4
        onelabel.layer.masksToBounds = true
        onelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        onelabel.layer.borderWidth = 1
        onelabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return onelabel
    }()
    
    lazy var twolabel: PaddedLabel = {
        let twolabel = PaddedLabel()
        twolabel.text = "法定代表人"
        twolabel.backgroundColor = .init(cssStr: "#F3F3F3")
        twolabel.textColor = .init(cssStr: "#666666")
        twolabel.font = .mediumFontOfSize(size: 13)
        twolabel.isUserInteractionEnabled = true
        twolabel.layer.cornerRadius = 4
        twolabel.layer.masksToBounds = true
        twolabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        return twolabel
    }()
    
    lazy var threelabel: PaddedLabel = {
        let threelabel = PaddedLabel()
        threelabel.text = "对外投资"
        threelabel.backgroundColor = .init(cssStr: "#F3F3F3")
        threelabel.textColor = .init(cssStr: "#666666")
        threelabel.font = .mediumFontOfSize(size: 13)
        threelabel.isUserInteractionEnabled = true
        threelabel.layer.cornerRadius = 4
        threelabel.layer.masksToBounds = true
        threelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        return threelabel
    }()
    
    lazy var fourlabel: PaddedLabel = {
        let fourlabel = PaddedLabel()
        fourlabel.text = "在外任职"
        fourlabel.backgroundColor = .init(cssStr: "#F3F3F3")
        fourlabel.textColor = .init(cssStr: "#666666")
        fourlabel.font = .mediumFontOfSize(size: 13)
        fourlabel.isUserInteractionEnabled = true
        fourlabel.layer.cornerRadius = 4
        fourlabel.layer.masksToBounds = true
        fourlabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        return fourlabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .random()
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
        tableView.register(CorrelationViewCell.self, forCellReuseIdentifier: "CorrelationViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(whiteView)
        view.addSubview(onelabel)
        view.addSubview(twolabel)
        view.addSubview(threelabel)
        view.addSubview(fourlabel)
        view.addSubview(lineView)
        whiteView.addSubview(tableView)
        
        onelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(26)
        }
        twolabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(onelabel.snp.right).offset(8)
            make.height.equalTo(26)
        }
        threelabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right).offset(8)
            make.height.equalTo(26)
        }
        fourlabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right).offset(8)
            make.height.equalTo(26)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(fourlabel.snp.bottom).offset(12)
        }
        // 绑定 onelabel 的点击事件
        onelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSelectedLabel(self?.onelabel)
                self?.pageNum = 1
                self?.holdType = ""
                self?.getCorrelationInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 twolabel 的点击事件
        twolabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSelectedLabel(self?.twolabel)
                self?.pageNum = 1
                self?.holdType = "1"
                self?.getCorrelationInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 threelabel 的点击事件
        threelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSelectedLabel(self?.threelabel)
                self?.pageNum = 1
                self?.holdType = "2"
                self?.getCorrelationInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 fourlabel 的点击事件
        fourlabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSelectedLabel(self?.fourlabel)
                self?.pageNum = 1
                self?.holdType = "3"
                self?.getCorrelationInfo()
            })
            .disposed(by: disposeBag)
        
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 48)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            self.holdType = ""
            self.updateSelectedLabel(onelabel)
            getCorrelationInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.getCorrelationInfo()
        })
        
        //获取关联企业信息
        getCorrelationInfo()
        //获取数组
        getNumInfo()
        
    }
    
    private func updateSelectedLabel(_ selectedLabel: PaddedLabel?) {
        // 重置所有 label 的背景颜色
        resetLabelBackgroundColors()
        // 设置被点击的 label 的背景颜色
        selectedLabel?.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        selectedLabel?.textColor = .init(cssStr: "#547AFF")
        selectedLabel?.layer.borderWidth = 1
        selectedLabel?.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
    }
    
    private func resetLabelBackgroundColors() {
        [onelabel, twolabel, threelabel, fourlabel].forEach { label in
            label.backgroundColor = .init(cssStr: "#F3F3F3")
            label.textColor = .init(cssStr: "#666666")
            label.layer.borderWidth = 0
            label.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
}

extension PeopleDetailTwoViewController {
    
    //获取关联企业信息
    private func getCorrelationInfo() {
        let man = RequestManager()
        let dict = ["personId": personId,
                    "holdType": holdType,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/person/related-org",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    if pageNum == 1 {
                        self.pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    if self.allArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.whiteView)
                    }
                    self.tableView.reloadData()
                }else {
                    self.addNodataView(from: self.whiteView)
                }
                break
            case .failure(_):
                self.addNodataView(from: self.whiteView)
                break
            }
        }
    }
    
    private func getNumInfo() {
        let man = RequestManager()
        let dict = ["personId": personId]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/person/related-org-count",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.refreshLabelUIInfo(form: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func refreshLabelUIInfo(form model: DataModel) {
        self.onelabel.text = "全部 \(model.all ?? 0)"
        self.twolabel.text = "法定代表人 \(model.legal ?? 0)"
        self.threelabel.text = "对外投资 \(model.shareholder ?? 0)"
        self.fourlabel.text = "在外任职 \(model.staff ?? 0)"
    }
    
}

extension PeopleDetailTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CorrelationViewCell", for: indexPath) as! CorrelationViewCell
        cell.model.accept(model)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let companyDetailVc = CompanyBothViewController()
        companyDetailVc.enityId.accept(model.orgId ?? "")
        companyDetailVc.companyName.accept(model.orgName ?? "")
        self.navigationController?.pushViewController(companyDetailVc, animated: true)
    }
    
}


extension PeopleDetailTwoViewController: JXPagingViewListViewDelegate {
    
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
