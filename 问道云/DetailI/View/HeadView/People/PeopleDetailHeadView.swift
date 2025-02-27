//
//  PeopleDetailHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//

import UIKit
import RxRelay

class PeopleDetailHeadView: BaseView {
    
    //是否点击了展开是收起
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagArray = BehaviorRelay<[String]>(value: [])
    
    var moreBtnBlock: (() -> Void)?
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    //问道图谱
    var oneItems: [Item]? {
        didSet {
            altascollectionView.reloadData()
        }
    }

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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneRiskView: DetailRiskItemView = {
        let oneRiskView = DetailRiskItemView()
        return oneRiskView
    }()
    
    lazy var twoRiskView: DetailRiskItemView = {
        let twoRiskView = DetailRiskItemView()
        return twoRiskView
    }()
    
    lazy var threeRiskView: DetailRiskItemView = {
        let threeRiskView = DetailRiskItemView()
        return threeRiskView
    }()
    
    lazy var fourRiskView: DetailRiskItemView = {
        let fourRiskView = DetailRiskItemView()
        return fourRiskView
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
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timelabel.textAlignment = .left
        timelabel.font = .regularFontOfSize(size: 10)
        return timelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .mediumFontOfSize(size: 12)
        return desclabel
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
        parImageView.image = UIImage(named: "hezuohuobanimage")
        return parImageView
    }()
    
    lazy var onenumlabel: UILabel = {
        let onenumlabel = UILabel()
        onenumlabel.textColor = UIColor.init(cssStr: "#58408B")
        onenumlabel.textAlignment = .center
        onenumlabel.font = .mediumFontOfSize(size: 12)
        return onenumlabel
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
    
    //问道图谱
    lazy var altascollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let altascollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        altascollectionView.delegate = self
        altascollectionView.dataSource = self
        altascollectionView.showsVerticalScrollIndicator = false
        altascollectionView.register(CompanyDetailCommonServiceCell.self, forCellWithReuseIdentifier: "CompanyDetailCommonServiceCell")
        altascollectionView.showsHorizontalScrollIndicator = false
        return altascollectionView
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
        riskView.addSubview(scrollView)
        scrollView.addSubview(oneRiskView)
        scrollView.addSubview(twoRiskView)
        scrollView.addSubview(threeRiskView)
        scrollView.addSubview(fourRiskView)

        scrollView.snp.makeConstraints { make in
            make.left.equalTo(riskImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-4)
            make.height.equalTo(60)
        }
        oneRiskView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(105)
        }
        twoRiskView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(oneRiskView.snp.right).offset(6)
            make.width.equalTo(105)
        }
        threeRiskView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(twoRiskView.snp.right).offset(6)
            make.width.equalTo(105)
        }
        fourRiskView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(threeRiskView.snp.right).offset(6)
            make.width.equalTo(105)
            make.right.equalToSuperview().offset(-5)
        }
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
        atlasView.addSubview(altascollectionView)
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
        
        //动态
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
        activityView.addSubview(timelabel)
        activityView.addSubview(desclabel)
        timelabel.snp.makeConstraints { make in
            make.left.equalTo(activityImageView.snp.right).offset(6.5)
            make.top.equalToSuperview().offset(6.5)
            make.height.equalTo(14)
        }
        
        desclabel.snp.makeConstraints { make in
            make.left.equalTo(activityImageView.snp.right).offset(6.5)
            make.top.equalTo(timelabel.snp.bottom).offset(4)
            make.height.equalTo(16.5)
        }
        
        threelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(activityView.snp.bottom)
        }
        
        //合作伙伴
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
        parImageView.addSubview(onenumlabel)
        onenumlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 14))
            make.bottom.equalToSuperview().offset(-1)
        }
        pcollectionView.snp.makeConstraints { make in
            make.left.equalTo(parImageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(65)
            make.right.equalToSuperview().offset(-5)
        }
        
        //图谱
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
        altascollectionView.snp.makeConstraints { make in
            make.left.equalTo(atlasImageView.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.right.equalToSuperview().offset(-5)
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
        if collectionView == self.pcollectionView {
            return CGSize(width: 120, height: 65)
        }else {
            return CGSize(width: 80, height: 60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.pcollectionView {
            let model = self.model.value
            return model?.shareholderList?.count ?? 0
        }else {
            return oneItems?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.pcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoPeopleCoopViewCell", for: indexPath) as! TwoPeopleCoopViewCell
            let model = self.model.value?.shareholderList?[indexPath.row]
            cell.model1.accept(model)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyDetailCommonServiceCell", for: indexPath) as! CompanyDetailCommonServiceCell
            cell.bgImageView.image = UIImage(named: oneItems?[indexPath.row].imageResource ?? "")
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewControllerUtils.findViewController(from: self)
        if collectionView == self.pcollectionView {
            let model = self.model.value?.shareholderList?[indexPath.row]
            let vc = ViewControllerUtils.findViewController(from: self)
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.enityId.accept(String(model?.personId ?? 0))
            peopleDetailVc.peopleName.accept(model?.personName ?? "")
            vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }else {
            let model = self.oneItems?[indexPath.row]
            let pageUrl = model?.path ?? ""
            vc?.pushWebPage(from: pageUrl)
        }
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
                TagsLabelColorConfig.nameLabelColor(from: lab)
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

}

