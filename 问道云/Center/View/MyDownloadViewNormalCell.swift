//
//  MyDownloadViewNormalCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/12.
//

import UIKit
import RxSwift
import RxRelay

class MyDownloadViewNormalCell: UITableViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)

    let disposeBag = DisposeBag()
    
    var block: ((rowsModel) -> Void)?
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Pdfimage")
        return icon
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 6
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var gongsiLabel: UILabel = {
        let gongsiLabel = UILabel()
        gongsiLabel.textColor = UIColor.init(cssStr: "#3F96FF")
        gongsiLabel.font = .regularFontOfSize(size: 12)
        gongsiLabel.textAlignment = .left
        return gongsiLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "moreniacion"), for: .normal)
        moreBtn.adjustsImageWhenHighlighted = false
        return moreBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(gongsiLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(moreBtn)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(22)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(22)
            make.top.equalToSuperview().offset(12.5)
            make.height.equalTo(21)
        }
        gongsiLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(22)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.height.equalTo(16.5)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(22)
            make.top.equalTo(gongsiLabel.snp.bottom).offset(4)
            make.height.equalTo(16.5)
            make.bottom.equalToSuperview().offset(-8)
        }
        moreBtn.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top).offset(2)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(CGSize(width: 17, height: 17))
        }
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(84.5)
            make.bottom.equalToSuperview()
        }
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model1 = self.model.value {
                self.block?(model1)
            }
        }).disposed(by: disposeBag)
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.downloadfilename ?? ""
            gongsiLabel.text = model.firmname ?? ""
            timeLabel.text = model.createtime ?? ""
        }).disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
