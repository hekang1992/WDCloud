//
//  MyOpinionViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/15.
//

import UIKit
import RxRelay

class MyOpinionViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)

    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var taglabel: PaddedLabel = {
        let taglabel = PaddedLabel()
        taglabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        taglabel.textAlignment = .center
        taglabel.font = .regularFontOfSize(size: 10)
        taglabel.layer.cornerRadius = 2
        taglabel.layer.borderWidth = 1
        return taglabel
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        onelabel.textAlignment = .center
        onelabel.font = .regularFontOfSize(size: 12)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        twolabel.textAlignment = .center
        twolabel.font = .regularFontOfSize(size: 12)
        return twolabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(namelabel)
        contentView.addSubview(taglabel)
        contentView.addSubview(onelabel)
        contentView.addSubview(twolabel)
        contentView.addSubview(ctImageView)
        contentView.addSubview(lineView)
        
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(21)
        }
        taglabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(namelabel.snp.right).offset(13)
            make.height.equalTo(15)
        }
        onelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(namelabel.snp.bottom).offset(6)
            make.height.equalTo(16.5)
        }
        twolabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(onelabel.snp.bottom).offset(3)
            make.height.equalTo(16.5)
            make.bottom.equalToSuperview().offset(-20)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let feedbacktype = model.feedbacktype ?? ""
            switch feedbacktype {
            case "1":
                namelabel.text = "功能问题"
                break
            case "2":
                namelabel.text = "数据问题"
                break
            case "3":
                namelabel.text = "会员问题"
                break
            case "4":
                namelabel.text = "商务问题"
                break
            case "5":
                namelabel.text = "其他问题"
                break
            default:
                break
            }
            onelabel.text = "反馈类型: \(model.feedbacksubtype ?? "")"
            twolabel.text = "反馈问题: \(model.question ?? "")"
            let handlestate = model.handlestate ?? ""
            if handlestate == "0" {
                taglabel.text = "客服待处理"
                taglabel.textColor = .init(cssStr: "#9FA4AD")
                taglabel.layer.borderColor = UIColor.init(cssStr: "#9FA4AD")?.cgColor
            }else {
                taglabel.text = "客服已处理"
                taglabel.textColor = .init(cssStr: "#4DC929")
                taglabel.layer.borderColor = UIColor.init(cssStr: "#4DC929")?.cgColor
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
