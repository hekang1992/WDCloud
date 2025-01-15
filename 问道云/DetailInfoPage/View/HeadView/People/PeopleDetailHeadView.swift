//
//  PeopleDetailHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/15.
//

import UIKit
import RxRelay

class PeopleDetailHeadView: BaseView {
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagArray = BehaviorRelay<[String]>(value: [])
    
    var moreBtnBlock: (() -> Void)?
    
    var model = BehaviorRelay<DataModel?>(value: nil)

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
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        tagListView.showsVerticalScrollIndicator = false
        tagListView.showsHorizontalScrollIndicator = false
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
        moreButton.setTitleColor(.init(cssStr: "#3F96FF"), for: .normal)
        moreButton.setTitle("展开", for: .normal)
        return moreButton
    }()
    
    lazy var onelineView: UIView = {
        let onelineView = UIView()
        onelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return onelineView
    }()
    
    //风险
    lazy var riskView: UIView = {
        let riskView = UIView()
        return riskView
    }()
    
    lazy var riskImageView: UIImageView = {
        let riskImageView = UIImageView()
        riskImageView.image = UIImage(named: "detailriskicon")
        return riskImageView
    }()
    
    lazy var twolineView: UIView = {
        let twolineView = UIView()
        twolineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return twolineView
    }()
    
    //动态
    lazy var activityView: UIView = {
        let activityView = UIView()
        return activityView
    }()
    
    lazy var activityImageView: UIImageView = {
        let activityImageView = UIImageView()
        activityImageView.image = UIImage(named: "detaildongicon")
        return activityImageView
    }()
    
    lazy var threelineView: UIView = {
        let threelineView = UIView()
        threelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return threelineView
    }()
    
    //合作伙伴
    lazy var partnerView: UIView = {
        let partnerView = UIView()
        return partnerView
    }()
    
    lazy var parImageView: UIImageView = {
        let parImageView = UIImageView()
        parImageView.image = UIImage(named: "wenpuicon")
        return parImageView
    }()
    
    lazy var fourlineView: UIView = {
        let fourlineView = UIView()
        fourlineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return fourlineView
    }()
    
    //图谱
    lazy var atlasView: UIView = {
        let atlasView = UIView()
        return atlasView
    }()
    
    lazy var atlasImageView: UIImageView = {
        let atlasImageView = UIImageView()
        atlasImageView.image = UIImage(named: "wenpuicon")
        return atlasImageView
    }()
    
    lazy var fivelineView: UIView = {
        let fivelineView = UIView()
        fivelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return fivelineView
    }()
    
    lazy var pcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let pcollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pcollectionView.delegate = self
        pcollectionView.dataSource = self
        pcollectionView.translatesAutoresizingMaskIntoConstraints = false
        pcollectionView.backgroundColor = .white
        pcollectionView.showsHorizontalScrollIndicator = false
        pcollectionView.showsVerticalScrollIndicator = false
        pcollectionView.register(TwoPeopleCoopViewCell.self, forCellWithReuseIdentifier: "TwoPeopleCoopViewCell")
        return pcollectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(iconImageView)
        addSubview(namelabel)
        addSubview(tagListView)
        addSubview(desLabel)
        addSubview(moreButton)
        addSubview(onelineView)
        
        addSubview(riskView)
        riskView.addSubview(riskImageView)
        addSubview(twolineView)
        
        addSubview(activityView)
        activityView.addSubview(activityImageView)
        addSubview(threelineView)
        //合作伙伴
        addSubview(partnerView)
        partnerView.addSubview(parImageView)
        partnerView.addSubview(pcollectionView)
        addSubview(fourlineView)
        
        addSubview(atlasView)
        atlasView.addSubview(atlasImageView)
        addSubview(fivelineView)
        
        lineView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview().offset(17)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.height.equalTo(22.5)
        }
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(5)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(15)
        }
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.5)
            make.width.equalTo(SCREEN_WIDTH - 65)
            make.top.equalTo(tagListView.snp.bottom).offset(3)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(desLabel.snp.centerY)
            make.left.equalTo(desLabel.snp.right).offset(10)
            make.size.equalTo(CGSize(width: 24, height: 16.5))
        }
        onelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(tagListView.snp.bottom).offset(28)
        }
        
        riskView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(76)
            make.top.equalTo(onelineView.snp.bottom)
        }
        riskImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 17, height: 60))
        }
        twolineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(riskView.snp.bottom)
        }
        
        
        activityView.snp.makeConstraints { make in
            make.height.equalTo(43)
            make.left.right.equalToSuperview()
            make.top.equalTo(twolineView.snp.bottom)
        }
        activityImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 18, height: 33))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        threelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(activityView.snp.bottom)
        }
        
        partnerView.snp.makeConstraints { make in
            make.height.equalTo(81)
            make.left.right.equalToSuperview()
            make.top.equalTo(threelineView.snp.bottom)
        }
        fourlineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(partnerView.snp.bottom)
        }
        parImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 17, height: 60))
        }
        pcollectionView.snp.makeConstraints { make in
            make.left.equalTo(parImageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(65)
            make.right.equalToSuperview().offset(-5)
        }
        
        
        atlasView.snp.makeConstraints { make in
            make.height.equalTo(73)
            make.left.right.equalToSuperview()
            make.top.equalTo(fourlineView.snp.bottom)
        }
        atlasImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 17, height: 60))
        }
        fivelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(atlasView.snp.bottom)
        }
        
        tagArray.asObservable().subscribe(onNext: { [weak self] tags in
            guard let self = self else { return }
            setupScrollView(tagScrollView: tagListView, tagArray: tags)
        }).disposed(by: disposeBag)
        
        moreButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.moreBtnBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PeopleDetailHeadView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = self.model.value
        if collectionView == self.pcollectionView {
            return model?.shareholderList?.count ?? 0
        }
//        let count = self.model.value?.shareholderList?.count ?? 0
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoPeopleCoopViewCell", for: indexPath) as! TwoPeopleCoopViewCell
        let model = self.model.value?.shareholderList?[indexPath.row]
        cell.model1.accept(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.model.value?.shareholderList?[indexPath.row]
        print("model:\(model?.personId ?? 0)")
    }
    
}
extension PeopleDetailHeadView {
    
    func setupScrollView(tagScrollView: UIScrollView, tagArray: [String]) {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let maxWidth = UIScreen.main.bounds.width - 80 // 标签展示最大宽度（左右各 20 的边距）
        let openButtonWidth: CGFloat = 35 // 展开按钮宽度
        let buttonHeight: CGFloat = 15 // 标签高度
        let buttonSpacing: CGFloat = 2 // 标签之间的间距
        var numberOfLine: CGFloat = 1 // 标签总行数
        var lastRight: CGFloat = 0 // 标签的左边距
        let isOpen = companyModel.isOpenTag // 标签展开或者收起
        
        // 创建展开/收起按钮
        let openButton = UIButton(type: .custom)
        openButton.titleLabel?.font = .regularFontOfSize(size: 10)
        openButton.backgroundColor = UIColor(cssStr: "#3F96FF")?.withAlphaComponent(0.1)
        openButton.setTitle("展开", for: .normal)
        openButton.setTitleColor(UIColor(cssStr: "#3F96FF"), for: .normal)
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
                let lab = UILabel()
                lab.font = .regularFontOfSize(size: 11)
                lab.textColor = UIColor(cssStr: "#ECF2FF")
                lab.backgroundColor = UIColor(cssStr: "#93B2F5")
                lab.layer.masksToBounds = true
                lab.layer.cornerRadius = 2
                lab.textAlignment = .center
                lab.text = "\(tags)   "
                self.nameLabelColor(from: lab)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width  // 增加左右 padding
                
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
        self.onelineView.snp.updateConstraints { make in
            make.top.equalTo(tagListView.snp.bottom).offset(30)
        }
        openButton.layoutButtonEdgeInsets(style: .right, space: 2)
    }
    
    // 按钮点击事件
    @objc func didOpenTags(_ sender: UIButton) {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView(tagScrollView: tagListView, tagArray: tagArray.value) // 重新设置标签
    }

    func nameLabelColor(from tagView: UILabel) {
        let currentTitle = tagView.text ?? ""
        if currentTitle.contains("经营异常") || currentTitle.contains("被执行人") || currentTitle.contains("失信被执行人") || currentTitle.contains("限制高消费") || currentTitle.contains("票据违约") || currentTitle.contains("债券违约") {
            tagView.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.1)
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }else if currentTitle.contains("存续") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#4DC929")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("注销") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#FF7D00")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("吊销")  {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("小微企业") || currentTitle.contains("高新技术企业") || currentTitle.contains("国有控股") || currentTitle.contains("国有独资") || currentTitle.contains("国有全资") || currentTitle.contains("深主板") || currentTitle.contains("沪主板") || currentTitle.contains("港交所") || currentTitle.contains("北交所") || currentTitle.contains("发债"){
            tagView.backgroundColor = .init(cssStr: "#3F96FF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#3F96FF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        } else {
            tagView.backgroundColor = .init(cssStr: "#3F96FF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#3F96FF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }
    
    }
    
}

