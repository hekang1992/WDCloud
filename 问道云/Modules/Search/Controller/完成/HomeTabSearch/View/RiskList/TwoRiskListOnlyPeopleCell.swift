//
//  TwoRiskListOnlyPeopleCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxRelay

class TwoRiskListOnlyPeopleCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    var lastView: CompanyListView?//记录公司列表信息的最后一个
    
    var focusBlock: ((pageDataModel) -> Void)?
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F5F5F5")
        return footerView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 4
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .right
        return numLabel
    }()
    
    // 创建一个容器视图，来放置这些动态生成的listView
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    lazy var cooperationLabel: UILabel = {
        let cooperationLabel = UILabel()
        cooperationLabel.textColor = .init(cssStr: "#999999")
        cooperationLabel.font = .regularFontOfSize(size: 13)
        cooperationLabel.textAlignment = .left
        cooperationLabel.text = "TA的合作伙伴:"
        return cooperationLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TwoPeopleCoopViewCell.self, forCellWithReuseIdentifier: "TwoPeopleCoopViewCell")
        return collectionView
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
    
    lazy var addFocusBtn: UIButton = {
        let addFocusBtn = UIButton(type: .custom)
        addFocusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        return addFocusBtn
    }()
    
    var listViews: [CompanyListView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(cooperationLabel)
        contentView.addSubview(redView)
        redView.addSubview(riskImageView)
        redView.addSubview(rightImageView)
        redView.addSubview(riskTimeLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(lineView)
        contentView.addSubview(oneNumLabel)
        contentView.addSubview(twoNumLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(footerView)
        contentView.addSubview(addFocusBtn)
        
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
        }
        addFocusBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.height.equalTo(14)
        }
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        redView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(containerView.snp.bottom).offset(2)
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
        
        cooperationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(redView.snp.bottom).offset(8)
            make.height.equalTo(18.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cooperationLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(0)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-38)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
        
        oneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(7)
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
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(16.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            let logoColor = model.logoColor ?? ""
            self.ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.personName ?? "", size: (40, 40), bgColor: UIColor.init(cssStr: logoColor)!))
            
            nameLabel.text = model.personName ?? ""
            
            let count = String(model.companyCount ?? 0)
            self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共关联\(count)家企业", font: .regularFontOfSize(size: 13))
            
            //关联公司
            if let listCompany = model.listCompany {
                configureLabels(with: listCompany)
            }
            
            //riskinfo
            let riskInfo = model.riskInfo
            
            let listcount = self.model.value?.shareholderList?.count ?? 0
            if listcount == 0 {
                self.cooperationLabel.text = "TA的合作伙伴:暂无合作伙伴信息"
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }else {
                self.cooperationLabel.text = "TA的合作伙伴:"
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(69.5)
                }
            }
            
            self.nameLabel.attributedText = GetRedStrConfig.getRedStr(from: model.searchStr ?? "", fullText: model.personName ?? "", colorStr: "#F55B5B", font: .mediumFontOfSize(size: 14))
            
            let riskOne = String(model.riskNum1 ?? 0)
            let riskTwo = String(model.riskNum2 ?? 0)
            self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskOne, fullText: "共\(riskOne)条自身风险", font: .regularFontOfSize(size: 12))
            self.twoNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskTwo, fullText: "\(riskTwo)条关联风险", font: .regularFontOfSize(size: 12))
            
            //是否关注
            let follow = model.follow ?? true
            if follow {
                addFocusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }else {
                addFocusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }
            
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        addFocusBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.model.value else { return }
            let follow = model.follow ?? true
            if follow {//取消关注
                deleteFocusInfo(from: model, focusBtn: addFocusBtn)
            }else {//去关注
                addFocusInfo(from: model, focusBtn: addFocusBtn)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoRiskListOnlyPeopleCell {
    
    func configureLabels(with data: [listCompanyModel]) {
        // 清空之前的所有 UILabel
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        // 为每个数据项创建一个新的 listView
        for model in data {
            let listView = CompanyListView()
            
            let companyCountText = String(model.count ?? 0)
            
            let fullText = "\(model.province ?? "") \(companyCountText)"
            
            listView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: companyCountText, fullText: fullText)
            
            listView.nameLabel.text = model.orgName ?? ""
            
            listViews.append(listView)
            listView.heightAnchor.constraint(equalToConstant: 18.5).isActive = true
            containerView.addArrangedSubview(listView)
        }
    }
    
}

extension TwoRiskListOnlyPeopleCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 69.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.model.value?.shareholderList?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoPeopleCoopViewCell", for: indexPath) as! TwoPeopleCoopViewCell
        let model = self.model.value?.shareholderList?[indexPath.row]
        cell.model.accept(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.model.value?.shareholderList?[indexPath.row]
        let vc = ViewControllerUtils.findViewController(from: self)
        let peopleDetailVc = PeopleBothViewController()
        peopleDetailVc.personId.accept(String(model?.personId ?? 0))
        peopleDetailVc.peopleName.accept(model?.personName ?? "")
        vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension TwoRiskListOnlyPeopleCell {
    
    //添加关注
    private func addFocusInfo(from model: itemsModel, focusBtn: UIButton) {
        let man = RequestManager()
        let dict = ["entityId": model.personId ?? "",
                    "followTargetType": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.follow = true
                    focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    ToastViewConfig.showToast(message: "关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    private func deleteFocusInfo(from model: itemsModel, focusBtn: UIButton) {
        let man = RequestManager()
        let dict = ["entityId": model.personId ?? "",
                    "followTargetType": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.follow = false
                    focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    ToastViewConfig.showToast(message: "取消关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
