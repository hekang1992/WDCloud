//
//  HomeNewsListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/5.
//

import UIKit
import RxRelay

class HomeNewsListViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    var block: ((newstagsobjModel) -> Void)?
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 4
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .mediumFontOfSize(size: 13)
        titleLabel.textColor = UIColor.init(cssStr: "#333333")
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .regularFontOfSize(size: 12)
        descLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 2
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(lineView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12.5)
            make.top.equalToSuperview().offset(12.5)
            make.right.equalToSuperview().offset(-17)
            make.bottom.equalToSuperview().offset(-71.5)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().offset(-17)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            iconImageView.kf.setImage(with: URL(string: model.pic ?? ""))
            titleLabel.text = model.title ?? ""
            descLabel.text = model.summary ?? ""
            if let tags = model.newstagsobj {
                self.clearExistingTagButtons()
                var currentX: CGFloat = 10
                for tag in tags {
                    let button = UIButton(type: .custom)
                    button.layer.cornerRadius = 10
                    button.layoutButtonEdgeInsets(style: .left, space: 5)
                    button.setImage(UIImage(named: "jointopicimge"), for: .normal)
                    button.backgroundColor = .init(cssStr: "#F4F4F6")
                    button.setTitle(tag.abbName, for: .normal)
                    button.setTitleColor(.init(cssStr: "#333333"), for: .normal)
                    button.titleLabel?.font = .regularFontOfSize(size: 11)
                    self.contentView.addSubview(button)
                    button.snp.makeConstraints { make in
                        make.top.equalTo(self.descLabel.snp.bottom).offset(8)
                        make.left.equalTo(self.iconImageView.snp.right).offset(currentX)
                        make.height.equalTo(20)
                        make.width.equalTo(button.intrinsicContentSize.width + 20)
                    }
                    button.rx.tap.subscribe(onNext: {
                        self.block?(tag)
                    }).disposed(by: disposeBag)
                    currentX += button.intrinsicContentSize.width + 25
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeNewsListViewCell {
    
    private func clearExistingTagButtons() {
        self.contentView.subviews.forEach { subview in
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }
    
}
