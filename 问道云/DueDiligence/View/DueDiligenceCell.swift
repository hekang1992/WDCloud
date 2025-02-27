//
//  DueDiligenceCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/18.
//

import UIKit
import RxRelay

class DueDiligenceCell: BaseViewCell {
    
    var searchStr: String?
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)

    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 4
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.numberOfLines = 0
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var rImageView: UIImageView = {
        let rImageView = UIImageView()
        rImageView.image = UIImage(named: "tabjinzhidiaimnge")
        return rImageView
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "法定代表人："
        onelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 13)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "统一社会信用代码："
        twolabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 13)
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.text = "成立日期："
        threelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        threelabel.textAlignment = .left
        threelabel.font = .regularFontOfSize(size: 13)
        return threelabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var peoplelabel: UILabel = {
        let peoplelabel = UILabel()
        peoplelabel.textColor = UIColor.init(cssStr: "#333333")
        peoplelabel.textAlignment = .left
        peoplelabel.font = .regularFontOfSize(size: 13)
        return peoplelabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#333333")
        numlabel.textAlignment = .left
        numlabel.font = .regularFontOfSize(size: 13)
        return numlabel
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#333333")
        timelabel.textAlignment = .left
        timelabel.font = .regularFontOfSize(size: 13)
        return timelabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(rImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(onelabel)
        contentView.addSubview(twolabel)
        contentView.addSubview(threelabel)
        contentView.addSubview(peoplelabel)
        contentView.addSubview(numlabel)
        contentView.addSubview(timelabel)
        contentView.addSubview(lineView)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        rImageView.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 55, height: 17))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15.5)
            make.right.equalTo(rImageView.snp.left).offset(-5)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.bottom.equalToSuperview().offset(-80)
        }
        onelabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(2.5)
            make.height.equalTo(18.5)
        }
        twolabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(onelabel.snp.bottom).offset(2.5)
            make.height.equalTo(18.5)
        }
        threelabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(twolabel.snp.bottom).offset(2.5)
            make.height.equalTo(18.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        peoplelabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(onelabel.snp.right).offset(2)
            make.height.equalTo(18.5)
        }
        numlabel.snp.makeConstraints { make in
            make.centerY.equalTo(twolabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right).offset(2)
            make.height.equalTo(18.5)
        }
        timelabel.snp.makeConstraints { make in
            make.centerY.equalTo(threelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right).offset(2)
            make.height.equalTo(18.5)
        }
        
        model.asObservable()
            .subscribe(onNext: { [weak self] model in
                guard let self = self, let model = model?.orgInfo else { return }
                let name = model.orgName ?? ""
                logoImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (32, 32)))
                namelabel.text = name
                peoplelabel.text = "--"
                numlabel.text = "--"
                timelabel.text = model.incDate ?? ""
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
