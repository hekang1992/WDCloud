//
//  SearchPeopleShareholderCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay

class SearchPeopleShareholderCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isSkeletonable = true
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.isSkeletonable = true
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .left
        numLabel.isSkeletonable = true
        return numLabel
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.isSkeletonable = true
        return stackView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "TA的合作伙伴:"
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.isSkeletonable = true
        return descLabel
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F8F8F8")
        footerView.isSkeletonable = true
        return footerView
    }()
    
    lazy var tImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.image = UIImage(named: "xiangqingyembtmimage")
        tImageView.isSkeletonable = true
        return tImageView
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
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    lazy var monitoringBtn: UIButton = {
        let monitoringBtn = UIButton(type: .custom)
        monitoringBtn.isSkeletonable = true
        monitoringBtn.setImage(UIImage(named: "jiankonganniu"), for: .normal)
        monitoringBtn.isSkeletonable = true
        return monitoringBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(footerView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(descLabel)
        contentView.addSubview(tImageView)
        contentView.addSubview(collectionView)
        contentView.addSubview(monitoringBtn)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(11)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top).offset(7)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(10)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
        }
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(ctImageView.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-35)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.left.equalTo(stackView.snp.left)
            make.height.equalTo(18.5)
        }
        tImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 15))
            make.right.equalToSuperview().offset(-12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-6)
        }
        monitoringBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.height.equalTo(20)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model, let name = model.personName, !name.isEmpty else { return }
            
            let logoColor = UIColor.init(cssStr: model.logoColor ?? "")!
            
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (40, 40), bgColor: logoColor))
            nameLabel.text = name
            
            let count = model.listCompany?.count ?? 0
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "共担任\(count)家企业股东")
            
            let listCompany = model.listCompany ?? []
            configure(with: Array(listCompany.prefix(3)))
            
            let shareholderList = model.shareholderList ?? []
            let count1 = String(shareholderList.count)
            if shareholderList.isEmpty {
                descLabel.text = "TA的合作伙伴: 暂无合作伙伴信息"
                stackView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-35)
                }
            }else {
                descLabel.attributedText = GetRedStrConfig.getRedStr(from: count1, fullText: "TA的合作伙伴(\(count1)):", font: UIFont.regularFontOfSize(size: 13))
                stackView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-115)
                }
            }
            
            //是否被监控
            let monitor = model.monitor ?? false
            if monitor {
                monitoringBtn.setImage(UIImage(named: "havejiankong"), for: .normal)
            }else {
                monitoringBtn.setImage(UIImage(named: "jiankonganniu"), for: .normal)
            }
            
            collectionView.reloadData()
        }).disposed(by: disposeBag)
        
        monitoringBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.model.value else { return }
            let monitor = model.monitor ?? false
            if monitor {//取消监控
                cancelMonitrongInfo(from: monitoringBtn, model: model)
            }else {//添加监控
                addMonitrongInfo(from: monitoringBtn, model: model)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchPeopleShareholderCell {
    
    func configure(with dynamiccontent: [listCompanyModel]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for model in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#333333")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 13)
            let name = model.entityName ?? ""
            let persent = model.percent ?? ""
            label.attributedText = GetRedStrConfig.getRedStr(from: "\(persent)", fullText: "\(name) (\(persent))")
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(label)
        }
    }
}

extension SearchPeopleShareholderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
extension SearchPeopleShareholderCell {
    
    //添加监控
    private func addMonitrongInfo(from btn: UIButton, model: itemsModel) {
        let man = RequestManager()
        let dict = ["personId": model.personId ?? "", "groupId": ""]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-person/addRiskMonitorPerson",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.monitor = true
                    btn.setImage(UIImage(named: "havejiankong"), for: .normal)
                    ToastViewConfig.showToast(message: "监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消监控
    private func cancelMonitrongInfo(from btn: UIButton, model: itemsModel) {
        let man = RequestManager()
        let dict = ["personId": model.personId ?? "", "groupId": ""]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-person/cancelRiskMonitorPerson",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.monitor = false
                    btn.setImage(UIImage(named: "jiankonganniu"), for: .normal)
                    ToastViewConfig.showToast(message: "取消监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
