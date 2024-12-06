//
//  UserAllOrderSController.swift
//  问道云
//
//  Created by 何康 on 2024/12/5.
//  订单页面

import UIKit
import MJRefresh
import RxRelay

class UserAllOrderSController: WDBaseViewController {
    
    var pageIndex: Int = 1
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "我的订单"
        headView.oneBtn.setImage(UIImage(named: "kaipiaoimage"), for: .normal)
        return headView
    }()
    
    lazy var orderView: UserAllOrderView = {
        let orderView = UserAllOrderView()
        return orderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        
        view.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        self.orderView.tableView.mj_header = MJRefreshHeader(refreshingBlock: {
            
        })
        
        self.headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let invoVc = MyInvoicesViewController()
            invoVc.model.accept(self?.model.value)
            self?.navigationController?.pushViewController(invoVc, animated: true)
        }).disposed(by: disposeBag)
        
        //获取订单信息
        getOrderInfo()
    }

}

extension UserAllOrderSController {
    
    func getOrderInfo() {
        let man = RequestManager()
        let customernumber = model.value?.customernumber ?? ""
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict, pageUrl: myorder_info, method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data, let total = model.total, total != 0 {
                    self.emptyView.removeFromSuperview()
                    self.orderView.model.accept(model)
                }else {
                    self.addNodataView(form: self.orderView)
                }
                break
            case .failure(_):
                self.addNodataView(form: self.orderView)
                break
            }
        }
    }
    
}
