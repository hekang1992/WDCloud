//
//  HighSearchViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/5.
//

import UIKit
import TYAlertController

class HighSearchViewCell: BaseViewCell {
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagArray: [String] = []
    
    var focusBlock: (() -> Void)?

    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.isSkeletonable = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.isSkeletonable = true
        return nameLabel
    }()

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F3F3F3")
        lineView.isSkeletonable = true
        return lineView
    }()
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        focusBtn.adjustsImageWhenHighlighted = false
        focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        focusBtn.isSkeletonable = true
        return focusBtn
    }()
    
    lazy var legalNameLabel: UILabel = {
        let legalNameLabel = UILabel()
        legalNameLabel.textColor = .init(cssStr: "#3F96FF")
        legalNameLabel.textAlignment = .left
        legalNameLabel.font = .regularFontOfSize(size: 12)
        legalNameLabel.isUserInteractionEnabled = true
        legalNameLabel.isSkeletonable = true
        return legalNameLabel
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#D5D5D5")
        lineView1.isSkeletonable = true
        return lineView1
    }()
    
    lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = .init(cssStr: "#D5D5D5")
        lineView2.isSkeletonable = true
        return lineView2
    }()
    
    lazy var lineView3: UIView = {
        let lineView3 = UIView()
        lineView3.backgroundColor = .init(cssStr: "#F5F5F5")
        lineView3.isSkeletonable = true
        return lineView3
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = .init(cssStr: "#666666")
        moneyLabel.textAlignment = .left
        moneyLabel.font = .regularFontOfSize(size: 12)
        moneyLabel.isSkeletonable = true
        return moneyLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#666666")
        timeLabel.textAlignment = .left
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.isSkeletonable = true
        return timeLabel
    }()
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        tagListView.isSkeletonable = true
        return tagListView
    }()
    
    lazy var phoneImageView: UIImageView = {
        let phoneImageView = UIImageView()
        phoneImageView.image = UIImage(named: "phoneimagef")
        phoneImageView.isSkeletonable = true
        return phoneImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = .init(cssStr: "#547AFF")
        phoneLabel.textAlignment = .left
        phoneLabel.font = .regularFontOfSize(size: 12)
        phoneLabel.isSkeletonable = true
        return phoneLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(focusBtn)
        contentView.addSubview(legalNameLabel)
        contentView.addSubview(lineView1)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(lineView2)
        contentView.addSubview(timeLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(lineView3)
        contentView.addSubview(phoneImageView)
        contentView.addSubview(phoneLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 27.pix(), height: 27.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11.5)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-60)
        }
        focusBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.5)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(14)
        }
        legalNameLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(4)
        }
        lineView1.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.left.equalTo(legalNameLabel.snp.right).offset(7)
            make.width.equalTo(1)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.top.equalTo(legalNameLabel.snp.top)
            make.left.equalTo(lineView1.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
        lineView2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.left.equalTo(moneyLabel.snp.right).offset(7)
            make.width.equalTo(1)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.top.equalTo(legalNameLabel.snp.top)
            make.left.equalTo(lineView2.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(legalNameLabel.snp.left)
            make.top.equalTo(legalNameLabel.snp.bottom).offset(6.5)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(18)
        }
        lineView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagListView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(17)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-32.5)
        }
        phoneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.top.equalTo(lineView3.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(15)
        }
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneImageView.snp.centerY)
            make.left.equalTo(phoneImageView.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
        
        focusBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.focusBlock?()
        }).disposed(by: disposeBag)
        
        legalNameLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let model = model else { return }
                self.popMoreListViewInfo(from: model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: pageDataModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.orgInfo?.orgName ?? ""
            let logoColor = model.orgInfo?.logoColor ?? ""
            logoImageView.image = UIImage.imageOfText(companyName, size: (27.pix(), 27.pix()), bgColor: UIColor.init(cssStr: logoColor)!)
            nameLabel.text = companyName
            
            //关注
            let followStatus = model.followStatus ?? 0
            if followStatus == 1 {
                focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }else {
                focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }
            
            //法人
            legalNameLabel.text = model.leaderVec?.leaderList?.first?.name ?? ""
            //资本
            moneyLabel.text = model.orgInfo?.regCap ?? ""
            //时间
            timeLabel.text = model.orgInfo?.incDate ?? ""
            
            //小标签
            let tagArray = model.labels?.compactMap { $0.name ?? "" } ?? []
            self.tagArray = tagArray
            setupScrollView(tagScrollView: tagListView, tagArray: tagArray)
            
            //电话
            let phone = model.orgInfo?.phone ?? ""
            phoneLabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
            if phone.isEmpty {
                phoneImageView.isHidden = true
                self.lineView3.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
            }else {
                phoneImageView.isHidden = false
                self.lineView3.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-32.5)
                }
            }
            
        }
    }
}

extension HighSearchViewCell {
    
    //多个法定代表人弹窗
    private func popMoreListViewInfo(from model: pageDataModel) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let leaderList = model.leaderVec?.leaderList ?? []
        if leaderList.count > 1 {
            let popMoreListView = PopMoreLegalListView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 220))
            popMoreListView.descLabel.text = "法定代表人\(leaderList.count)"
            popMoreListView.dataList = leaderList
            let alertVc = TYAlertController(alert: popMoreListView, preferredStyle: .alert)!
            popMoreListView.closeBlock = {
                vc?.dismiss(animated: true)
            }
            vc?.present(alertVc, animated: true)
        }else {
            let personId = model.leaderVec?.leaderList?.first?.leaderId ?? ""
            let peopleName = model.leaderVec?.leaderList?.first?.name ?? ""
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.personId.accept(personId)
            peopleDetailVc.peopleName.accept(peopleName)
            vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        
    }
    
}

extension HighSearchViewCell {
    
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
        self.lineView3.snp.updateConstraints { make in
            make.top.equalTo(tagListView.snp.bottom).offset(8)
        }
        openButton.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    // 按钮点击事件
    @objc func didOpenTags(_ sender: UIButton) {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray) // 重新设置标签
    }
    
}
