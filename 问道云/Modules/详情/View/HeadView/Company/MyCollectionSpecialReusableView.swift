//
//  MyCollectionSpecialReusableView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//  企业详情的自定义头部

import UIKit
import RxSwift
import RxRelay
import TYAlertController

class MyCollectionSpecialReusableView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    //头部数据模型
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    //风险模型
    var riskModel = BehaviorRelay<DataModel?>(value: nil)
    
    //常用服务模型
    var childrenArrayModel = BehaviorRelay<[childrenModel]?>(value: nil)
    
    //图谱模型
    var mapArrayModel = BehaviorRelay<[childrenModel]?>(value: nil)
    
    //点击了小标签的展开和收起
    var moreClickBlcok: ((CompanyModel) -> Void)?
    
    //点击了动态
    var activityBlock: (() -> Void)?
    
    static let identifier = "MyCollectionSpecialReusableView"
    
    var vipBlock: (() -> Void)?
    
    lazy var headView: CompanyDetailHeadView = {
        let headView = CompanyDetailHeadView()
        headView.moreClickBlcok = { [weak self] model in
            guard let self = self else { return }
            self.moreClickBlcok?(model)
        }
        headView.activityBlock = { [weak self] in
            self?.activityBlock?()
        }
        headView.vipBlock = { [weak self] in
            self?.vipBlock?()
        }
        return headView
    }()
    
    //简介
    lazy var infoView: CompanyDescInfoView = {
        let infoView = CompanyDescInfoView()
        return infoView
    }()
    
    //发票
    var popInvoiceView: PopInvoiceView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            headView.model.accept(model)
            let logoColor = model.basicInfo?.logoColor ?? ""
            //icon
            headView.oneHeadView.model.accept(model)
            let companyName = model.basicInfo?.orgName ?? ""
            headView.oneHeadView.iconImageView.kf.setImage(with: URL(string: model.basicInfo?.logo ?? ""), placeholder: UIImage.imageOfText(companyName, size: (40, 40), bgColor: UIColor.init(cssStr: logoColor) ?? .random()))
            //名字
            headView.oneHeadView.namelabel.text = companyName
            //代码
            headView.oneHeadView.numlabel.text = model.basicInfo?.usCreditCode ?? ""
            //标签
            let promptLabels = model.labels?.compactMap { $0.name } ?? []
            let riskLabels = model.warnLabels?.compactMap{ $0.name } ?? []
            headView.oneHeadView.tagArray.accept(promptLabels + riskLabels)
            //简介
            let descInfo = model.basicInfo?.resume ?? ""
            headView.oneHeadView.desLabel.text = "简介: \(descInfo)"
            let attributedString = NSMutableAttributedString(string: "简介: \(descInfo)")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attributedString.length)
            )
            infoView.desLabel.attributedText = attributedString
            headView.moreBtnBlock = { [weak self] in
                guard let self = self else { return }
                keyWindow?.addSubview(infoView)
                infoView.snp.makeConstraints { make in
                    make.left.bottom.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.top.equalTo(self.headView.oneHeadView.desLabel.snp.top)
                }
                UIView.animate(withDuration: 0.25) {
                    self.infoView.alpha = 1
                    self.headView.oneHeadView.desLabel.alpha = 0
                    self.headView.oneHeadView.moreButton.alpha = 0
                }
            }
            infoView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    UIView.animate(withDuration: 0.25) {
                        self.infoView.alpha = 0
                        self.headView.oneHeadView.desLabel.alpha = 1
                        self.headView.oneHeadView.moreButton.alpha = 1
                    }
            }).disposed(by: disposeBag)
            
            //曾用名
            headView.historyNameBtnBlock = { [weak self] in
                guard let self = self else { return }
                let popNameView = PopHistoryNameView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
                let alertVc = TYAlertController(alert: popNameView, preferredStyle: .alert)
                if let modelArray = model.namesHis, modelArray.count > 0 {
                    popNameView.modelArray.accept(modelArray)
                }else {
                    ToastViewConfig.showToast(message: "暂无曾用名")
                    return
                }
                //获取控制器
                let vc = ViewControllerUtils.findViewController(from: self)
                vc?.present(alertVc!, animated: true)
                
                popNameView.closeBtn.rx.tap.subscribe(onNext: {
                    vc?.dismiss(animated: true)
                }).disposed(by: disposeBag)
                
                popNameView.block = { model in
                    vc?.dismiss(animated: true, completion: {
                        let companyVc = CompanyBothViewController()
                        companyVc.enityId.accept(model.orgId ?? "")
                        vc?.navigationController?.pushViewController(companyVc, animated: true)
                    })
                }
            }
            
            //复制
            headView.oneHeadView.companyCodeBlock = {
                let pasteboard = UIPasteboard.general
                pasteboard.string = model.firmInfo?.usCreditCode ?? ""
                ToastViewConfig.showToast(message: "复制成功")
            }
            
            //发票弹窗
            headView.oneHeadView.invoiceBlock = { [weak self] in
                guard let self = self else { return }
                self.popInvoiceView = PopInvoiceView(frame: self.bounds)
                let alertVc = TYAlertController(alert: popInvoiceView, preferredStyle: .alert)
                popInvoiceView?.model.accept(model)
                //获取控制器
                let vc = ViewControllerUtils.findViewController(from: self)
                vc?.present(alertVc!, animated: true)
                popInvoiceView?.cancelBtn.rx.tap.subscribe(onNext: {
                    vc?.dismiss(animated: true)
                }).disposed(by: disposeBag)
                //保存fap
                popInvoiceView?.saveBtn.rx.tap.subscribe(onNext: {
                    if let vc = vc {
                        self.addInfo(from: vc )
                    }
                }).disposed(by: disposeBag)
            }
            
            //法定代表人
            headView.oneHeadView.nameView.label1.text = model.leaderVec?.leaderTypeName ?? ""
            headView.oneHeadView.nameView.label2.text = model.leaderVec?.leaderList?.first?.name ?? ""
            //注册资本
            let moneyStr = model.basicInfo?.regCap ?? ""
            let unit = model.basicInfo?.regCapCur ?? ""
            headView.oneHeadView.moneyView.label2.text = moneyStr + unit
            
            //成立时间
            headView.oneHeadView.timeView.label2.text = model.basicInfo?.incDate ?? ""
            //行业
            headView.oneHeadView.oneView.label2.text = model.basicInfo?.industry?.first?.name ?? ""
            //规模
            headView.oneHeadView.twoView.label2.text = model.basicInfo?.scale ?? "--"
            //员工
            headView.oneHeadView.threeView.timeLabel.text = model.employees?.lastYear ?? ""
            headView.oneHeadView.threeView.label2.text = "\(model.employees?.lastAmount ?? "")"
            //利润
            headView.oneHeadView.fourView.timeLabel.text = model.saleInfo?.lastYear ?? ""
            headView.oneHeadView.fourView.label2.text = model.saleInfo?.lastAmount ?? ""
            //收入
            headView.oneHeadView.fiveView.timeLabel.text = model.profitInfo?.lastYear ?? ""
            headView.oneHeadView.fiveView.label2.text = model.profitInfo?.lastAmount ?? ""
            //总资产
            headView.oneHeadView.sixView.timeLabel.text = model.assetInfo?.lastYear ?? ""
            headView.oneHeadView.sixView.label2.text = model.assetInfo?.lastAmount ?? ""
            //电话个数
            headView.twoHeadView.model.accept(model)
            
            //主要股东
            headView.threeHeadView.dataModel.accept(model)
            headView.threeHeadView.shareHoldersBlock = { model in
                let category = model.category ?? ""
                let vc = ViewControllerUtils.findViewController(from: self)
                if category.isEmpty {
                    return
                }
                if category == "1" {
                    let companyVc = CompanyBothViewController()
                    companyVc.enityId.accept(model.id ?? "")
                    companyVc.companyName.accept(model.name ?? "")
                    vc?.navigationController?.pushViewController(companyVc, animated: true)
                }else {
                    let legalName = model.name ?? ""
                    let personNumber = model.id ?? ""
                    let peopleDetailVc = PeopleBothViewController()
                    peopleDetailVc.personId.accept(personNumber)
                    peopleDetailVc.peopleName.accept(legalName)
                    vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
                }
            }
            headView.threeHeadView.staffInfosBlock = { model in
                let vc = ViewControllerUtils.findViewController(from: self)
                let legalName = model.name ?? ""
                let personNumber = String(model.id ?? 0)
                let peopleDetailVc = PeopleBothViewController()
                peopleDetailVc.personId.accept(personNumber)
                peopleDetailVc.peopleName.accept(legalName)
                vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
            }
            
            //常用服务
            headView.sixHeadView.dataModel = model
            childrenArrayModel.asObservable().subscribe(onNext: { [weak self] modelArray in
                guard let self = self, let modelArray = modelArray else { return }
                headView.sixHeadView.oneItems = modelArray
            }).disposed(by: disposeBag)
            
            //问道图谱
            mapArrayModel.asObservable().subscribe(onNext: { [weak self] modelArray in
                guard let self = self, let modelArray = modelArray else { return }
                headView.sixHeadView.twoItems = modelArray
            }).disposed(by: disposeBag)
            
            //股票信息
            if let stockInfo = model.stockInfo, !stockInfo.isEmpty {
                headView.stockView.dataModel.accept(model)
                headView.stockView.isHidden = false
            }else {
                headView.stockView.isHidden = true
            }
            
        }).disposed(by: disposeBag)
        
        //风险模型
        riskModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            //风险数据
            headView.fourHeadView.oneRiskView.namelabel.text = "经营风险"
            if let model = model.operationRisk  {
                let count = model.totalRiskCnt ?? ""
                let descStr = model.riskDetail ?? ""
                headView.fourHeadView.oneRiskView.numLabel.text = count
                headView.fourHeadView.oneRiskView.descLabel.text = descStr
                headView.fourHeadView.oneRiskView.timeLabel.text = model.riskTime ?? ""
            }else {
                headView.fourHeadView.oneRiskView.numLabel.text = "0"
                headView.fourHeadView.oneRiskView.descLabel.text = "暂无数据"
                headView.fourHeadView.oneRiskView.timeLabel.text = ""
            }
            
            headView.fourHeadView.twoRiskView.namelabel.text = "法律风险"
            if let model = model.lawRisk {
                let count = model.totalRiskCnt ?? ""
                let descStr = model.riskDetail ?? ""
                headView.fourHeadView.twoRiskView.numLabel.text = count
                headView.fourHeadView.twoRiskView.descLabel.text = descStr
                headView.fourHeadView.twoRiskView.timeLabel.text = model.riskTime ?? ""
            }else {
                headView.fourHeadView.twoRiskView.numLabel.text = "0"
                headView.fourHeadView.twoRiskView.descLabel.text = "暂无数据"
                headView.fourHeadView.twoRiskView.timeLabel.text = ""
            }
            
            headView.fourHeadView.threeRiskView.namelabel.text = "财务风险"
            if let model = model.financeRisk  {
                let count = model.totalRiskCnt ?? ""
                let descStr = model.riskDetail ?? ""
                headView.fourHeadView.threeRiskView.numLabel.text = count
                headView.fourHeadView.threeRiskView.descLabel.text = descStr
                headView.fourHeadView.threeRiskView.timeLabel.text = model.riskTime ?? ""
            }else {
                headView.fourHeadView.threeRiskView.numLabel.text = "0"
                headView.fourHeadView.threeRiskView.descLabel.text = "暂无数据"
                headView.fourHeadView.threeRiskView.timeLabel.text = ""
            }
    
            headView.fourHeadView.fourRiskView.namelabel.text = "舆情风险"
            if let model = model.opinionRisk  {
                let count = model.totalRiskCnt ?? ""
                let descStr = model.riskDetail ?? ""
                headView.fourHeadView.fourRiskView.numLabel.text = count
                headView.fourHeadView.fourRiskView.descLabel.text = descStr
                headView.fourHeadView.fourRiskView.timeLabel.text = model.riskTime ?? ""
            }else {
                headView.fourHeadView.fourRiskView.numLabel.text = "0"
                headView.fourHeadView.fourRiskView.descLabel.text = "暂无数据"
                headView.fourHeadView.fourRiskView.timeLabel.text = ""
            }
            
            //动态
            let timeStr = model.riskDynamic?.riskTime?.isEmpty ?? true ? "暂无数据" : model.riskDynamic!.riskTime!
            headView.fiveHeadView.timelabel.text = timeStr
            headView.fiveHeadView.desclabel.text = model.riskDynamic?.riskInfo ?? ""
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension MyCollectionSpecialReusableView {
    
    //添加发票抬头
    func addInfo(from vc: UIViewController) {
        let companyname = popInvoiceView?.namelabel.text ?? ""
        let companynumber = popInvoiceView?.label1.text ?? ""
        let address = popInvoiceView?.label2.text ?? ""
        let contactnumber = popInvoiceView?.label3.text ?? ""
        let bankname = popInvoiceView?.label4.text ?? ""
        let bankfullname = popInvoiceView?.label5.text ?? ""
        let defaultstate = "0"
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["companyname": companyname,
                    "companynumber": companynumber,
                    "address": address,
                    "contactnumber": contactnumber,
                    "bankname": bankname,
                    "bankfullname": bankfullname,
                    "defaultstate": defaultstate,
                    "contact": customernumber] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/invoiceriseit/add",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    vc.dismiss(animated: true)
                    ToastViewConfig.showToast(message: "添加成功")
                }else {
                    ToastViewConfig.showToast(message: success.msg ?? "")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
