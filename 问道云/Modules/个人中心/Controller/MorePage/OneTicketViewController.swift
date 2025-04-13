//
//  OneTicketViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/17.
//  开票列表1

import UIKit
import RxRelay
import MJRefresh

class OneTicketViewController: WDBaseViewController {
    
    var pageNum = 1
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var allArray: [rowsModel] = []//加载更多
    
    var toOpenTicketBlock: ((rowsModel) -> Void)?
    
    lazy var oneTicketView: OneTicketView = {
        let oneTicketView = OneTicketView()
        return oneTicketView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(oneTicketView)
        oneTicketView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.oneTicketView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            getListInfo()
        })
        //加载更多
        self.oneTicketView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getListInfo()
        })
        //去开票立即开票
        oneTicketView.backBlock = { [weak self] model in
            self?.toOpenTicketBlock?(model)
        }
    }
    
}

extension OneTicketViewController {
    
    //获取列表信息
    func getListInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "pageNum": pageNum,
                    "pageSize": 10] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/invoiceRecord/selecinvoicerise",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            self.oneTicketView.tableView.mj_header?.endRefreshing()
            self.oneTicketView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data, let total = model.total {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    self.oneTicketView.modelArray.accept(allArray)
                    if self.allArray.count != total {
                        self.oneTicketView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.oneTicketView.tableView.mj_footer?.isHidden = true
                    }
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.oneTicketView)
                        
                    }
                }
                break
            case .failure(_):
                self.addNoNetView(from: self.oneTicketView)
                self.noNetView.refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
                    self?.pageNum = 1
                    self?.getListInfo()
                }).disposed(by: disposeBag)
                break
            }
        }
    }
    
}
