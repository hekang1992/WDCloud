//
//  TwoRiskListCompanyCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit
import RxRelay
import TagListView

class TwoRiskListCompanyCell: BaseViewCell {
    
    // 高度更新回调
    var heightDidUpdate: (() -> Void)?
    
    var focusBlock: (() -> Void)?
    
    var peopleBlock: ((pageDataModel) -> Void)?
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)
    
    var tagArray: [String] = []
    
    //点击查看更多
    var moreBlock: (() -> Void)?
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 3
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        return tagListView
    }()
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.label1.text = "法定代表人"
        nameView.lineView.isHidden = false
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.label1.text = "注册资本"
        moneyView.label2.textColor = .init(cssStr: "#333333")
        moneyView.lineView.isHidden = false
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        timeView.label2.textColor = .init(cssStr: "#333333")
        return timeView
    }()
    
    lazy var redView: UIView = {
        let redView = UIView()
        redView.layer.cornerRadius = 2
        redView.layer.masksToBounds = true
        redView.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.05)
        redView.isSkeletonable = true
        return redView
    }()
    
    lazy var riskImageView: UIImageView = {
        let riskImageView = UIImageView()
        riskImageView.image = UIImage(named: "riskiamgeicon")
        return riskImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "righticonimage")
        return rightImageView
    }()
    
    lazy var riskTimeLabel: UILabel = {
        let riskTimeLabel = UILabel()
        riskTimeLabel.textColor = .init(cssStr: "#666666")
        riskTimeLabel.font = .regularFontOfSize(size: 12)
        riskTimeLabel.textAlignment = .left
        return riskTimeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    //自身风险
    lazy var oneNumLabel: UILabel = {
        let oneNumLabel = UILabel()
        oneNumLabel.font = .regularFontOfSize(size: 12)
        oneNumLabel.textAlignment = .left
        oneNumLabel.textColor = .init(cssStr: "#333333")
        return oneNumLabel
    }()
    
    //关联风险
    lazy var twoNumLabel: UILabel = {
        let twoNumLabel = UILabel()
        twoNumLabel.font = .regularFontOfSize(size: 12)
        twoNumLabel.textAlignment = .left
        twoNumLabel.textColor = .init(cssStr: "#333333")
        return twoNumLabel
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "chakanmoreimge"), for: .normal)
        return moreBtn
    }()
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        return focusBtn
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F3F3F3")
        return footerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(nameView)
        contentView.addSubview(moneyView)
        contentView.addSubview(timeView)
        contentView.addSubview(redView)
        redView.addSubview(riskImageView)
        redView.addSubview(rightImageView)
        redView.addSubview(riskTimeLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(oneNumLabel)
        contentView.addSubview(twoNumLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(focusBtn)
        contentView.addSubview(footerView)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(ctImageView.snp.right).offset(8)
            make.height.lessThanOrEqualTo(40)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 100)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(18)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
            make.right.equalToSuperview()
        }
        
        redView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(timeView.snp.bottom)
            make.height.equalTo(0)
        }
        
        riskImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 57, height: 13))
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 12, height: 12))
            make.right.equalToSuperview().offset(-7)
        }
        riskTimeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(riskImageView.snp.right).offset(10.5)
            make.height.equalTo(16.5)
        }

        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(redView.snp.bottom).offset(11.5)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        oneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(16.5)
        }
        
        twoNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneNumLabel.snp.centerY)
            make.left.equalTo(oneNumLabel.snp.right).offset(5)
            make.height.equalTo(16.5)
        }
        
        moreBtn.snp.makeConstraints { make in
            make.centerY.equalTo(oneNumLabel.snp.centerY)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(16.5)
        }
        focusBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(14)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.moreBlock?()
        }).disposed(by: disposeBag)
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let companyName = model.orgInfo?.orgName ?? ""
            let logoColor = model.orgInfo?.logoColor ?? ""
            let logo = model.orgInfo?.logo ?? ""
            let followStatus = model.followStatus ?? 0
            if followStatus == 1 {
                focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }else {
                focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }
            self.ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(companyName, size: (32, 32), bgColor: UIColor.init(cssStr: logoColor)!))
            
            //匹配文字
            self.nameLabel.attributedText = GetRedStrConfig.getRedStr(from: model.searchStr ?? "", fullText: companyName, colorStr: "#F55B5B", font: .mediumFontOfSize(size: 14))
            
            //法人
            let leaderList = model.leaderVec?.leaderList ?? []
            let legalName = leaderList.compactMap { $0.name }.joined(separator: ",")
            self.nameView.label2.text = legalName
            
            self.moneyView.label2.text = model.orgInfo?.regCap ?? ""
            self.timeView.label2.text = model.orgInfo?.incDate ?? ""
            let moduleId = model.moduleId ?? ""
            if moduleId == "14" || moduleId == "15" {//法院公告
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条法院公告相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "16" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条司法拍卖相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "17" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条税收违法相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "18" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条环保处罚相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "19" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条行政处罚相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "20" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条贷款逾期相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "21" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条债券违约相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "23" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条资产查封相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "24" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条资产抵押相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "25" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条对外担保相关记录", font: .regularFontOfSize(size: 12))
            }else if moduleId == "26" {
                let relevaRiskCnt = String(model.riskCount ?? 0)
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = true
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "共\(relevaRiskCnt)条对外投资相关记录", font: .regularFontOfSize(size: 12))
            }else {
                self.oneNumLabel.isHidden = false
                self.twoNumLabel.isHidden = false
                let relevaRiskCnt = String(model.riskInfo?.relevaRiskCnt ?? 0)
                let selfRiskCnt = String(model.riskInfo?.selfRiskCnt ?? 0)
                self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: selfRiskCnt, fullText: "共\(selfRiskCnt)条自身风险", font: .regularFontOfSize(size: 12))
                self.twoNumLabel.attributedText = GetRedStrConfig.getRedStr(from: relevaRiskCnt, fullText: "\(relevaRiskCnt)条关联风险", font: .regularFontOfSize(size: 12))
            }
            //小标签
            let tagArray = model.labels?.compactMap { $0.name ?? "" } ?? []
            self.tagArray = tagArray
            setupScrollView(tagScrollView: tagListView, tagArray: tagArray)
            
            let content =  model.riskInfo?.content ?? ""
            if let riskInfo = model.riskInfo,
               let riskTime = riskInfo.riskTime,
               !riskTime.isEmpty {
                self.redView.isHidden = false
                self.redView.snp.updateConstraints { make in
                    make.top.equalTo(self.timeView.snp.bottom).offset(7)
                    make.height.equalTo(30)
                }
                riskTimeLabel.text = riskTime + content
            }else {
                self.redView.isHidden = true
                self.redView.snp.updateConstraints { make in
                    make.top.equalTo(self.timeView.snp.bottom)
                    make.height.equalTo(0)
                }
                riskTimeLabel.text = ""
            }
            
        }).disposed(by: disposeBag)
        
        focusBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.focusBlock?()
        }).disposed(by: disposeBag)
        
        nameView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if let self = self, let model = self.model.value {
                    self.peopleBlock?(model)
                }
            }).disposed(by: disposeBag)
        
        nameLabel.rx.longPressGesture(configuration: { gesture, _ in
            gesture.minimumPressDuration = 0.3
        }).subscribe(onNext: { [weak self] gesture in
            if let self = self {
                if gesture.state == .began {
                    self.handleLongPressOnLabel(from: nameLabel)
                }else if gesture.state == .ended {
                    self.handleEndLongPressOnLabel(from: nameLabel)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func handleLongPressOnLabel(from label: UILabel) {
        UIPasteboard.general.string = nameLabel.text
        ToastViewConfig.showToast(message: "复制成功")
        label.backgroundColor = .init(cssStr: "#333333")?.withAlphaComponent(0.2)
        HapticFeedbackManager.triggerImpactFeedback(style: .medium)
    }
    
    private func handleEndLongPressOnLabel(from label: UILabel) {
        label.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoRiskListCompanyCell {
    
    func setupScrollView(tagScrollView: UIScrollView, tagArray: [String]) {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        let maxWidth = SCREEN_WIDTH - 80
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
            var width = titleSize.width + 5
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
                var width = titleSize.width + 5
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
                lab.layer.cornerRadius = 3
                lab.layer.allowsEdgeAntialiasing = true
                lab.textAlignment = .center
                lab.text = "\(tags)"
                TagsLabelColorConfig.nameLabelColor(from: lab)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width + 5  // 增加左右 padding
                
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
        companyModel.isOpenTag.toggle()
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray)
        self.heightDidUpdate?()
    }
    
}
