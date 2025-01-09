//
//  SearchRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  风险搜索

import UIKit
import JXPagingView
import RxRelay

class SearchRiskViewController: WDBaseViewController {
    
    var searchWords: String? {
        didSet {
            print("searchWords风险======\(searchWords ?? "")")
        }
    }
    
    //热搜
    var hotWordsArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //搜索文字回调
    var lastSearchTextBlock: ((String) -> Void)?
    
    lazy var riskView: CompanyView = {
        let riskView = CompanyView()
        return riskView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(riskView)
        view.addSubview(tableView)
        tableView.isHidden = true
        riskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: {
            
        })
        //最近搜索
        getlastSearch()
        
        //浏览历史
        getBrowsingHistory()
        
        //热搜
        getHotWords()
        
        //删除最近搜索
        self.riskView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
        }).disposed(by: disposeBag)
        //删除浏览历史
        self.riskView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
        }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.riskView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("风险===============风险")
    }
}

extension SearchRiskViewController {
    
    //最近搜索
    private func getlastSearch() {
        let man = RequestManager()
        let dict = ["searchType": "", "moduleId": "05"]
        man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/query", method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.riskView.searchView.tagListView.removeAllTags()
            self.riskView.searchView.tagListView.addTags(strArray)
            self.riskView.searchView.isHidden = false
            self.riskView.layoutIfNeeded()
            let height = self.riskView.searchView.tagListView.frame.height
            self.riskView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.riskView.searchView.isHidden = true
            self.riskView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory() {
        let man = RequestManager()
        let dict = ["viewrecordtype": "", "moduleId": "05", "pageNum": "1", "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = {
                
            }
            listView.nameLabel.text = model.firmname ?? ""
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.riskView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.riskView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.riskView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.riskView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.riskView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords() {
        let man = RequestManager()
        let dict = ["moduleId": "05"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.hotWordsArray.accept(model.data ?? [])
                    hotsWordsUI(data: model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = {
                
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.riskView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.riskView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.riskView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.riskView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.riskView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            let dict = ["searchType": "", "moduleId": "05"]
            man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/clear", method: .post) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.riskView.searchView.removeFromSuperview()
                        self.riskView.searchView.snp.makeConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //删除浏览历史
    private func deleteHistoryInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除浏览历史?", confirmAction: {
            let man = RequestManager()
            let dict = ["searchType": "", "moduleId": "05", "viewrecordtype": ""]
            man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord", method: .get) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.riskView.historyView.removeFromSuperview()
                        self.riskView.historyView.snp.makeConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
}

extension SearchRiskViewController: JXPagingViewListViewDelegate {
    
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
