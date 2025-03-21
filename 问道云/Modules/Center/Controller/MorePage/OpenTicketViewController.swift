//
//  OpenTicketViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/19.
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
    var invoiceamount: Double?//发票金额
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
        
        //发票类型
        openTicketView.zero
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] invoicetype in
                self?.invoicetype = invoicetype
        }).disposed(by: disposeBag)
        
        //单位名称
        openTicketView.one
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] unitname in
                self?.unitname = unitname
        }).disposed(by: disposeBag)
        
        //税号
        openTicketView.two
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] taxpayernumber in
                self?.taxpayernumber = taxpayernumber
        }).disposed(by: disposeBag)
        
        //地址
        openTicketView.three
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] registeraddress in
                self?.registeraddress = registeraddress
        }).disposed(by: disposeBag)
        
        //银行
        openTicketView.four
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] bankfullname in
                self?.bankfullname = bankfullname
        }).disposed(by: disposeBag)
        
        //账号
        openTicketView.five
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] bankname in
                self?.bankname = bankname
        }).disposed(by: disposeBag)
        
        //电话
        openTicketView.six
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] registerphone in
                self?.registerphone = registerphone
        }).disposed(by: disposeBag)
        
        //联系电话
        openTicketView.seven
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] checktakerphone in
                self?.checktakerphone = checktakerphone
        }).disposed(by: disposeBag)
        
        //接收邮箱
        openTicketView.eight
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] checktakermailbox in
                self?.checktakermailbox = checktakermailbox
        }).disposed(by: disposeBag)
        
        
        openTicketView.sureBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
            self?.toSaveTicket()
        }).disposed(by: disposeBag)
        
    }
}

extension OpenTicketViewController {
    
    //提交开票信息
    private func toSaveTicket() {
        let man = RequestManager()
        let dict = ["unitname": unitname ?? "",
                    "taxpayernumber": taxpayernumber ?? "",
                    "checktakermailbox": checktakermailbox ?? "",
                    "registeraddress": registeraddress ?? "",
                    "registerphone": registerphone ?? "",
                    "bankfullname": bankfullname ?? "",
                    "bankname": bankname ?? "",
                    "invType": invoicetype ?? "",
                    "checktakerphone": checktakerphone ?? "",
                    "invoiceamount": model.value?.pirce ?? 0.00,
                    "invoicecontent": model.value?.comboname ?? "",
                    "paynumber": model.value?.paynumber ?? "",
                    "recipients": ""] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/invoiceRecord/addinvoiceriseRecord",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.navigationController?.popViewController(animated: true)
                } 
                ToastViewConfig.showToast(message: success.msg ?? "")
                break
            case .failure(_):
                break
            }
        }
        
    }
    
}
