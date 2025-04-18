//
//  CompanyCollectionCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//  企业详情小item

import UIKit
import RxRelay
import RxSwift

class CompanyCollectionCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<childrenModel?>(value: nil)
    
    lazy var lineView1: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var lineView2: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var lineView3: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "rightHeadLogo")
        ctImageView.contentMode = .scaleAspectFit
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#27344B")
        namelabel.textAlignment = .center
        namelabel.font = .regularFontOfSize(size: 12)
        return namelabel
    }()
    
    lazy var nlabel: PaddedLabel = {
        let nlabel = PaddedLabel()
        nlabel.textColor = UIColor.init(cssStr: "#547AFF")
        nlabel.textAlignment = .center
        nlabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        nlabel.font = .regularFontOfSize(size: 9)
        nlabel.layer.cornerRadius = 2
        return nlabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#547AFF")
        numlabel.textAlignment = .right
        numlabel.font = .regularFontOfSize(size: 10)
        return numlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(lineView2)
        contentView.addSubview(lineView3)
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(numlabel)
        contentView.addSubview(nlabel)
        lineView2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(0.5)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(11)
        }
        
        lineView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        numlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(14)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.top.equalToSuperview().offset(15)
        }
        namelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        nlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
            make.top.equalTo(namelabel.snp.bottom).offset(6)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            namelabel.text = model.menuName ?? ""
            let markFlag = model.markFlag ?? 0
            let markCount = model.markCount ?? 0
            namelabel.textColor = UIColor.init(cssStr: "#27344B")
            if markFlag == 0 {//不统计角标
                numlabel.isHidden = true
                ctImageView.kf.setImage(with: URL(string: model.icon ?? ""))
            }else {
                numlabel.isHidden = false
                numlabel.text = String(markCount)
                if markCount == 0 {
                    ctImageView.kf.setImage(with: URL(string: model.iconGrey ?? ""))
                    numlabel.textColor = UIColor.init(cssStr: model.iconGreyColor ?? "")
                    namelabel.textColor = numlabel.textColor
                }else {
                    ctImageView.kf.setImage(with: URL(string: model.icon ?? ""))
                    numlabel.textColor = UIColor.init(cssStr: model.iconColor ?? "")
                }
            }
            
            let markHisFlag = model.markHisFlag ?? 0
            let markHisCount = model.markHisCount ?? ""
            if markHisFlag == 0 {//不统计历史信息
                nlabel.isHidden = true
            }else {
                nlabel.text = markHisCount
                if markHisCount.isEmpty {
                    nlabel.isHidden = true
                    nlabel.textColor = UIColor.init(cssStr: model.iconGreyColor ?? "")
                    nlabel.backgroundColor = UIColor.init(cssStr: model.iconGreyColor ?? "")?.withAlphaComponent(0.1)
                }else {
                    nlabel.isHidden = false
                    nlabel.textColor = UIColor.init(cssStr: model.iconColor ?? "")
                    nlabel.backgroundColor = UIColor.init(cssStr: model.iconColor ?? "")?.withAlphaComponent(0.1)
                }
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// 自定义头部视图
class MyCollectionNormalReusableView: UICollectionReusableView {
    
    let disposeBag = DisposeBag()
    
    static let identifier = "MyCollectionNormalReusableView"
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F3F3F3")
        return bgView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(whiteView)
        whiteView.addSubview(namelabel)
        whiteView.addSubview(lineView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        whiteView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(37.5)
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(12.5)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(namelabel.snp.bottom).offset(7)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

