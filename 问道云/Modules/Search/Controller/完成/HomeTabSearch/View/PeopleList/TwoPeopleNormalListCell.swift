//
//  TwoPeopleNormalListCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxRelay
import SnapKit

class TwoPeopleNormalListCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 4
        ctImageView.isSkeletonable = true
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
    
    // 创建一个容器视图，来放置这些动态生成的 labels
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical   // 垂直排列
        stackView.spacing = 2       // label 之间的间距
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var cooperationLabel: UILabel = {
        let cooperationLabel = UILabel()
        cooperationLabel.textColor = .init(cssStr: "#999999")
        cooperationLabel.font = .regularFontOfSize(size: 13)
        cooperationLabel.textAlignment = .left
        cooperationLabel.text = "TA的合作伙伴:"
        cooperationLabel.isSkeletonable = true
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
    
    lazy var addFocusBtn: UIButton = {
        let addFocusBtn = UIButton(type: .custom)
        addFocusBtn.isSkeletonable = true
        addFocusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        return addFocusBtn
    }()
    
    var listViews: [CompanyListView] = []
    
    private var collectionViewHeightConstraint: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(lineView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(cooperationLabel)
        contentView.addSubview(collectionView)
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
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        cooperationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.height.equalTo(18.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cooperationLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(0)
        }
        
        addFocusBtn.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(14)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            self.collectionView.reloadData()
            self.ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.personName ?? "", size: (40, 40), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            
            nameLabel.text = model.personName ?? ""
            
            let moduleId = model.moduleId ?? ""
            if moduleId == "14" {
                let count = String(model.riskCount ?? 0)
                self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条法院公告相关记录", font: .regularFontOfSize(size: 13))
            }else {
                let count = String(model.companyCount ?? 0)
                self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共关联\(count)家企业", font: .regularFontOfSize(size: 13))
            }
            
            //关联公司
            if let listCompany = model.listCompany {
                configureLabels(with: listCompany)
            }
            
            let shareholderListCount = model.shareholderList?.count ?? 0
            if shareholderListCount > 0 {
                self.cooperationLabel.attributedText = GetRedStrConfig.getRedStr(from: String(shareholderListCount), fullText: "TA的合作伙伴(\(shareholderListCount)):", font: UIFont.regularFontOfSize(size: 13))
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(69.5)
                }
            }else {
                self.cooperationLabel.text = "TA的合作伙伴: 暂无合作伙伴信息"
                self.collectionView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            
            let follow = model.follow ?? true
            if follow {
                addFocusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }else {
                addFocusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }
            
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

extension TwoPeopleNormalListCell {
    
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

/** 网络数据请求 */
extension TwoPeopleNormalListCell {
    
    //添加关注
    private func addFocusInfo(from model: itemsModel, focusBtn: UIButton) {
        ViewHud.addLoadView()
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
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
    //取消关注
    private func deleteFocusInfo(from model: itemsModel, focusBtn: UIButton) {
        ViewHud.addLoadView()
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
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
}

extension TwoPeopleNormalListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
