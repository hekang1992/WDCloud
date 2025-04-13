//
//  RiskDetailHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//

import UIKit

//企业风险详情头部
class CompanyRiskDetailHeadView: BaseView {
    
    var reportBtnBlock: (() -> Void)?
    
    var nameClickBlock: (() -> Void)?
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 16)
        namelabel.isUserInteractionEnabled = true
        return namelabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timeLabel.textAlignment = .left
        timeLabel.font = .mediumFontOfSize(size: 12)
        return timeLabel
    }()
    
    lazy var reportBtn: UIButton = {
        let reportBtn = UIButton(type: .custom)
        reportBtn.setImage(UIImage(named: "wendaoyunreporer"), for: .normal)
        reportBtn.adjustsImageWhenHighlighted = false
        return reportBtn
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.isHidden = true
        tagLabel.textColor = .init(cssStr: "#FF7D00")!
        tagLabel.backgroundColor = .init(cssStr: "#FFEEDE")!
        tagLabel.font = .regularFontOfSize(size: 10)
        return tagLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var monitoringBtn: UIButton = {
        let monitoringBtn = UIButton(type: .custom)
        monitoringBtn.isHidden = true
        monitoringBtn.setImage(UIImage(named: "addmonitoring"), for: .normal)
        return monitoringBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(namelabel)
        addSubview(timeLabel)
        addSubview(reportBtn)
        addSubview(tagLabel)
        addSubview(lineView)
        addSubview(monitoringBtn)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.navigationBarHeight + 15.5)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top).offset(-2)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.height.equalTo(22.5)
            make.right.equalToSuperview().offset(-80)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(4)
            make.left.equalTo(namelabel.snp.left)
            make.height.equalTo(16.5)
        }
        reportBtn.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(24.5)
            make.size.equalTo(CGSize(width: 89, height: 15))
            make.right.equalToSuperview().offset(-12)
        }
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.left)
            make.centerY.equalTo(reportBtn.snp.centerY)
            make.height.equalTo(15)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        monitoringBtn.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalTo(namelabel.snp.centerY)
            make.right.equalToSuperview().offset(-10)
        }
        
        reportBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.reportBtnBlock?()
            }).disposed(by: disposeBag)
        
        namelabel.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nameClickBlock?()
            }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//个人风险详情头部
class PeopleRiskDetailHeadView: BaseView {
    
    var reportBtnBlock: (() -> Void)?
    
    var nameClickBlock: (() -> Void)?
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 16)
        namelabel.isUserInteractionEnabled = true
        return namelabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timeLabel.textAlignment = .left
        timeLabel.font = .mediumFontOfSize(size: 12)
        return timeLabel
    }()
    
    lazy var reportBtn: UIButton = {
        let reportBtn = UIButton(type: .custom)
        reportBtn.setImage(UIImage(named: "wendaoyunreporer"), for: .normal)
        reportBtn.adjustsImageWhenHighlighted = false
        return reportBtn
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.textColor = .init(cssStr: "#FF7D00")!
        tagLabel.backgroundColor = .init(cssStr: "#FFEEDE")!
        tagLabel.font = .regularFontOfSize(size: 10)
        return tagLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(namelabel)
        addSubview(timeLabel)
        addSubview(reportBtn)
        addSubview(tagLabel)
        addSubview(lineView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.navigationBarHeight + 15.5)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.top).offset(-2)
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.height.equalTo(22.5)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(4)
            make.left.equalTo(namelabel.snp.left)
            make.height.equalTo(16.5)
        }
        reportBtn.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(24.5)
            make.size.equalTo(CGSize(width: 89, height: 15))
            make.right.equalToSuperview().offset(-12)
        }
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.left)
            make.centerY.equalTo(reportBtn.snp.centerY)
            make.height.equalTo(15)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        reportBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.reportBtnBlock?()
            }).disposed(by: disposeBag)
        
        namelabel.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.nameClickBlock?()
            }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
