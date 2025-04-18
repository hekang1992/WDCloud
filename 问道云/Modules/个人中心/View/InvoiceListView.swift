//
//  InvoiceListView.swift
//  问道云
//
//  Created by Andrew on 2024/12/16.
//  添加发票

import UIKit
import RxRelay

class InvoiceNormalListCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        numLabel.font = .mediumFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "erweimaimage")
        return ctImageView
    }()
    
    lazy var morenImageView: UIImageView = {
        let morenImageView = UIImageView()
        morenImageView.isHidden = true
        morenImageView.image = UIImage(named: "morenimage")
        return morenImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(ctImageView)
        contentView.addSubview(morenImageView)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(11.5)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-22.5)
        }
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bgView.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        morenImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 41, height: 35))
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.companyname ?? ""
            numLabel.text = "税号:  \(model.companynumber ?? "")"
            if model.defaultstate == "1" {
                self.morenImageView.isHidden = false
            }else {
                self.morenImageView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class InvoiceSelectListCell: BaseViewCell {
    
    var deleteBlock: ((rowsModel) -> Void)?
    
    var pasteBlock: (((rowsModel)) -> Void)?
    
    var shareBlock: (((rowsModel)) -> Void)?
    
    var isShowType = BehaviorRelay<String>(value: "0")
    
    //选择开票
    var toTicketBlock: (((rowsModel)) -> Void)?
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#547AFF")
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "erweimaimage")
        return ctImageView
    }()
    
    lazy var morenImageView: UIImageView = {
        let morenImageView = UIImageView()
        morenImageView.isHidden = true
        morenImageView.image = UIImage(named: "morenimage")
        return morenImageView
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#999999")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 13)
        onelabel.text = "税号:"
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#999999")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 13)
        twolabel.text = "地址:"
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.textColor = UIColor.init(cssStr: "#999999")
        threelabel.textAlignment = .left
        threelabel.font = .regularFontOfSize(size: 13)
        threelabel.text = "开户银行:"
        return threelabel
    }()
    
    lazy var fourlabel: UILabel = {
        let fourlabel = UILabel()
        fourlabel.textColor = UIColor.init(cssStr: "#999999")
        fourlabel.textAlignment = .left
        fourlabel.font = .regularFontOfSize(size: 13)
        fourlabel.text = "银行账号:"
        return fourlabel
    }()
    
    lazy var fivelabel: UILabel = {
        let fivelabel = UILabel()
        fivelabel.textColor = UIColor.init(cssStr: "#999999")
        fivelabel.textAlignment = .left
        fivelabel.font = .regularFontOfSize(size: 13)
        fivelabel.text = "电话号码:"
        return fivelabel
    }()
    
    lazy var label1: UILabel = {
        let label1 = UILabel()
        label1.textColor = UIColor.init(cssStr: "#333333")
        label1.textAlignment = .left
        label1.text = "--"
        label1.font = .regularFontOfSize(size: 13)
        return label1
    }()
    
    lazy var label2: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor.init(cssStr: "#333333")
        label2.textAlignment = .left
        label2.text = "--"
        label2.font = .regularFontOfSize(size: 13)
        label2.numberOfLines = 0
        return label2
    }()
    
    lazy var label3: UILabel = {
        let label3 = UILabel()
        label3.textColor = UIColor.init(cssStr: "#333333")
        label3.textAlignment = .left
        label3.text = "--"
        label3.font = .regularFontOfSize(size: 13)
        label3.numberOfLines = 0
        return label3
    }()
    
    lazy var label4: UILabel = {
        let label4 = UILabel()
        label4.textColor = UIColor.init(cssStr: "#333333")
        label4.textAlignment = .left
        label4.text = "--"
        label4.font = .regularFontOfSize(size: 13)
        return label4
    }()
    
    lazy var label5: UILabel = {
        let label5 = UILabel()
        label5.textColor = UIColor.init(cssStr: "#333333")
        label5.textAlignment = .left
        label5.text = "--"
        label5.font = .regularFontOfSize(size: 13)
        return label5
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#E7E7E7")
        return lineView
    }()
    
    lazy var itemImageView: UIImageView = {
        let itemImageView = UIImageView()
        itemImageView.isUserInteractionEnabled = true
        itemImageView.image = UIImage(named: "itemImage")
        return itemImageView
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        return deleteBtn
    }()
    
    lazy var pasteBtn: UIButton = {
        let pasteBtn = UIButton(type: .custom)
        return pasteBtn
    }()
    
    lazy var shareBtn: UIButton = {
        let shareBtn = UIButton(type: .custom)
        return shareBtn
    }()
    
    lazy var ticketBtn: UIButton = {
        let ticketBtn = UIButton(type: .custom)
        ticketBtn.setImage(UIImage(named: "kaipiaoimgebtn"), for: .normal)
        return ticketBtn
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#F4F7FB")
        return lineView1
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(onelabel)
        contentView.addSubview(twolabel)
        contentView.addSubview(threelabel)
        contentView.addSubview(fourlabel)
        contentView.addSubview(fivelabel)
        contentView.addSubview(ctImageView)
        contentView.addSubview(morenImageView)
        contentView.addSubview(label1)
        contentView.addSubview(label2)
        contentView.addSubview(label3)
        contentView.addSubview(label4)
        contentView.addSubview(label5)
        contentView.addSubview(lineView)
        contentView.addSubview(itemImageView)
        itemImageView.addSubview(deleteBtn)
        itemImageView.addSubview(pasteBtn)
        itemImageView.addSubview(shareBtn)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(22.5)
            make.left.equalToSuperview().offset(19)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        onelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(56.5)
            make.top.equalTo(ctImageView.snp.bottom).offset(30)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        twolabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(56.5)
            make.top.equalTo(onelabel.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        
        fivelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(56.5)
            make.top.equalTo(fourlabel.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        label1.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(onelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(twolabel.snp.top)
            make.left.equalTo(twolabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        threelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(56.5)
            make.top.equalTo(label2.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        label3.snp.makeConstraints { make in
            make.top.equalTo(threelabel.snp.top)
            make.left.equalTo(threelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        fourlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(56.5)
            make.top.equalTo(label3.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        label4.snp.makeConstraints { make in
            make.centerY.equalTo(fourlabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(fourlabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label5.snp.makeConstraints { make in
            make.centerY.equalTo(fivelabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(fivelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        morenImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 41, height: 35))
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(0.5)
            make.top.equalTo(label5.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-50)
        }
        itemImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 343, height: 36))
        }
        deleteBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(343 * 0.33)
        }
        shareBtn.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(343 * 0.33)
        }
        pasteBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(deleteBtn.snp.right)
            make.right.equalTo(shareBtn.snp.left)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.companyname ?? ""
            ctImageView.image = .qrImageForString(qrString: model.companynumber ?? "")
            label1.text = (model.companynumber ?? "").isEmpty ? "--" : model.companynumber ?? ""
            label2.text = (model.address ?? "").isEmpty ? "--" : model.address ?? ""
            label3.text = (model.bankname ?? "").isEmpty ? "--" : model.bankname ?? ""
            label4.text = (model.bankfullname ?? "").isEmpty ? "--" : model.bankfullname ?? ""
            label5.text = (model.contact ?? "").isEmpty ? "--" : model.contact ?? ""
            if model.defaultstate == "1" {
                self.morenImageView.isHidden = false
            }else {
                self.morenImageView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        isShowType.asObservable().subscribe(onNext: { [weak self] isShowType in
            guard let self = self else { return }
            if isShowType == "1" {
                ticketBtn.isHidden = false
                lineView1.isHidden = false
                contentView.addSubview(lineView1)
                contentView.addSubview(ticketBtn)
                lineView1.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.left.equalToSuperview()
                    make.height.equalTo(1.5)
                    make.top.equalTo(self.itemImageView.snp.bottom).offset(1.5)
                }
                lineView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-105)
                }
                ticketBtn.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.size.equalTo(CGSize(width: 142, height: 61))
                    make.top.equalTo(self.itemImageView.snp.bottom).offset(7.5)
                }
            }else {
                ticketBtn.isHidden = true
                lineView1.isHidden = true
                lineView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-50)
                }
            }
        }).disposed(by: disposeBag)
        
        //删除
        deleteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.deleteBlock?(model)
        }).disposed(by: disposeBag)
        //复制
        pasteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.pasteBlock?(model)
        }).disposed(by: disposeBag)
        //分享
        shareBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.shareBlock?(model)
        }).disposed(by: disposeBag)
        
        ticketBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.toTicketBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class InvoiceListView: BaseView {
    
    var block: (() -> Void)?
    
    //是否是点击
    var isClickType = BehaviorRelay<Bool>(value: false)
    //删除
    var deleteBlock: ((rowsModel) -> Void)?
    
    //复制
    var pasteBlock: (((rowsModel)) -> Void)?
    
    //分享
    var shareBlock: (((rowsModel)) -> Void)?
    
    var toTicketBlock: (((rowsModel)) -> Void)?
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    //是否展示开票按钮
    var isShowType = BehaviorRelay<String?>(value: nil)
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "fapiaowushuju")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 15)
        mlabel.textColor = UIColor.init(cssStr: "#999999")
        mlabel.textAlignment = .center
        mlabel.text = "暂无相关数据"
        return mlabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("添加发票抬头", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 4
        return nextBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F4F7FB")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(InvoiceNormalListCell.self, forCellReuseIdentifier: "InvoiceNormalListCell")
        tableView.register(InvoiceSelectListCell.self, forCellReuseIdentifier: "InvoiceSelectListCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(mlabel)
        addSubview(nextBtn)
        addSubview(tableView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(8.5)
            make.height.equalTo(21)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(27.5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-23)
        }
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            if model?.total != 0 {
                self?.hideNoDataView()
                self?.tableView.isHidden = false
            }else {
                self?.addNoDataView()
                self?.tableView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        model
            .asObservable()
            .compactMap { $0?.rows }
            .bind(to: tableView.rx.items) { [weak self] tableView, index, model in
                guard let self = self else { return UITableViewCell() }
                let isClick = self.isClickType.value
                if !isClick {
                    if model.defaultstate == "1" {
                        model.isChecked = true
                    } else {
                        model.isChecked = false
                    }
                }
                if model.isChecked {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceSelectListCell", for: IndexPath(row: index, section: 0)) as? InvoiceSelectListCell  {
                        cell.backgroundColor = .clear
                        cell.selectionStyle = .none
                        cell.model.accept(model)
                        cell.deleteBlock = { [weak self] model in
                            self?.deleteBlock?(model)
                        }
                        cell.pasteBlock = { [weak self] model in
                            self?.pasteBlock?(model)
                        }
                        cell.shareBlock = { [weak self] model in
                            self?.shareBlock?(model)
                        }
                        cell.toTicketBlock = { [weak self] model in
                            self?.toTicketBlock?(model)
                        }
                        cell.isShowType.accept(self.isShowType.value ?? "0")
                        return cell
                    }
                }else {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceNormalListCell", for: IndexPath(row: index, section: 0)) as? InvoiceNormalListCell  {
                        cell.backgroundColor = .clear
                        cell.selectionStyle = .none
                        cell.model.accept(model)
                        return cell
                    }
                }
                return UITableViewCell()
            }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            // 获取 model 和 rows
            let model = self.model.value
            let rows = model?.rows ?? []
            // 重置所有 cell 的 `isChecked` 状态为折叠
            rows.forEach { row in
                row.isChecked = false // 所有项折叠
            }
            // 选择当前点击的 `cell`
            rows[indexPath.row].isChecked = true
            // 更新模型并通知更新
            model?.rows = rows
            self.isClickType.accept(true)
            self.model.accept(model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InvoiceListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#FFF1F1")
        let label = UILabel()
        label.text = "发票抬头仅用于开具发票，请勿用于转账等其他用途，谨防受骗"
        label.font = .regularFontOfSize(size: 12)
        label.textColor = .init(cssStr: "#F55B5B")
        label.textAlignment = .center
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return headView
    }
    
    private func hideNoDataView() {
        self.bgImageView.isHidden = true
        self.mlabel.isHidden = true
        self.nextBtn.isHidden = false
    }
    
    private func addNoDataView() {
        self.bgImageView.isHidden = false
        self.mlabel.isHidden = false
        self.nextBtn.isHidden = false
        //弹窗提示
        ShowAlertManager.showAlert(title: "提示",
                                   message: "您尚未填写发票抬头，无法开票",
                                   confirmTitle: "添加发票抬头",
                                   cancelTitle: "暂时放弃开票",
                                   confirmAction: { [weak self] in
            self?.block?()
        })
    }
    
}
