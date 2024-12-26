//
//  AddInvoiceViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/16.
//  添加发票抬头

import UIKit
import RxRelay
import RxSwift
import RxGesture

class AddInvoiceViewController: WDBaseViewController {
    
    lazy var model1 = DescModel(title: "名称", descTitle: "单位名称（必填）")
    lazy var model2 = DescModel(title: "税号", descTitle: "15-20位数字和字母（必填）")
    lazy var model3 = DescModel(title: "地址", descTitle: "单位地址信息")
    lazy var model4 = DescModel(title: "电话号码", descTitle: "电话号码")
    lazy var model5 = DescModel(title: "开户银行", descTitle: "开户银行名称")
    lazy var model6 = DescModel(title: "银行账号", descTitle: "银行账户号码")
    
    lazy var array: [DescModel] = [model1, model2, model3, model4, model5, model6]
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    //是否成为默认邮箱
    var isSure = BehaviorRelay<String>(value: "0")
    
    //搜索的文字
    var searchStr = BehaviorRelay<String>(value: "")
    
    //返回的搜索数组
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "添加发票抬头"
        return headView
    }()
    
    lazy var addView: AddInvoiceView = {
        let addView = AddInvoiceView()
        return addView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.layer.cornerRadius = 5
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(SearchInvoiceCell.self, forCellReuseIdentifier: "SearchInvoiceCell")
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(addView)
        addView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5.5)
            make.left.right.bottom.equalToSuperview()
        }
        self.addView.modelArray.accept(array)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(300)
        }
        
        addView.block = { row, model, cell in
            if row == 0 {
                cell.enterTx
                    .rx
                    .controlEvent(.editingChanged)
                    .withLatestFrom(cell.enterTx.rx.text.orEmpty)
                    .distinctUntilChanged()
                    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { text in
                        self.searchStr.accept(text)
                    }).disposed(by: self.disposeBag)
            }else {
                return
            }
            
        }
        
        self.searchStr
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                self?.searchInfo(from: text)
        }).disposed(by: disposeBag)
        
        addMoRenInfo()
        
        //搜索
        modelArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "SearchInvoiceCell", cellType: SearchInvoiceCell.self)) { row, model, cell in
            cell.model.accept(model)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(rowsModel.self).subscribe(onNext: { [weak self] model in
            self?.tableView.isHidden = true
            self?.addView.modelArray.value[0].text.accept(model.entityName ?? "")
            self?.addView.modelArray.value[1].text.accept(model.usCreditCode ?? "")
            self?.addView.modelArray.value[2].text.accept(model.registerAddress ?? "")
            self?.addView.modelArray.value[3].text.accept(model.phone ?? "")
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        //保存发票抬头
        addView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.addInfo(from: self?.addView.modelArray.value ?? [])
        }).disposed(by: disposeBag)
        
    }
    
}

extension AddInvoiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    //是否设置默认
    func addMoRenInfo() {
        self.addView.checkButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.addView.checkButton.isSelected.toggle()
            self.isSure.accept(self.addView.checkButton.isSelected ? "1" : "0")
        }).disposed(by: disposeBag)
    }
    
    //搜索公司税务信息
    func searchInfo(from searchStr: String) {
        let dict = ["keywords": searchStr]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/firminfo/entity/search", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let data = success.datas, data.count > 0 {
                    self?.tableView.isHidden = false
                    self?.modelArray.accept(data)
                }else {
                    self?.tableView.isHidden = true
                    self?.modelArray.accept([])
                }
                break
            case .failure(_):
                self?.tableView.isHidden = true
                self?.modelArray.accept([])
                break
            }
        }
    }
    
    //添加发票抬头
    func addInfo(from modelArray: [DescModel]) {
        let companyname = modelArray[0].text.value
        let companynumber = modelArray[1].text.value
        let address = modelArray[2].text.value
        let contactnumber = modelArray[3].text.value
        let bankname = modelArray[4].text.value
        let bankfullname = modelArray[5].text.value
        let defaultstate = self.isSure.value
        let customernumber = model.value?.customernumber ?? ""
        let dict = ["companyname": companyname,
                    "companynumber": companynumber,
                    "address": address,
                    "contactnumber": contactnumber,
                    "bankname": bankname,
                    "bankfullname": bankfullname,
                    "defaultstate": defaultstate,
                    "contact": customernumber] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/invoiceriseit/add", method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.navigationController?.popViewController(animated: true)
                    ToastViewConfig.showToast(message: "添加成功!")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
