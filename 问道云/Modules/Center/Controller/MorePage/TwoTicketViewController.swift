//
//  TwoTicketViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/17.
//  开票列表2

import UIKit
import RxRelay
import MJRefresh
import TYAlertController

class TwoTicketViewController: WDBaseViewController {
    
    var pageNum = 1
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var allArray: [rowsModel] = []//加载更多
    
    var linkBlock: ((rowsModel) -> Void)?
    
    lazy var twoTicketView: TwoTicketView = {
        let twoTicketView = TwoTicketView()
        return twoTicketView
    }()

    lazy var sendView: SendEmailView = {
        let sendView = SendEmailView(frame: self.view.bounds)
        return sendView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(twoTicketView)
        twoTicketView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.twoTicketView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            getListInfo()
        })
        //加载更多
        self.twoTicketView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getListInfo()
        })
        //点击打开发票
        twoTicketView.linkBlock = { [weak self] model in
            self?.linkBlock?(model)
        }
        
        twoTicketView.sendBlock =  { [weak self] model in
            let alertVc = TYAlertController(alert: self?.sendView, preferredStyle: .actionSheet)
            self?.present(alertVc!, animated: true)
            self?.sendView.model = model
            self?.sendView.cblock = {
                self?.dismiss(animated: true)
            }
            self?.sendView.sblock = {
                self?.sendEmailInfo(form: model)
            }
        }
        
    }
    
}

extension TwoTicketViewController {
    
    //发送邮箱
    func sendEmailInfo(form model: rowsModel) {
        let man = RequestManager()
        let dict = ["dataid": model.dataid ?? "",
                    "mailbox": self.sendView.tf.text ?? ""]
        man.requestAPI(params: dict,
                       pageUrl: "operation/invoiceRecord/selectInvoiceMailbox",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "发送成功")
                    self?.dismiss(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取列表信息
    func getListInfo() {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/invoiceRecord/selecinvoiceriseRecord",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            self.twoTicketView.tableView.mj_header?.endRefreshing()
            self.twoTicketView.tableView.mj_footer?.endRefreshing()
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
                    self.twoTicketView.modelArray.accept(allArray)
                    if self.allArray.count != total {
                        self.twoTicketView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.twoTicketView.tableView.mj_footer?.isHidden = true
                    }
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.twoTicketView)
                        
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
