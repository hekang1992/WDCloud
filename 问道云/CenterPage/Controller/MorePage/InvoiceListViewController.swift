//
//  InvoiceListViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  发票抬头列表

import UIKit
import RxRelay

class InvoiceListViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "发票抬头"
        return headView
    }()
    
    lazy var listView: InvoiceListView = {
        let listView = InvoiceListView()
        return listView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        listView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let addVc = AddInvoiceViewController()
            addVc.model.accept(self.model.value)
            self.navigationController?.pushViewController(addVc, animated: true)
        }).disposed(by: disposeBag)
        
        listView.deleteBlock = { [weak self] model in
            ShowAlertManager.showAlert(title: "提示", message: "是否确认删除?", confirmAction: {
                self?.deleteInfo(from: model)
            })
        }
        
        listView.pasteBlock = { model in
            let name = "企业名称: \(model.companyname ?? "")"
            let shuihao = "税号: \(model.companynumber ?? "")"
            let dizhi = "地址: \(model.address ?? "")"
            let phone = "电话号码: \(model.contact ?? "")"
            let kaihu = "开户银行: \(model.bankname ?? "")"
            let bank = "银行账户: \(model.bankfullname ?? "")"
            UIPasteboard.general.string = "\(name)\n\(shuihao)\n\(dizhi)\n\(phone)\n\(kaihu)\n\(bank)"
            ToastViewConfig.showToast(message: "复制成功!")
        }
        
        listView.shareBlock = { model in
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInvoListInfo()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InvoiceListViewController {
    
    //获取发票列表信息
    func getInvoListInfo() {
        let customernumber = model.value?.customernumber ?? ""
        let dict = ["customernumber": customernumber]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: invoiceriseit_selecinvoicerise, method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.noNetView.removeFromSuperview()
                    self.listView.model.accept(model)
                }
                break
            case .failure(_):
                self.addNoNetView(form: self.listView)
                self.noNetView.refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
                    self?.getInvoListInfo()
                }).disposed(by: disposeBag)
                break
            }
        }
    }
    
    func deleteInfo(from model: rowsModel) {
        let dict = ["dataid": model.dataid ?? ""]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/invoiceriseit/deleteinvoicerise", method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.getInvoListInfo()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
