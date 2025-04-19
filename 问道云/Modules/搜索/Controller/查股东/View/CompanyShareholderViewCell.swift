//
//  CompanyShareholderViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/17.
//

import UIKit
import MapKit
import RxRelay
import TYAlertController

class CompanyShareholderViewCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isSkeletonable = true
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        namelabel.isSkeletonable = true
        namelabel.numberOfLines = 0
        return namelabel
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.font = .regularFontOfSize(size: 10)
        tagLabel.layer.cornerRadius = 2.5
        tagLabel.layer.masksToBounds = true
        tagLabel.isSkeletonable = true
        return tagLabel
    }()
    
    lazy var addFoucsBtn: UIButton = {
        let addFoucsBtn = UIButton(type: .custom)
        addFoucsBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        addFoucsBtn.isSkeletonable = true
        return addFoucsBtn
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .init(cssStr: "#F8F8F8")
        coverView.layer.cornerRadius = 3
        coverView.isHidden = true
        return coverView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textAlignment = .left
        return descLabel
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
    
    lazy var tImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.image = UIImage(named: "xiangqingyembtmimage")
        tImageView.isSkeletonable = true
        return tImageView
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
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F5F5F5")
        return footerView
    }()
    
    lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.textColor = .init(cssStr: "#999999")
        websiteLabel.font = .regularFontOfSize(size: 11)
        return websiteLabel
    }()
    
    lazy var addressimageView: UIImageView = {
        let addressimageView = UIImageView()
        addressimageView.image = UIImage(named: "adressimageicon")
        addressimageView.contentMode = .scaleAspectFill
        addressimageView.isUserInteractionEnabled = true
        addressimageView.isHidden = true
        return addressimageView
    }()
    
    lazy var websiteimageView: UIImageView = {
        let websiteimageView = UIImageView()
        websiteimageView.image = UIImage(named: "guanwangimage")
        websiteimageView.contentMode = .scaleAspectFill
        websiteimageView.isUserInteractionEnabled = true
        websiteimageView.isHidden = true
        return websiteimageView
    }()
    
    lazy var phoneimageView: UIImageView = {
        let phoneimageView = UIImageView()
        phoneimageView.image = UIImage(named: "dianhuaimageicon")
        phoneimageView.contentMode = .scaleAspectFill
        phoneimageView.isUserInteractionEnabled = true
        phoneimageView.isHidden = true
        return phoneimageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(addFoucsBtn)
        contentView.addSubview(coverView)
        coverView.addSubview(nameView)
        coverView.addSubview(moneyView)
        coverView.addSubview(timeView)
        contentView.addSubview(descLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(tImageView)
        contentView.addSubview(footerView)
        contentView.addSubview(lineView)
        contentView.addSubview(websiteLabel)
        contentView.addSubview(addressimageView)
        contentView.addSubview(websiteimageView)
        contentView.addSubview(phoneimageView)
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(12)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH - 110)
            make.height.lessThanOrEqualTo(40)
        }
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(4.5)
            make.height.equalTo(20)
        }
        addFoucsBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17.5)
            make.right.equalToSuperview().offset(-15.5)
            make.height.equalTo(14)
        }
        coverView.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(6.5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(43.5)
        }
        moneyView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        timeView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(moneyView.snp.right)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(coverView.snp.bottom).offset(6)
            make.height.equalTo(18.5)
        }
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(descLabel.snp.bottom).offset(6)
            make.right.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-36)
        }
        tImageView.snp.makeConstraints { make in
            make.centerY.equalTo(stackView.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 30, height: 15))
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
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        websiteLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(7)
            make.left.equalTo(ctImageView.snp.left)
            make.size.equalTo(CGSize(width: 185, height: 15))
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            coverView.isHidden = false
            phoneimageView.isHidden = false
            websiteimageView.isHidden = false
            addressimageView.isHidden = false
            let companyName = model.orgName ?? ""
            let logoColor = model.logoColor ?? ""
            let orgLogo = URL(string: model.orgLogo ?? "")
            ctImageView.kf.setImage(with: orgLogo, placeholder: UIImage.imageOfText(companyName, size: (40, 40), bgColor: UIColor.init(cssStr: logoColor)!))
            namelabel.attributedText = GetRedStrConfig.getRedStr(from: model.searchStr ?? "", fullText: companyName)
            
            nameView.label2.text = model.legalName ?? ""
            moneyView.label2.text = "\(model.regCap ?? "")" + "\(model.regCapCur ?? "")"
            timeView.label2.text = model.incDate ?? ""
            
            let count = String(model.relatedOrgCount ?? 0)
            descLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共担任\(count)家企业股东,详情如下:")
            let relatedOrgList = model.relatedOrgList ?? []
            configure(with: relatedOrgList)
            
            tagLabel.text = model.orgStatus ?? ""
            TagsLabelColorConfig.nameLabelColor(from: tagLabel)
            
            //是否关注
            let follow = model.follow ?? true
            if follow {
                addFoucsBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }else {
                addFoucsBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }
            
            websiteLabel.text = "网站名称: \(companyName)"
            
            
            //电话
            let phone = model.phone ?? []
            //网站
            let website = model.website ?? []
            //经纬度
            let regAddr = model.orgAddress
            let lat = regAddr?.lat ?? ""
            
            if lat.isEmpty {
                addressimageView.isHidden = true
                addressimageView.snp.updateConstraints { make in
                    make.width.equalTo(0)
                    make.right.equalToSuperview().offset(-4)
                }
            }else {
                addressimageView.isHidden = false
                addressimageView.snp.updateConstraints { make in
                    make.width.equalTo(47)
                    make.right.equalToSuperview().offset(-12)
                }
            }
            
            if website.isEmpty {
                websiteimageView.isHidden = true
                websiteimageView.snp.updateConstraints { make in
                    make.width.equalTo(0)
                    make.right.equalTo(self.addressimageView.snp.left)
                }
            }else {
                websiteimageView.isHidden = false
                websiteimageView.snp.updateConstraints { make in
                    make.width.equalTo(47)
                    make.right.equalTo(self.addressimageView.snp.left).offset(-8)
                }
            }
            
            if phone.isEmpty {
                phoneimageView.isHidden = true
                phoneimageView.snp.updateConstraints { make in
                    make.width.equalTo(0)
                    make.right.equalTo(self.websiteimageView.snp.left)
                }
            }else {
                phoneimageView.isHidden = false
                phoneimageView.snp.updateConstraints { make in
                    make.width.equalTo(47)
                    make.right.equalTo(self.websiteimageView.snp.left).offset(-8)
                }
            }
            
        }).disposed(by: disposeBag)
        
        addFoucsBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.model.value else { return }
            let follow = model.follow ?? true
            if follow {//取消监控
                cancelFocusInfo(from: addFoucsBtn, model: model)
            }else {//添加监控
                addFocusInfo(from: addFoucsBtn, model: model)
            }
        }).disposed(by: disposeBag)
        
        addressimageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let model = self.model.value else { return }
                let vc = ViewControllerUtils.findViewController(from: self)
                let latitude = Double(model.orgAddress?.lat ?? "0.0") ?? 0.0
                let longitude = Double(model.orgAddress?.lng ?? "0.0") ?? 0.0
                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let locationVc = CompanyLocationViewController(location: location)
                locationVc.name = model.orgName ?? ""
                vc?.navigationController?.pushViewController(locationVc, animated: true)
        }).disposed(by: disposeBag)
        
        websiteimageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let vc = ViewControllerUtils.findViewController(from: self)
                let webVc = WebPageViewController()
                var pageUrl = self.model.value?.website?.first?.value ?? ""
                if !pageUrl.hasPrefix("http://") && !pageUrl.hasPrefix("https://") {
                    pageUrl = "http://" + pageUrl
                }
                webVc.pageUrl.accept(pageUrl)
                vc?.navigationController?.pushViewController(webVc, animated: true)
        }).disposed(by: disposeBag)
        
        phoneimageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let model = self.model.value else { return }
                popMoreListViewInfo(from: model)
        }).disposed(by: disposeBag)
        
        nameView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let model = self.model.value else { return }
                let vc = ViewControllerUtils.findViewController(from: self)
                let peopleDetailVc = PeopleBothViewController()
                let personId = model.legalId ?? ""
                let peopleName = model.legalName ?? ""
                peopleDetailVc.personId.accept(personId)
                peopleDetailVc.peopleName.accept(peopleName)
                vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }).disposed(by: disposeBag)
        
        namelabel.rx.longPressGesture(configuration: { gesture, _ in
            gesture.minimumPressDuration = 0.3
        }).subscribe(onNext: { [weak self] gesture in
            if let self = self {
                if gesture.state == .began {
                    self.handleLongPressOnLabel(from: namelabel)
                }else if gesture.state == .ended {
                    self.handleEndLongPressOnLabel(from: namelabel)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func handleLongPressOnLabel(from label: UILabel) {
        UIPasteboard.general.string = namelabel.text
        ToastViewConfig.showToast(message: "复制成功")
        label.backgroundColor = .init(cssStr: "#333333")?.withAlphaComponent(0.2)
        HapticFeedbackManager.triggerImpactFeedback(style: .medium)
    }
    
    private func handleEndLongPressOnLabel(from label: UILabel) {
        label.backgroundColor = .clear
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CompanyShareholderViewCell {
    
    //多个法定代表人弹窗
    private func popMoreListViewInfo(from model: itemsModel) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let popMoreListView = PopShareholdePhoneView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 220))
        let leaderList = model.phone ?? []
        popMoreListView.descLabel.text = "电话号码\(leaderList.count)"
        popMoreListView.dataList = leaderList
        let alertVc = TYAlertController(alert: popMoreListView, preferredStyle: .alert)!
        popMoreListView.closeBlock = {
            vc?.dismiss(animated: true)
        }
        vc?.present(alertVc, animated: true)
    }
    
    func configure(with dynamiccontent: [relatedOrgListModel]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for model in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#333333")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 13)
            let name = model.orgName ?? ""
            let persent = model.percent ?? ""
            label.attributedText = GetRedStrConfig.getRedStr(from: "\(persent)", fullText: "\(name) (\(persent))")
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(label)
        }
    }
}

/** 网络数据请求 */
extension CompanyShareholderViewCell {
    
    //添加关注
    private func addFocusInfo(from btn: UIButton, model: itemsModel) {
        let man = RequestManager()
        let dict = ["entityId": model.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.follow = true
                    btn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    ToastViewConfig.showToast(message: "关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    private func cancelFocusInfo(from btn: UIButton, model: itemsModel) {
        let man = RequestManager()
        let dict = ["entityId": model.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.follow = false
                    btn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    ToastViewConfig.showToast(message: "取消关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
