//
//  TwoTicketView.swift
//  问道云
//
//  Created by Andrew on 2024/12/18.
//

import UIKit
import RxRelay

class TwoTicketCell: BaseViewCell {
    
    var linkBlock: ((rowsModel) -> Void)?
    
    var rowsModel = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = .init(cssStr: "#9FA4AD")
        oneLabel.font = .mediumFontOfSize(size: 13)
        oneLabel.textAlignment = .left
        oneLabel.text = "抬头:"
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = .init(cssStr: "#9FA4AD")
        twoLabel.font = .mediumFontOfSize(size: 13)
        twoLabel.textAlignment = .left
        twoLabel.text = "税号:"
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textColor = .init(cssStr: "#9FA4AD")
        threeLabel.font = .mediumFontOfSize(size: 13)
        threeLabel.textAlignment = .left
        threeLabel.text = "开票时间:"
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textColor = .init(cssStr: "#9FA4AD")
        fourLabel.font = .mediumFontOfSize(size: 13)
        fourLabel.textAlignment = .left
        fourLabel.text = "开票金额:"
        return fourLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 5
        return whiteView
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        return typeImageView
    }()
    
    lazy var headLabel: UILabel = {
        let headLabel = UILabel()
        headLabel.textColor = .init(cssStr: "#333333")
        headLabel.font = .mediumFontOfSize(size: 13)
        headLabel.textAlignment = .left
        return headLabel
    }()
    
    lazy var taxNumLabel: UILabel = {
        let taxNumLabel = UILabel()
        taxNumLabel.textColor = .init(cssStr: "#333333")
        taxNumLabel.font = .mediumFontOfSize(size: 13)
        taxNumLabel.textAlignment = .left
        return taxNumLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#333333")
        timeLabel.font = .mediumFontOfSize(size: 13)
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = .init(cssStr: "#F55B5B")
        priceLabel.font = .mediumFontOfSize(size: 14)
        priceLabel.textAlignment = .left
        return priceLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#D5D5D5")
        return lineView
    }()
    
    lazy var openBtn: UIButton = {
        let openBtn = UIButton(type: .custom)
        openBtn.setTitle("查看发票", for: .normal)
        openBtn.layer.cornerRadius = 2.5
        openBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        openBtn.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        openBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        openBtn.isEnabled = false
        return openBtn
    }()
    
    lazy var againBtn: UIButton = {
        let againBtn = UIButton(type: .custom)
        againBtn.setTitle("申请重开发票", for: .normal)
        againBtn.layer.cornerRadius = 2.5
        againBtn.titleLabel?.font = .mediumFontOfSize(size: 13)
        againBtn.backgroundColor = UIColor.init(cssStr: "#3849F7")?.withAlphaComponent(0.1)
        againBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return againBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(whiteView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(oneLabel)
        contentView.addSubview(twoLabel)
        contentView.addSubview(threeLabel)
        contentView.addSubview(fourLabel)
        contentView.addSubview(headLabel)
        contentView.addSubview(taxNumLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(openBtn)
        contentView.addSubview(againBtn)
        whiteView.addSubview(typeImageView)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.pix())
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(22.5.pix())
        }
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(14.pix())
            make.height.equalTo(18.5)
            make.width.equalTo(30.pix())
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(oneLabel.snp.bottom).offset(6.pix())
            make.height.equalTo(18.5)
            make.width.equalTo(30.pix())
        }
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(twoLabel.snp.bottom).offset(6.pix())
            make.height.equalTo(18.5)
            make.width.equalTo(62.pix())
        }
        fourLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(threeLabel.snp.bottom).offset(6.pix())
            make.height.equalTo(18.5.pix())
            make.width.equalTo(62.pix())
        }
        headLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneLabel.snp.centerY)
            make.left.equalTo(oneLabel.snp.right).offset(8)
            make.height.equalTo(20.pix())
            make.right.equalToSuperview().offset(-20)
        }
        taxNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(twoLabel.snp.centerY)
            make.left.equalTo(twoLabel.snp.right).offset(8)
            make.height.equalTo(20.pix())
            make.right.equalToSuperview().offset(-20)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(threeLabel.snp.centerY)
            make.left.equalTo(threeLabel.snp.right).offset(6)
            make.height.equalTo(20.pix())
            make.right.equalToSuperview().offset(-20)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(fourLabel.snp.centerY)
            make.left.equalTo(fourLabel.snp.right).offset(6)
            make.height.equalTo(20.pix())
            make.right.equalToSuperview().offset(-20)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(19)
            make.height.equalTo(1)
            make.top.equalTo(priceLabel.snp.bottom).offset(7.pix())
            make.bottom.equalToSuperview().offset(-52)
        }
        openBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-21.5)
            make.top.equalTo(lineView.snp.bottom).offset(7.pix())
            make.size.equalTo(CGSize(width: 77.pix(), height: 28.pix()))
        }
        againBtn.snp.makeConstraints { make in
            make.right.equalTo(openBtn.snp.left).offset(-6)
            make.top.equalTo(lineView.snp.bottom).offset(7.pix())
            make.size.equalTo(CGSize(width: 85.pix(), height: 28.pix()))
        }
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8.pix())
        }
        typeImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-10.5)
        }
        rowsModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            headLabel.text = model.unitname ?? ""
            taxNumLabel.text = model.taxpayernumber ?? ""
            priceLabel.text = "¥\(model.invoiceamount ?? "0.00")"
            timeLabel.text = model.createTime ?? ""
            nameLabel.text = model.invoicetype == "2" ? "增值税专用发票(专票)" :
                             model.invoicetype == "1" ? "增值税普通发票(普票)" : "其他类型发票"
            typeImageView.image = model.handlestate == "3" ?
                                  UIImage(named: "watermarkwacnehng") : UIImage(named: "watermarkjinxinzhong")
            if model.handlestate == "3" {
                openBtn.isEnabled = true
                openBtn.backgroundColor = UIColor.init(cssStr: "#3849F7")?.withAlphaComponent(0.1)
                openBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            }else {
                openBtn.isEnabled = false
                openBtn.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
                openBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        
        self.openBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.rowsModel.value else { return }
            self.linkBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TwoTicketView: BaseView {
    
    var linkBlock: ((rowsModel) -> Void)?
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(TwoTicketCell.self, forCellReuseIdentifier: "TwoTicketCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44)
        }
        modelArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "TwoTicketCell", cellType: TwoTicketCell.self)) { row, model, cell in
            cell.rowsModel.accept(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.linkBlock = { [weak self] model in
                guard let self = self else { return }
                self.linkBlock?(model)
            }
        }.disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoTicketView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let label = UILabel()
        label.text = "电子发票会发送至您指定的邮箱，纸质发票会邮寄给您。"
        label.font = .regularFontOfSize(size: 12)
        label.textColor = .init(cssStr: "#9FA4AD")
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.bottom.right.equalToSuperview()
        }
        return headView
    }
    
}
