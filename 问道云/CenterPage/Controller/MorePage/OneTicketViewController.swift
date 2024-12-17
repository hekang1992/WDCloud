//
//  OneTicketViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/17.
//  开票列表1

import UIKit
import RxRelay

class OneTicketViewController: WDBaseViewController {
    
    var pageNum = 1
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var oneTicketView: OneTicketView = {
        let oneTicketView = OneTicketView()
        return oneTicketView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getListInfo()
        
        view.addSubview(oneTicketView)
        oneTicketView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension OneTicketViewController {
    
    //获取列表信息
    func getListInfo() {
        let man = RequestManager()
        let customernumber = model.value?.customernumber ?? ""
        let dict = ["customernumber": customernumber, "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict, pageUrl: "/operation/invoiceRecord/selecinvoiceriseRecord", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let rows = success.data?.rows {
                    self?.pageNum += 1
                    self?.oneTicketView.modelArray.accept(rows)
                }
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}
