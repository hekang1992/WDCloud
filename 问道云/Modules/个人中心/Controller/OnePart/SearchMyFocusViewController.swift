//
//  SearchMyFocusViewController.swift
//  问道云
//
//  Created by 何康 on 2025/4/12.
//  搜索我的关注的企业和人员

import UIKit
import RxRelay

class SearchMyFocusViewController: WDBaseViewController {
    
    var customerFollowList: [customerFollowListModel] = []
    
    var isCompany: String = "1"
    
    var searchStr = BehaviorRelay<String?>(value: nil)
    
    private let man = RequestManager()
    
    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.setTitle("取消", for: .normal)
        clickBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        clickBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return clickBtn
    }()
    
    lazy var leftView: UIView = {
        let leftView = UIView(frame: CGRectMake(0, 0, 33, 33))
        let icon = UIImageView()
        icon.frame = CGRectMake(9, 9, 15, 15)
        icon.image = UIImage(named: "searchiconf")
        leftView.addSubview(icon)
        return leftView
    }()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.isHidden = true
        backBtn.setImage(UIImage(named: "backimage"), for: .normal)
        return backBtn
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        searchTx.backgroundColor = .init(cssStr: "#F5F5F5")
        searchTx.font = .regularFontOfSize(size: 13)
        searchTx.textColor = .init(cssStr: "#666666")
        searchTx.clearButtonMode = .whileEditing
        searchTx.returnKeyType = .search
        searchTx.placeholder = "请输入企业名称"
        searchTx.layer.cornerRadius = 3
        searchTx.layer.borderWidth = 0.5
        searchTx.layer.borderColor = UIColor.init(cssStr: "#E2E2E2")?.cgColor
        searchTx.leftView = leftView
        searchTx.leftViewMode = .always
        return searchTx
    }()
    
    lazy var companyBtn: UIButton = {
        let companyBtn = UIButton(type: .custom)
        companyBtn.setTitle("企业", for: .normal)
        companyBtn.isSelected = true
        companyBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        companyBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        companyBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .selected)
        return companyBtn
    }()
    
    lazy var peopleBtn: UIButton = {
        let peopleBtn = UIButton(type: .custom)
        peopleBtn.setTitle("人员", for: .normal)
        peopleBtn.isSelected = false
        peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        peopleBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .selected)
        return peopleBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.isHidden = false
        lineView.backgroundColor = .init(cssStr: "#547AFF")
        lineView.layer.cornerRadius = 2
        return lineView
    }()
    
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.isHidden = true
        line1View.backgroundColor = .init(cssStr: "#547AFF")
        line1View.layer.cornerRadius = 2
        return line1View
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(FocusCompanyViewNormalCell.self, forCellReuseIdentifier: "FocusCompanyViewNormalCell")
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
        view.addSubview(searchView)
        searchView.addSubview(clickBtn)
        searchView.addSubview(searchTx)
        searchView.addSubview(backBtn)
        searchView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        searchTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-47)
            make.bottom.equalToSuperview().offset(-9)
            make.height.equalTo(33)
        }
        backBtn.snp.makeConstraints { make in
            make.centerY.equalTo(searchTx.snp.centerY)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        clickBtn.snp.makeConstraints { make in
            make.centerY.equalTo(searchTx.snp.centerY)
            make.right.equalToSuperview()
            make.left.equalTo(searchTx.snp.right)
            make.height.equalTo(33)
        }
        
        clickBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: false)
        }).disposed(by: disposeBag)
        
        backBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: false)
        }).disposed(by: disposeBag)
        
        // 监听 UITextField 的文本变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: self.searchTx
        )
        
        view.addSubview(whiteView)
        whiteView.addSubview(lineView)
        whiteView.addSubview(line1View)
        whiteView.addSubview(companyBtn)
        whiteView.addSubview(peopleBtn)
        
        view.addSubview(tableView)
        
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(1)
            make.height.equalTo(34)
        }
        companyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 40, height: 21))
            make.top.equalTo(whiteView.snp.top).offset(6)
        }
        
        peopleBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-100)
            make.size.equalTo(CGSize(width: 40, height: 21))
            make.top.equalTo(whiteView.snp.top).offset(6)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(companyBtn.snp.centerX)
            make.left.equalTo(companyBtn.snp.left).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
        
        line1View.snp.makeConstraints { make in
            make.centerX.equalTo(peopleBtn.snp.centerX)
            make.left.equalTo(peopleBtn.snp.left).offset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
        
        companyBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.isCompany = "1"
            self?.lineView.isHidden = false
            self?.line1View.isHidden = true
            self?.searchList()
        }).disposed(by: disposeBag)
        
        peopleBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.isCompany = "2"
            self?.lineView.isHidden = true
            self?.line1View.isHidden = false
            self?.searchList()
        }).disposed(by: disposeBag)
        
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom).offset(1)
        }
        
        self.searchStr.asObservable().subscribe(onNext: { [weak self] keywords in
            guard let self = self, let keywords = keywords  else { return }
            if !keywords.isEmpty {
                self.searchList()
            }else {
                man.cancelLastRequest()
            }
        }).disposed(by: disposeBag)
        
        self.addNodataView(from: self.tableView)
    }

}

extension SearchMyFocusViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customerFollowList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.customerFollowList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FocusCompanyViewNormalCell", for: indexPath) as! FocusCompanyViewNormalCell
        cell.model.accept(model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.customerFollowList[indexPath.row]
        let followtargettype = model.followtargettype ?? ""
        if followtargettype == "1" {
            let detailVc = CompanyBothViewController()
            detailVc.companyName.accept(model.followtargetname ?? "")
            detailVc.enityId.accept(model.entityId ?? "")
            self.navigationController?.pushViewController(detailVc, animated: true)
        }else {
            let detailVc = PeopleBothViewController()
            detailVc.peopleName.accept(model.followtargetname ?? "")
            detailVc.personId.accept(model.personnumber ?? "")
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
    }
    
}

extension SearchMyFocusViewController {
    
    @objc private func textDidChange() {
        let isComposing = self.searchTx.markedTextRange != nil
        if !isComposing {
            backBtn.isHidden = false
            searchTx.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(40)
            }
            self.searchStr.accept(self.searchTx.text ?? "")
        }else {
            backBtn.isHidden = true
            searchTx.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(10)
            }
        }
    }
    
    func searchList() {
        ViewHud.addLoadView()
        let followTargetType = self.isCompany
        let followTargetName = self.searchStr.value ?? ""
        let dict = ["followTargetType": followTargetType, "followTargetName": followTargetName]
        man.requestAPI(params: dict, pageUrl: "/operation/follow/list", method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self {
                        self.customerFollowList.removeAll()
                        let rowsArray = success.data?.rows ?? []
                        for model in rowsArray {
                            self.customerFollowList.append(contentsOf: model.customerFollowList ?? [])
                        }
                        if self.customerFollowList.isEmpty {
                            self.addNodataView(from: self.tableView)
                        }else {
                            self.emptyView.removeFromSuperview()
                        }
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
