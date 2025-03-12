//
//  CompanyOneHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit
import RxRelay
import TYAlertController

class CompanyOneHeadView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    var moreClickBlcok: ((CompanyModel) -> Void)?
    //展开简介按钮
    var moreBtnBlock: (() -> Void)?
    //点击了曾用名
    var historyNameBtnBlock: (() -> Void)?
    //复制企业统一码
    var companyCodeBlock: (() -> Void)?
    //发票抬头弹窗
    var invoiceBlock: (() -> Void)?
    
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#111111")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 16)
        return namelabel
    }()
    
    lazy var historyNamesButton: UIButton = {
        let historyNamesButton = UIButton(type: .custom)
        historyNamesButton.setImage(UIImage(named: "cengyongmingicon"), for: .normal)
        return historyNamesButton
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#666666")
        numlabel.textAlignment = .left
        numlabel.font = .regularFontOfSize(size: 12)
        numlabel.isUserInteractionEnabled = true
        return numlabel
    }()
    
    lazy var invoiceTitleButton: UIButton = {
        let invoiceTitleButton = UIButton(type: .custom)
        invoiceTitleButton.setImage(UIImage(named: "fapiaotaitouicon"), for: .normal)
        return invoiceTitleButton
    }()
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        return tagListView
    }()
    
    lazy var desLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.font = .regularFontOfSize(size: 12)
        desLabel.textColor = .init(cssStr: "#666666")
        desLabel.textAlignment = .left
        desLabel.numberOfLines = 1
        return desLabel
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.titleLabel?.font = .mediumFontOfSize(size: 12)
        moreButton.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        moreButton.setTitle("展开", for: .normal)
        return moreButton
    }()
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.lineView.isHidden = false
        nameView.label1.text = "法定代表人"
        nameView.label2.textColor = .init(cssStr: "#547AFF")
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.lineView.isHidden = false
        moneyView.label1.text = "注册资本"
        moneyView.label2.textColor = .init(cssStr: "#333333")
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        timeView.label2.textColor = .init(cssStr: "#333333")
        return timeView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F8F8F8")
        return grayView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneView: BiaoQianView = {
        let oneView = BiaoQianView(frame: .zero, enmu: .showImage)
        oneView.iconImageView.image = UIImage(named: "hagnyeimagede")
        oneView.label2.textColor = .init(cssStr: "#547AFF")
        oneView.lineView.isHidden = false
        oneView.isUserInteractionEnabled = true
        return oneView
    }()
    
    lazy var twoView: BiaoQianView = {
        let twoView = BiaoQianView(frame: .zero, enmu: .showImage)
        twoView.iconImageView.image = UIImage(named: "guimodeimage")
        twoView.label2.textColor = .init(cssStr: "#333333")
        twoView.lineView.isHidden = false
        twoView.isUserInteractionEnabled = true
        return twoView
    }()
    
    lazy var threeView: BiaoQianView = {
        let threeView = BiaoQianView(frame: .zero, enmu: .showTime)
        threeView.label1.text = "员工"
        threeView.label2.textColor = .init(cssStr: "#333333")
        threeView.lineView.isHidden = false
        threeView.isUserInteractionEnabled = true
        return threeView
    }()
    
    lazy var fourView: BiaoQianView = {
        let fourView = BiaoQianView(frame: .zero, enmu: .showTime)
        fourView.label1.text = "营业收入"
        fourView.label2.textColor = .init(cssStr: "#333333")
        fourView.lineView.isHidden = false
        fourView.isUserInteractionEnabled = true
        return fourView
    }()
    
    lazy var fiveView: BiaoQianView = {
        let fiveView = BiaoQianView(frame: .zero, enmu: .showTime)
        fiveView.label1.text = "利润总额"
        fiveView.label2.textColor = .init(cssStr: "#333333")
        fiveView.lineView.isHidden = false
        fiveView.isUserInteractionEnabled = true
        return fiveView
    }()
    
    lazy var sixView: BiaoQianView = {
        let sixView = BiaoQianView(frame: .zero, enmu: .showTime)
        sixView.label1.text = "总资产"
        sixView.label2.textColor = .init(cssStr: "#333333")
        sixView.lineView.isHidden = true
        sixView.isUserInteractionEnabled = true
        return sixView
    }()
    
    lazy var tlineView: UIView = {
        let tlineView = UIView()
        tlineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return tlineView
    }()
    
    var tagArray = BehaviorRelay<[String]?>(value: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(iconImageView)
        addSubview(namelabel)
        addSubview(historyNamesButton)
        addSubview(numlabel)
        addSubview(invoiceTitleButton)
        addSubview(tagListView)
        addSubview(desLabel)
        addSubview(moreButton)
        
        addSubview(grayView)
        grayView.addSubview(nameView)
        grayView.addSubview(moneyView)
        grayView.addSubview(timeView)
        
        addSubview(scrollView)
        scrollView.addSubview(oneView)
        scrollView.addSubview(twoView)
        scrollView.addSubview(threeView)
        scrollView.addSubview(fourView)
        scrollView.addSubview(fiveView)
        scrollView.addSubview(sixView)
        addSubview(tlineView)
        
        lineView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.height.equalTo(22.5)
        }
        historyNamesButton.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(4.5)
            make.left.equalTo(namelabel.snp.left)
            make.size.equalTo(CGSize(width: 49, height: 15))
        }
        numlabel.snp.makeConstraints { make in
            make.left.equalTo(historyNamesButton.snp.right).offset(5)
            make.centerY.equalTo(historyNamesButton.snp.centerY)
            make.height.equalTo(15)
        }
        invoiceTitleButton.snp.makeConstraints { make in
            make.top.equalTo(historyNamesButton.snp.top)
            make.left.equalTo(numlabel.snp.right).offset(9.5)
            make.size.equalTo(CGSize(width: 59, height: 15))
        }
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(historyNamesButton.snp.left)
            make.top.equalTo(historyNamesButton.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.5)
            make.width.equalTo(SCREEN_WIDTH - 65)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(desLabel.snp.centerY)
            make.left.equalTo(desLabel.snp.right).offset(10)
            make.height.equalTo(16.5)
        }
        grayView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(desLabel.snp.bottom).offset(6.5)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(46.5)
        }
        moneyView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        timeView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(moneyView.snp.right)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(SCREEN_WIDTH - 5)
            make.top.equalTo(grayView.snp.bottom).offset(11.5)
            make.height.equalTo(40)
        }
        oneView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        twoView.snp.makeConstraints { make in
            make.left.equalTo(oneView.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        threeView.snp.makeConstraints { make in
            make.left.equalTo(twoView.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        fourView.snp.makeConstraints { make in
            make.left.equalTo(threeView.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        fiveView.snp.makeConstraints { make in
            make.left.equalTo(fourView.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(110)
        }
        sixView.snp.makeConstraints { make in
            make.left.equalTo(fiveView.snp.right)
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(110)
            make.right.equalToSuperview().offset(-20)
        }
        tlineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(scrollView.snp.bottom).offset(5)
        }
        
        //简介点击展开
        moreButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.moreBtnBlock?()
        }).disposed(by: disposeBag)
        
        //点击了曾用名
        historyNamesButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.historyNameBtnBlock?()
        }).disposed(by: disposeBag)
        
        //企业码
        numlabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.companyCodeBlock?()
        }).disposed(by: disposeBag)
        
        //发票抬头
        invoiceTitleButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.invoiceBlock?()
        }).disposed(by: disposeBag)
        
        //点击了法定代表人
        nameView.rx
            .tapGesture()
            .when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let peopleModel = self.model.value?.leaderVec?.leaderList?.first {
                    let vc = ViewControllerUtils.findViewController(from: self)
                    let personId = peopleModel.leaderId ?? ""
                    let peopleName = peopleModel.name ?? ""
                    let peopleDetailVc = PeopleBothViewController()
                    peopleDetailVc.personId.accept(personId)
                    peopleDetailVc.peopleName.accept(peopleName)
                    vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
                }
        }).disposed(by: disposeBag)
        
        //行业类型
        oneView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let industryView = PopIndustryView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 250))
            if let model = model.value {
                let titles = model.basicInfo?.industry?.map { $0.name ?? "" }
                industryView.titles.accept(titles ?? [])
            }
            let alertVc = TYAlertController(alert: industryView, preferredStyle: .alert)
            
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.present(alertVc!, animated: true)
            
            industryView.cancelBtn.rx.tap.subscribe(onNext: {
                vc?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            
        }).disposed(by: self.disposeBag)
        
        //员工
        threeView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let employeeView = PopEmployeeNumView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 400))
            employeeView.ctImageView.image = UIImage(named: "员工人数")
            let alertVc = TYAlertController(alert: employeeView, preferredStyle: .alert)
            
            if let model = model.value {
                employeeView.model.accept(model)
            }
            
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.present(alertVc!, animated: true)
            
            employeeView.cancelBtn.rx.tap.subscribe(onNext: {
                vc?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            
        }).disposed(by: disposeBag)
        
        //收入
        fourView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let employeeView = PopRateMoneyView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 400), type: "0")
            employeeView.ctImageView.image = UIImage(named: "营业收入")
            let alertVc = TYAlertController(alert: employeeView, preferredStyle: .alert)
            
            if let model = model.value {
                employeeView.model.accept(model)
            }
            
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.present(alertVc!, animated: true)
            
            employeeView.cancelBtn.rx.tap.subscribe(onNext: {
                vc?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            
            //更多财务数据
            employeeView.block = { model in
                vc?.dismiss(animated: true, completion: {
                    let firmname = model.firmInfo?.entityName ?? ""
                    let entityId = model.firmInfo?.entityId ?? ""
                    let url = base_url + "/basic-information/financial-data"
                    let pageUrl = URLQueryAppender.appendQueryParameters(to: url, parameters: ["firmname": firmname, "entityId": entityId])
                    vc?.pushWebPage(from: pageUrl ?? "")
                })
            }
            
        }).disposed(by: disposeBag)
        
        //利润
        fiveView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let employeeView = PopRateMoneyView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 400), type: "1")
            employeeView.ctImageView.image = UIImage(named: "利润总额")
            let alertVc = TYAlertController(alert: employeeView, preferredStyle: .alert)
            
            if let model = model.value {
                employeeView.model.accept(model)
            }
            
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.present(alertVc!, animated: true)
            
            employeeView.cancelBtn.rx.tap.subscribe(onNext: {
                vc?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            
            //更多财务数据
            employeeView.block = { model in
                vc?.dismiss(animated: true, completion: {
                    let firmname = model.firmInfo?.entityName ?? ""
                    let entityId = model.firmInfo?.entityId ?? ""
                    let url = base_url + "/basic-information/financial-data"
                    let pageUrl = URLQueryAppender.appendQueryParameters(to: url, parameters: ["firmname": firmname, "entityId": entityId])
                    vc?.pushWebPage(from: pageUrl ?? "")
                })
            }
            
        }).disposed(by: disposeBag)
        
        //总资产
        sixView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let employeeView = PopRateMoneyView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 400), type: "2")
            employeeView.ctImageView.image = UIImage(named: "利润总额")
            let alertVc = TYAlertController(alert: employeeView, preferredStyle: .alert)
            
            if let model = model.value {
                employeeView.model.accept(model)
            }
            
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.present(alertVc!, animated: true)
            
            employeeView.cancelBtn.rx.tap.subscribe(onNext: {
                vc?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            
            //更多财务数据
            employeeView.block = { model in
                vc?.dismiss(animated: true, completion: {
                    let firmname = model.firmInfo?.entityName ?? ""
                    let entityId = model.firmInfo?.entityId ?? ""
                    let url = base_url + "/basic-information/financial-data"
                    let pageUrl = URLQueryAppender.appendQueryParameters(to: url, parameters: ["firmname": firmname, "entityId": entityId])
                    vc?.pushWebPage(from: pageUrl ?? "")
                })
            }
            
        }).disposed(by: disposeBag)
        
        //标签
        DispatchQueue.main.async {
            self.tagArray.asObservable().subscribe(onNext: { [weak self] texts in
                guard let self = self, let texts = texts, texts.count > 0  else { return }
                setupScrollView(tagScrollView: tagListView, tagArray: texts)
            }).disposed(by: self.disposeBag)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

}


extension CompanyOneHeadView {
    
    func setupScrollView(tagScrollView: UIScrollView, tagArray: [String]) {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        let maxWidth = self.tagListView.frame.width
        let openButtonWidth: CGFloat = 40 // 展开按钮宽度
        let buttonHeight: CGFloat = 18 // 标签高度
        let buttonSpacing: CGFloat = 5 // 标签之间的间距
        var numberOfLine: CGFloat = 1 // 标签总行数
        var lastRight: CGFloat = 0 // 标签的左边距
        let isOpen = companyModel.isOpenTag // 标签展开或者收起
        
        // 创建展开/收起按钮
        let openButton = UIButton(type: .custom)
        openButton.titleLabel?.font = .regularFontOfSize(size: 12)
        openButton.backgroundColor = UIColor(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        openButton.setTitle("展开", for: .normal)
        openButton.setTitleColor(UIColor(cssStr: "#547AFF"), for: .normal)
        openButton.layer.masksToBounds = true
        openButton.layer.cornerRadius = 2
        openButton.setImage(UIImage(named: "xialaimageicon"), for: .normal)
        openButton.addTarget(self, action: #selector(didOpenTags), for: .touchUpInside)
        if isOpen {
            openButton.setTitle("收起", for: .normal)
            openButton.setImage(UIImage(named: "shangimageicon"), for: .normal)
        }
        
        // 计算标签总长度
        var totalLength = lastRight
        for tags in tagArray {
            let tag = "\(tags)"
            let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 12)])
            var width = titleSize.width
            if tags.contains("展开") {
                width = openButtonWidth
            }
            totalLength += buttonSpacing + width
        }
        
        // 判断标签长度是否超过一行
        var tagArrayToShow = [String]()
        if totalLength - buttonSpacing > maxWidth { // 整体超过一行，添加展开收起
            var p = 0
            var lastLength = lastRight
            for tags in tagArray {
                let tag = "\(tags)"
                let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 12)])
                var width = titleSize.width
                if tags.contains("展开") {
                    width = openButtonWidth
                }
                if (lastLength + openButtonWidth < maxWidth) && (lastLength + buttonSpacing + width + openButtonWidth > maxWidth) {
                    break
                }
                lastLength += buttonSpacing + width
                p += 1
            }
            
            if !isOpen && p != 0 { // 收起状态
                for i in 0..<p {
                    tagArrayToShow.append(tagArray[i])
                }
                tagArrayToShow.append("展开")
            } else if isOpen {
                tagArrayToShow.append(contentsOf: tagArray)
                tagArrayToShow.append("收起")
            } else {
                tagArrayToShow.append(contentsOf: tagArray)
            }
        } else {
            tagArrayToShow.append(contentsOf: tagArray)
        }
        
        // 插入标签和展开按钮
        for tags in tagArrayToShow {
            if tags == "展开" || tags == "收起" {
                // 检查当前行剩余宽度是否足够放下收起按钮
                if lastRight + openButtonWidth > maxWidth {
                    // 另起一行
                    numberOfLine += 1
                    lastRight = 0
                }
                
                tagScrollView.addSubview(openButton)
                openButton.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing))
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(openButtonWidth)
                }
                lastRight += openButtonWidth + buttonSpacing
            } else {
                let lab = UILabel()
                lab.font = .regularFontOfSize(size: 12)
                lab.textColor = UIColor(cssStr: "#ECF2FF")
                lab.backgroundColor = UIColor(cssStr: "#93B2F5")
                lab.layer.masksToBounds = true
                lab.layer.cornerRadius = 3
                lab.layer.allowsEdgeAntialiasing = true
                lab.textAlignment = .center
                lab.text = "\(tags)"
                TagsLabelColorConfig.nameLabelColor(from: lab)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width + 10  // 增加左右 padding
                
                if width + lastRight > maxWidth {
                    numberOfLine += 1
                    lastRight = 0
                }
                
                lab.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing))
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(width)
                }
            
                lastRight += width + buttonSpacing
            }
        }
        
        // 设置 tagScrollView 的约束
        tagScrollView.snp.updateConstraints { make in
            make.height.equalTo(numberOfLine * (buttonHeight + buttonSpacing))
        }
        openButton.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    // 按钮点击事件
    @objc func didOpenTags(_ sender: UIButton) {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray.value ?? []) // 重新设置标签
        self.moreClickBlcok?(companyModel)
    }
    
}
