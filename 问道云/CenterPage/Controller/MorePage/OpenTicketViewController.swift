//
//  OpenTicketViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/19.
//  选择开票页面普票还是专票

import UIKit
import RxRelay

class OpenTicketViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "开票信息"
        return headView
    }()
    
    lazy var openTicketView: OpenTicketView = {
        let openTicketView = OpenTicketView()
        return openTicketView
    }()
    
    //价格
    var model = BehaviorRelay<rowsModel?>(value: nil)
    //抬头
    var rowsModel = BehaviorRelay<rowsModel?>(value: nil)
    
    var unitname: String?//名称
    var taxpayernumber: String?//税号
    var checktakermailbox: String?//邮箱
    var registeraddress: String?//地址
    var registerphone: String?//注册电话
    var bankfullname: String?//开户银行
    var bankname: String?//银行账号
    var invoicetype: String?//发票类型
    var checktakerphone: String?//联系人电话
    var invoiceamount: String?//发票金额
    var invoicecontent: String?//开票内容
    var paynumber: String?//支付单号
    var customernumber: String?//客户单号
    var recipients: String?//收件人

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(openTicketView)
        openTicketView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        openTicketView.model1.accept(model.value)
        openTicketView.model2.accept(rowsModel.value)
        openTicketView.tableView.reloadData()
        
        openTicketView.zero
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("发票类型======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.one
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("单位名称======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.two
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("税号======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.three
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("地址======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.four
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("银行======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.five
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("账号======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.six
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("电话======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.seven
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("联系电话======\(str)")
        }).disposed(by: disposeBag)
        openTicketView.eight
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] str in
            print("接收邮箱======\(str)")
        }).disposed(by: disposeBag)
    }

}
