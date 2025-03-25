//
//  RiskDetailViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//

import UIKit
import RxRelay

class RiskDetailViewCell: BaseViewCell {
    
    var model = BehaviorRelay<itemDtoListModel?>(value: nil)
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F5F5F5")
        return grayView
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
        namelabel.font = .mediumFontOfSize(size: 13)
        return namelabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "righticonimage")
        return rightImageView
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#999999")
        numlabel.textAlignment = .right
        numlabel.font = .regularFontOfSize(size: 11)
        return numlabel
    }()
    
    lazy var highLabel: PaddedLabel = {
        let highLabel = PaddedLabel()
        highLabel.backgroundColor = UIColor.init(cssStr: "#FEF0EF")
        highLabel.textColor = UIColor.init(cssStr: "#F55B5B")
        highLabel.layer.cornerRadius = 2
        highLabel.layer.masksToBounds = true
        highLabel.font = .regularFontOfSize(size: 12)
        return highLabel
    }()
    
    lazy var lowLabel: PaddedLabel = {
        let lowLabel = PaddedLabel()
        lowLabel.backgroundColor = UIColor.init(cssStr: "#FFEEDE")
        lowLabel.textColor = UIColor.init(cssStr: "#FF7D00")
        lowLabel.layer.cornerRadius = 2
        lowLabel.layer.masksToBounds = true
        lowLabel.font = .regularFontOfSize(size: 12)
        return lowLabel
    }()
    
    lazy var hitLabel: PaddedLabel = {
        let hitLabel = PaddedLabel()
        hitLabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        hitLabel.textColor = UIColor.init(cssStr: "#547AFF")
        hitLabel.layer.cornerRadius = 2
        hitLabel.layer.masksToBounds = true
        hitLabel.font = .regularFontOfSize(size: 12)
        return hitLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(grayView)
        grayView.addSubview(whiteView)
        whiteView.addSubview(namelabel)
        whiteView.addSubview(rightImageView)
        whiteView.addSubview(numlabel)
        whiteView.addSubview(highLabel)
        whiteView.addSubview(lowLabel)
        whiteView.addSubview(hitLabel)
        grayView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(42)
        }
        whiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(18.5)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        numlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-4)
            make.height.equalTo(15)
        }
        highLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(namelabel.snp.right)
            make.height.equalTo(16.pix())
        }
        lowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(highLabel.snp.right)
            make.height.equalTo(16.pix())
        }
        hitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(lowLabel.snp.right)
            make.height.equalTo(16.pix())
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            namelabel.text = model.itemName ?? ""
            numlabel.text = "共\(model.totalCnt ?? 0)条"
            let highLevelCnt = model.highLevelCnt ?? 0
            let lowLevelCnt = model.lowLevelCnt ?? 0
            let tipLevelCnt = model.tipLevelCnt ?? 0
            if highLevelCnt == 0 {
                highLabel.isHidden = true
                highLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.namelabel.snp.right)
                })
            }else {
                highLabel.isHidden = false
                highLabel.text = "高风险(\(model.highLevelCnt ?? 0))"
                highLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.namelabel.snp.right).offset(4.5)
                })
            }
            if lowLevelCnt == 0 {
                lowLabel.isHidden = true
                lowLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.highLabel.snp.right)
                })
            }else {
                lowLabel.isHidden = false
                lowLabel.text = "低风险(\(model.lowLevelCnt ?? 0))"
                lowLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.highLabel.snp.right).offset(4.5)
                })
            }
            if tipLevelCnt == 0 {
                hitLabel.isHidden = true
                hitLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.lowLabel.snp.right)
                })
            }else {
                hitLabel.isHidden = false
                hitLabel.text = "提示(\(model.tipLevelCnt ?? 0))"
                hitLabel.snp.updateConstraints({ make in
                    make.left.equalTo(self.lowLabel.snp.right).offset(4.5)
                })
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
