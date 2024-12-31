//
//  UserAllOrderSController.swift
//  问道云
//
//  Created by 何康 on 2024/12/5.
//  订单页面

import UIKit
import MJRefresh
import RxRelay
import DropMenuBar

class UserAllOrderSController: WDBaseViewController {
    
    var pageIndex: Int = 1
    
    var combotypenumber: Int = 0//下拉订单类型
    
    var orderstate: String = ""//下拉订单状态
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var allArray: [rowsModel] = []//加载更多
    
    var listArray = BehaviorRelay<[rowsModel]?>(value: nil)//下拉类型数据
    
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
        
        addHeadView(from: headView)
        view.addSubview(orderView)
        orderView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        //添加下拉刷新
        self.orderView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getOrderInfo(form: combotypenumber, pageNum: 1, orderstate: orderstate)
        })
        //加载更多
        self.orderView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getOrderInfo(form: combotypenumber, pageNum: pageIndex, orderstate: orderstate)
        })
        self.headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let ticketVc = MyTicketViewController()
            ticketVc.model.accept(self?.model.value)
            self?.navigationController?.pushViewController(ticketVc, animated: true)
        }).disposed(by: disposeBag)
        //获取订单状态
        getCombotype()
        //获取订单信息
        getOrderInfo(form: 0, pageNum: pageIndex, orderstate: orderstate)
        //添加下拉筛选
        let leixing1 = MenuAction(title: "订单类型", style: .typeList)!
        listArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            if let self = self, let modelArray = modelArray {
                let array = self.getListType(from: modelArray)
                leixing1.listDataSource = array
            }
        }).disposed(by: disposeBag)
        leixing1.didSelectedMenuResult = { [weak self] index, model, granted in
            guard let self = self else { return }
            combotypenumber = Int(model?.currentID ?? "0") ?? 0
            getOrderInfo(form: combotypenumber, pageNum: 1, orderstate: orderstate)
        }
        let leixing2 = MenuAction(title: "订单状态", style: .typeList)!
        let orderTypeArray = getListOrderType(from: true)
        leixing2.listDataSource = orderTypeArray
        leixing2.didSelectedMenuResult = { [weak self] index, model, granted in
            guard let self = self else { return }
            orderstate = model?.currentID ?? ""
            getOrderInfo(form: combotypenumber, pageNum: 1, orderstate: orderstate)
        }
        
        let menuView = DropMenuBar(action: [leixing1, leixing2])!
        self.orderView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(41.5)
        }
        
        //苹果支付,刷新订单列表数据
        orderView.block = { [weak self] model in
            guard let self = self else { return }
            let storeID = String(model.combonumber ?? 0)
            self.toApplePay(form: storeID, orderNumberID: model.ordernumber ?? "") {
                self.getOrderInfo(form: self.combotypenumber, pageNum: 1, orderstate: self.orderstate)
            }
        }
        
    }

}

extension UserAllOrderSController {
    
    //数据请求
    func getOrderInfo(form combotypenumber: Int, pageNum: Int, orderstate: String) {
        let man = RequestManager()
        let customernumber = model.value?.customernumber ?? ""
        let dict = ["customernumber": customernumber, "combotypenumber": combotypenumber, "orderstate": orderstate, "pageNum": pageNum, "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict, pageUrl: myorder_info, method: .get) { [weak self] result in
            guard let self = self else { return }
            self.orderView.tableView.mj_header?.endRefreshing()
            self.orderView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data, let total = model.total {
                    if pageNum == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.orderView)
                    }
                    self.orderView.modelArray.accept(self.allArray)
                    if self.allArray.count != total {
                        self.orderView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.orderView.tableView.mj_footer?.isHidden = true
                    }
                }else {
                    self.addNodataView(from: self.orderView)
                    self.orderView.tableView.mj_footer?.isHidden = true
                }
                break
            case .failure(_):
                self.addNoNetView(from: self.orderView)
                self.noNetView.refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
                    //获取订单状态
                    self?.getCombotype()
                    //获取订单信息
                    self?.getOrderInfo(form: 0, pageNum: 1, orderstate: orderstate)
                }).disposed(by: disposeBag)
                self.orderView.tableView.mj_footer?.isHidden = true
                break
            }
        }
    }
    
    func getCombotype() {
        let dict = [String: Any]()
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: combotype_list, method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.rows, rows.count > 0 {
                    self.listArray.accept(rows)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
