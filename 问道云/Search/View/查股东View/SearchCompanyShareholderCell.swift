//
//  SearchCompanyShareholderCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay

class SearchCompanyShareholderCell: BaseViewCell {
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagArray: [String] = []
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        return nameLabel
    }()
    
    //标签
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        return tagListView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.layer.cornerRadius = 3
        grayView.backgroundColor = .init(cssStr: "#F8F8F8")
        return grayView
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
        moneyView.lineView.isHidden = false
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        return timeView
    }()
    
    lazy var addressimageView: UIImageView = {
        let addressimageView = UIImageView()
        addressimageView.image = UIImage(named: "adressimageicon")
        addressimageView.contentMode = .scaleAspectFill
        addressimageView.isUserInteractionEnabled = true
        return addressimageView
    }()
    
    lazy var websiteimageView: UIImageView = {
        let websiteimageView = UIImageView()
        websiteimageView.image = UIImage(named: "guanwangimage")
        websiteimageView.contentMode = .scaleAspectFill
        websiteimageView.isUserInteractionEnabled = true
        return websiteimageView
    }()
    
    lazy var phoneimageView: UIImageView = {
        let phoneimageView = UIImageView()
        phoneimageView.image = UIImage(named: "dianhuaimageicon")
        phoneimageView.contentMode = .scaleAspectFill
        phoneimageView.isUserInteractionEnabled = true
        return phoneimageView
    }()
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        focusBtn.adjustsImageWhenHighlighted = false
        focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        return focusBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EBEBEB")
        return lineView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.textColor = .init(cssStr: "#999999")
        websiteLabel.font = .regularFontOfSize(size: 13)
        websiteLabel.textAlignment = .left
        return websiteLabel
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F8F9FB")
        return footerView
    }()
    
    lazy var tImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.image = UIImage(named: "xiangqingyembtmimage")
        return tImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(grayView)
        grayView.addSubview(nameView)
        grayView.addSubview(moneyView)
        grayView.addSubview(timeView)
        contentView.addSubview(numLabel)
        contentView.addSubview(stackView)
        
        contentView.addSubview(lineView)
        contentView.addSubview(addressimageView)
        contentView.addSubview(websiteimageView)
        contentView.addSubview(phoneimageView)
        contentView.addSubview(focusBtn)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(footerView)
        contentView.addSubview(tImageView)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(11)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top).offset(-1)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(8)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(15)
        }
        grayView.snp.makeConstraints { make in
            make.top.equalTo(tagListView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(43.5)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalToSuperview().offset(5.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalToSuperview().offset(5.5)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalToSuperview().offset(5.5)
            make.height.equalTo(36)
            make.right.equalToSuperview()
        }
        
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(grayView.snp.bottom).offset(6)
            make.height.equalTo(18.5)
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(numLabel.snp.left)
            make.width.equalTo(SCREEN_WIDTH - 43.5)
            make.top.equalTo(numLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-48)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        addressimageView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalToSuperview().offset(-12)
        }
        
        websiteimageView.snp.makeConstraints { make in
            make.top.equalTo(addressimageView.snp.top)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalTo(addressimageView.snp.left).offset(-8)
        }
        
        phoneimageView.snp.makeConstraints { make in
            make.top.equalTo(addressimageView.snp.top)
            make.size.equalTo(CGSize(width: 47, height: 21))
            make.right.equalTo(websiteimageView.snp.left).offset(-8)
        }
        focusBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.5)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(14)
        }
        websiteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneimageView.snp.centerY)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(15)
            make.right.equalTo(phoneimageView.snp.left).offset(-5)
        }
        footerView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        tImageView.snp.makeConstraints { make in
            make.centerY.equalTo(numLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 15))
            make.right.equalToSuperview().offset(-12)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.entityName ?? ""
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (40, 40)))
            nameLabel.text = name
            
            //小标签
            self.tagArray = model.tags?.compactMap { $0.name ?? "" } ?? []
            setupScrollView(tagScrollView: tagListView, tagArray: tagArray)
            
            nameView.label2.text = model.legalName ?? ""
            nameView.label2.textColor = .init(cssStr: "#3849F7")
            
            moneyView.label2.text = model.registerCapital ?? ""
            moneyView.label2.textColor = .init(cssStr: "#333333")
            
            timeView.label2.text = model.incorporationTime ?? ""
            timeView.label2.textColor = .init(cssStr: "#333333")
            
            websiteLabel.text = "网站名称: \(name)"
            
            let count = model.relatedEntity?.count ?? 0
            if count != 0 {
                numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "共担任\(count)家企业股东,详情如下:")
            } else {
                numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "共担任\(count)家企业股东,详情如下: 暂无信息")
            }
            configure(with: model.relatedEntity ?? [])
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchCompanyShareholderCell {
    
    func configure(with dynamiccontent: [relatedEntityModel]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for model in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#333333")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 13)
            let name = model.entityName ?? ""
            let persent = PercentageConfig.formatToPercentage(value: model.percent ?? 0.0)
            label.attributedText = GetRedStrConfig.getRedStr(from: "\(persent)", fullText: "\(name) (\(persent))")
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(label)
        }
    }
    
    func setupScrollView(tagScrollView: UIScrollView, tagArray: [String]) {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let maxWidth = UIScreen.main.bounds.width - 80 // 标签展示最大宽度（左右各 20 的边距）
        let openButtonWidth: CGFloat = 35 // 展开按钮宽度
        let buttonHeight: CGFloat = 16 // 标签高度
        let buttonSpacing: CGFloat = 5 // 标签之间的间距
        var numberOfLine: CGFloat = 1 // 标签总行数
        var lastRight: CGFloat = 2 // 标签的左边距
        let isOpen = companyModel.isOpenTag // 标签展开或者收起
        
        // 创建展开/收起按钮
        let openButton = UIButton(type: .custom)
        openButton.titleLabel?.font = .regularFontOfSize(size: 10)
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
            let tag = "\(tags)   "
            let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 11)])
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
                let tag = "\(tags)   "
                let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.regularFontOfSize(size: 11)])
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
                let lab = PaddedLabel()
                lab.font = .regularFontOfSize(size: 11)
                lab.textColor = UIColor(cssStr: "#ECF2FF")
                lab.backgroundColor = UIColor(cssStr: "#93B2F5")
                lab.layer.masksToBounds = true
                lab.layer.cornerRadius = 2
                lab.textAlignment = .center
                lab.text = "\(tags)   "
                TagsLabelColorConfig.nameLabelColor(from: lab)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width + 3  // 增加左右 padding
                
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
        //        self.lineView.snp.updateConstraints { make in
        //            make.top.equalTo(tagListView.snp.bottom).offset(60)
        //        }
        openButton.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    // 按钮点击事件
    @objc func didOpenTags(_ sender: UIButton) {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray) // 重新设置标签
    }
    
}
