//
//  OpenTicketView.swift
//  问道云
//
//  Created by Andrew on 2024/12/19.
//  开票页面

import UIKit
import RxRelay

struct OpenTicketModel {
    var name: String//名字
    var Required: Bool = false//必填
    var placeHolder: String
}

class OneCell: BaseViewCell {
    
    var zero = BehaviorRelay<String>(value: "1")
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.layer.borderWidth = 1
        oneBtn.layer.cornerRadius = 2.5
        oneBtn.clipsToBounds = true
        oneBtn.setTitle("增值税普通发票", for: .normal)
        oneBtn.titleLabel?.font = .mediumFontOfSize(size: 13)
        oneBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        oneBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        oneBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.layer.borderWidth = 1
        twoBtn.layer.cornerRadius = 2.5
        twoBtn.clipsToBounds = true
        twoBtn.setTitle("增值税专用发票", for: .normal)
        twoBtn.titleLabel?.font = .mediumFontOfSize(size: 13)
        twoBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        twoBtn.backgroundColor = UIColor.init(cssStr: "#F7F7F7")
        twoBtn.layer.borderColor = UIColor.clear.cgColor
        return twoBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.4)
            make.size.equalTo(CGSize(width: 114, height: 28))
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneBtn.snp.right).offset(12.5)
            make.size.equalTo(CGSize(width: 114, height: 28))
            make.bottom.equalToSuperview().offset(-17.5)
        }
        updateButtonSelection(isOneBtnSelected: true)
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.zero.accept("1")
            self?.updateButtonSelection(isOneBtnSelected: true)
        }).disposed(by: disposeBag)
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.zero.accept("2")
            self?.updateButtonSelection(isOneBtnSelected: false)
        }).disposed(by: disposeBag)
        
    }
    
    private func updateButtonSelection(isOneBtnSelected: Bool) {
        if isOneBtnSelected {
            oneBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
            oneBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
            oneBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
            
            twoBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
            twoBtn.backgroundColor = UIColor.init(cssStr: "#F7F7F7")
            twoBtn.layer.borderColor = UIColor.clear.cgColor
        } else {
            oneBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
            oneBtn.backgroundColor = UIColor.init(cssStr: "#F7F7F7")
            oneBtn.layer.borderColor = UIColor.clear.cgColor
            
            twoBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
            twoBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
            twoBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TwoCell: BaseViewCell {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#F55B5B")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 15)
        return mlabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mlabel)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14.5)
            make.top.equalToSuperview().offset(14.5)
            make.height.equalTo(21)
            make.bottom.equalToSuperview().offset(-18.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ThreeCell: BaseViewCell {
    
    lazy var statlabel: UILabel = {
        let statlabel = UILabel()
        statlabel.text = "*"
        statlabel.textColor = UIColor.init(cssStr: "#F55B5B")
        statlabel.textAlignment = .left
        statlabel.font = .mediumFontOfSize(size: 13)
        return statlabel
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#D5D5D5")
        return lineView
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.font = .mediumFontOfSize(size: 13)
        phoneTx.textAlignment = .right
        phoneTx.textColor = UIColor.init(cssStr: "#333333")
        return phoneTx
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(statlabel)
        contentView.addSubview(mlabel)
        contentView.addSubview(lineView)
        contentView.addSubview(phoneTx)
        statlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(18.5)
        }
        mlabel.snp.makeConstraints { make in
            make.left.equalTo(statlabel.snp.right).offset(2.5)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(18.5)
            make.width.equalTo(85.pix())
            make.bottom.equalToSuperview().offset(-15.5)
        }
        phoneTx.snp.makeConstraints { make in
            make.left.equalTo(mlabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(49)
            make.width.equalTo(SCREEN_WIDTH - 135)
        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OpenTicketView: BaseView {
    
    var model1 = BehaviorRelay<rowsModel?>(value: nil)
    
    var model2 = BehaviorRelay<rowsModel?>(value: nil)
    
    let titles: [String] = ["发票类型", "开票金额", "发票抬头", "发票内容", "收票人信息"]
    
    let threeTitles: [String] = ["单位名称", "纳税人识别号", "注册地址", "开户银行", "银行账户", "注册电话"]
    let threePlaceTitles: [String] = ["必填", "必填", "必填", "必填", "必填", "选填"]
    
    let fourTitles: [String] = ["联系人电话", "接收邮箱"]
    let fourPlaceTitles: [String] = ["手机号码(选填)", "接收电子邮箱(必填)"]
    
    var invoiceTitleArray: [String] = []
    var zero = BehaviorRelay<String>(value: "1")
    var one = BehaviorRelay<String>(value: "")
    var two = BehaviorRelay<String>(value: "")
    var three = BehaviorRelay<String>(value: "")
    var four = BehaviorRelay<String>(value: "")
    var five = BehaviorRelay<String>(value: "")
    var six = BehaviorRelay<String>(value: "")
    var seven = BehaviorRelay<String>(value: "")
    var eight = BehaviorRelay<String>(value: "")
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F4F7FB")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OneCell.self, forCellReuseIdentifier: "OneCell")
        tableView.register(TwoCell.self, forCellReuseIdentifier: "TwoCell")
        tableView.register(ThreeCell.self, forCellReuseIdentifier: "ThreeCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("提交", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        sureBtn.backgroundColor = .init(cssStr: "#547AFF")
        sureBtn.layer.cornerRadius = 3
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sureBtn)
        addSubview(tableView)
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 285, height: 45))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(sureBtn.snp.top).offset(-10)
        }
        model2.subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            invoiceTitleArray.append(model.companyname ?? "")
            invoiceTitleArray.append(model.companynumber ?? "")
            invoiceTitleArray.append(model.address ?? "")
            invoiceTitleArray.append(model.bankname ?? "")
            invoiceTitleArray.append(model.bankfullname ?? "")
            invoiceTitleArray.append(model.contact ?? "")
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.setDataSource(self).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OpenTicketView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 3 {
            return 1
        }else if section == 2 {
            return 6
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OneCell", for: indexPath) as? OneCell {
                cell.selectionStyle = .none
                cell.zero.asObservable().subscribe(onNext: { [weak self] str in
                    self?.zero.accept(str)
                }).disposed(by: disposeBag)
                return cell
            }
            
        }else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCell", for: indexPath) as? TwoCell {
                cell.selectionStyle = .none
                model1.subscribe(onNext: { [weak self] model in
                    guard let self = self, let model = model else { return }
                    let price = String(format: "%.2f", model.pirce ?? 0.00)
                    cell.mlabel.text = "¥\(price)"
                }).disposed(by: disposeBag)
                return cell
            }
        }else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeCell", for: indexPath) as? ThreeCell {
                let row = indexPath.row
                cell.mlabel.text = threeTitles[row]
                let attrString = NSMutableAttributedString(string: threePlaceTitles[row], attributes: [
                    .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
                    .font: UIFont.regularFontOfSize(size: 13)
                ])
                cell.phoneTx.attributedPlaceholder = attrString
                cell.phoneTx.text = invoiceTitleArray[row]
                if row == 5 {
                    cell.statlabel.isHidden = true
                }else {
                    cell.statlabel.isHidden = false
                }
                let observables = [self.one, self.two, self.three, self.four, self.five, self.six]
                if row >= 0 && row < observables.count {
                    cell.phoneTx.rx.text.orEmpty
                        .subscribe(onNext: { text in
                            observables[row].accept(text)
                        })
                        .disposed(by: disposeBag)
                }
                cell.selectionStyle = .none
                return cell
            }
        }else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCell", for: indexPath) as? TwoCell {
                cell.selectionStyle = .none
                model1.subscribe(onNext: { [weak self] model in
                    guard let self = self, let model = model else { return }
                    cell.mlabel.text = model.comboname ?? ""
                    cell.mlabel.textColor = UIColor.init(cssStr: "#333333")
                }).disposed(by: disposeBag)
                return cell
            }
        }else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ThreeCell", for: indexPath) as? ThreeCell {
                let row = indexPath.row
                cell.mlabel.text = fourTitles[row]
                let attrString = NSMutableAttributedString(string: fourPlaceTitles[row], attributes: [
                    .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
                    .font: UIFont.regularFontOfSize(size: 13)
                ])
                cell.phoneTx.attributedPlaceholder = attrString
                if row == 1 {
                    cell.statlabel.isHidden = false
                    cell.phoneTx.keyboardType = .default
                }else {
                    cell.statlabel.isHidden = true
                    cell.phoneTx.keyboardType = .numberPad
                }
                let observables = [self.seven, self.eight]
                if row >= 0 && row < observables.count {
                    cell.phoneTx.rx.text.orEmpty
                        .subscribe(onNext: { text in
                            observables[row].accept(text)
                        })
                        .disposed(by: disposeBag)
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F4F7FB")
        let label = UILabel()
        label.text = titles[section]
        label.font = .regularFontOfSize(size: 12)
        label.textColor = .init(cssStr: "#333333")
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.bottom.right.equalToSuperview()
        }
        return headView
    }
    
}
