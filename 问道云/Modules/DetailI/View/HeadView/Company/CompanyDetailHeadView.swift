//
//  CompanyDetailHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit
import RxRelay

class CompanyDetailHeadView: BaseView {
    var model = BehaviorRelay<DataModel?>(value: nil)
    //展开简介按钮
    var moreBtnBlock: (() -> Void)?
    //点击了曾用名
    var historyNameBtnBlock: (() -> Void)?
    //复制企业统一码
    var companyCodeBlock: (() -> Void)?
    //发票抬头弹窗
    var invoiceBlock: (() -> Void)?
    //点击了小标签的展开和收起
    var moreClickBlcok: ((CompanyModel) -> Void)?
    
    //股东点击
    var shareHoldersBlock: ((shareHoldersModel) -> Void)?
    
    //人员点击
    var staffInfosBlock: ((staffInfosModel) -> Void)?
    
    lazy var oneHeadView: CompanyOneHeadView = {
        let oneHeadView = CompanyOneHeadView()
        oneHeadView.moreBtnBlock = { [weak self] in
            self?.moreBtnBlock?()
        }
        oneHeadView.historyNameBtnBlock = { [weak self] in
            self?.historyNameBtnBlock?()
        }
        oneHeadView.companyCodeBlock = { [weak self] in
            self?.companyCodeBlock?()
        }
        oneHeadView.invoiceBlock = { [weak self] in
            self?.invoiceBlock?()
        }
        return oneHeadView
    }()
    
    lazy var twoHeadView: CompanyTwoHeadView = {
        let twoHeadView = CompanyTwoHeadView()
        return twoHeadView
    }()
    
    lazy var threeHeadView: CompanyThreeHeadView = {
        let threeHeadView = CompanyThreeHeadView()
        return threeHeadView
    }()
    
    lazy var fourHeadView: CompanyFourHeadView = {
        let fourHeadView = CompanyFourHeadView()
        return fourHeadView
    }()
    
    lazy var fiveHeadView: CompanyFiveHeadView = {
        let fiveHeadView = CompanyFiveHeadView()
        return fiveHeadView
    }()
    
    lazy var sixHeadView: CompanySixHeadView = {
        let sixHeadView = CompanySixHeadView()
        return sixHeadView
    }()
    
    lazy var stockView: CompanyStockInfoView = {
        let stockView = CompanyStockInfoView()
        return stockView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneHeadView)
        addSubview(twoHeadView)
        addSubview(threeHeadView)
        addSubview(fourHeadView)
        addSubview(fiveHeadView)
        addSubview(sixHeadView)
        addSubview(stockView)
        oneHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(220)
        }
        twoHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneHeadView.snp.bottom)
            make.height.equalTo(34)
        }
        threeHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoHeadView.snp.bottom)
            make.height.equalTo(0)
        }
        fourHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(threeHeadView.snp.bottom)
            make.height.equalTo(76)
        }
        fiveHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fourHeadView.snp.bottom)
            make.height.equalTo(53)
        }
        sixHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fiveHeadView.snp.bottom)
            make.height.equalTo(150)
        }
        
        stockView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sixHeadView.snp.bottom)
            make.height.equalTo(200)
        }
        
        //点击了小标签的展开收起 更改头部高度
        oneHeadView.moreClickBlcok = { [weak self] model in
            guard let self = self else { return }
            self.moreClickBlcok?(model)
            if model.isOpenTag {
                oneHeadView.snp.updateConstraints { make in
                    make.height.equalTo(230)
                }
            }else {
                oneHeadView.snp.updateConstraints { make in
                    make.height.equalTo(220)
                }
            }
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let shareHolders = model.shareHolders ?? []
            let srMgmtInfos = model.srMgmtInfos ?? []
            fourHeadView.model.accept(model)
            threeHeadView.lineView.isHidden = false
            if !shareHolders.isEmpty && !srMgmtInfos.isEmpty {
                threeHeadView.snp.updateConstraints { make in
                    make.height.equalTo(160)
                }
            }else if !shareHolders.isEmpty && srMgmtInfos.isEmpty {
                threeHeadView.snp.updateConstraints { make in
                    make.height.equalTo(86)
                }
            }else if shareHolders.isEmpty && !srMgmtInfos.isEmpty {
                threeHeadView.snp.updateConstraints { make in
                    make.height.equalTo(72)
                }
            }else {
                threeHeadView.lineView.isHidden = true
                threeHeadView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
