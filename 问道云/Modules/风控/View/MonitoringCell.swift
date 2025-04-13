//
//  MonitoringCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/7.
//  监控cell

import UIKit
import SkeletonView

class MonitoringCell: BaseViewCell {
    
    var moreBlock: (() -> Void)?
    
    lazy var footView: UIView = {
        let footView = UIView()
        footView.backgroundColor = .init(cssStr: "#F7F8FB")
        return footView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.isHidden = true
        lineView.backgroundColor = .init(cssStr: "#F1F1F1")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isSkeletonable = true
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.numberOfLines = 0
        namelabel.isSkeletonable = true
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var typeLabel: PaddedLabel = {
        let typeLabel = PaddedLabel()
        typeLabel.layer.cornerRadius = 2.5
        typeLabel.layer.masksToBounds = true
        typeLabel.font = .regularFontOfSize(size: 10)
        return typeLabel
    }()

    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.font = .regularFontOfSize(size: 10)
        tagLabel.layer.cornerRadius = 2.5
        tagLabel.layer.masksToBounds = true
        return tagLabel
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.isSkeletonable = true
        moreBtn.setImage(UIImage(named: "moreniacion"), for: .normal)
        return moreBtn
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.textAlignment = .left
        timeLabel.textColor = .init(cssStr: "#9FA4AD")
        timeLabel.text = "监控周期:"
        timeLabel.isSkeletonable = true
        return timeLabel
    }()
    
    lazy var timeDetailLabel: UILabel = {
        let timeDetailLabel = UILabel()
        timeDetailLabel.font = .regularFontOfSize(size: 12)
        timeDetailLabel.textAlignment = .left
        timeDetailLabel.textColor = .init(cssStr: "#333333")
        timeDetailLabel.isSkeletonable = true
        return timeDetailLabel
    }()
    
    lazy var todayLabel: UILabel = {
        let todayLabel = UILabel()
        todayLabel.font = .regularFontOfSize(size: 12)
        todayLabel.textAlignment = .left
        todayLabel.textColor = .init(cssStr: "#9FA4AD")
        todayLabel.text = "今日/累计事件:"
//        todayLabel.isSkeletonable = true
        return todayLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.isSkeletonable = true
        return numLabel
    }()
    
    lazy var highLabel: UILabel = {
        let highLabel = UILabel()
        highLabel.textAlignment = .left
        highLabel.textColor = .init(cssStr: "#FF4D4F")
        highLabel.font = .regularFontOfSize(size: 12)
        highLabel.isSkeletonable = true
        return highLabel
    }()
    
    lazy var lowLabel: UILabel = {
        let lowLabel = UILabel()
        lowLabel.textAlignment = .left
        lowLabel.textColor = .init(cssStr: "#FF7D00")
        lowLabel.font = .regularFontOfSize(size: 12)
        lowLabel.isSkeletonable = true
        return lowLabel
    }()
    
    lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.textAlignment = .left
        hintLabel.textColor = .init(cssStr: "#547AFF")
        hintLabel.font = .regularFontOfSize(size: 12)
        hintLabel.isSkeletonable = true
        return hintLabel
    }()
    
    lazy var dImageView: UIImageView = {
        let dImageView = UIImageView()
        dImageView.isSkeletonable = true
        dImageView.image = UIImage(named: "lastnewsimage")
        return dImageView
    }()
    
    lazy var riskLabel: UILabel = {
        let riskLabel = UILabel()
        riskLabel.isSkeletonable = true
        riskLabel.font = .regularFontOfSize(size: 12)
        riskLabel.textAlignment = .left
        riskLabel.textColor = .init(cssStr: "#333333")
        return riskLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(timeLabel)
        contentView.addSubview(timeDetailLabel)
        contentView.addSubview(todayLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(highLabel)
        contentView.addSubview(lowLabel)
        contentView.addSubview(hintLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(footView)
        contentView.addSubview(dImageView)
        contentView.addSubview(riskLabel)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10.pix())
            make.size.equalTo(CGSize(width: 35.pix(), height: 35.pix()))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top)
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(21.pix())
        }
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10.pix())
            make.size.equalTo(CGSize(width: 25.pix(), height: 25.pix()))
        }
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(4.pix())
            make.height.equalTo(15.pix())
        }
        tagLabel.snp.makeConstraints { make in
            make.left.equalTo(typeLabel.snp.right).offset(5)
            make.centerY.equalTo(typeLabel.snp.centerY)
            make.height.equalTo(15.pix())
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(tagLabel.snp.bottom).offset(6.pix())
            make.left.equalTo(ctImageView.snp.left)
            make.size.equalTo(CGSize(width: 58.pix(), height: 17))
        }
        timeDetailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.height.equalTo(17.pix())
            make.left.equalTo(timeLabel.snp.right)
        }
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4.pix())
            make.left.equalTo(ctImageView.snp.left)
            make.size.equalTo(CGSize(width: 88.pix(), height: 17))
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(todayLabel.snp.right)
            make.height.equalTo(17.pix())
        }
        highLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(numLabel.snp.right).offset(5)
            make.height.equalTo(17.pix())
        }
        lowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(highLabel.snp.right).offset(5)
            make.height.equalTo(17.pix())
        }
        hintLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(lowLabel.snp.right).offset(5)
            make.height.equalTo(17.pix())
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(highLabel.snp.bottom).offset(6.pix())
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-36.pix())
        }
        dImageView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8.pix())
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 46.pix(), height: 11.pix()))
        }
        riskLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dImageView.snp.centerY)
            make.left.equalTo(dImageView.snp.right).offset(6.5)
            make.height.equalTo(17.pix())
        }
        footView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(6.pix())
        }
        moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.moreBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var companyModel: rowsModel? {
        didSet {
            guard let model = companyModel else { return }
            lineView.isHidden = false
            let logo = model.logo ?? ""
            let orgName = model.orgName ?? ""

            ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(orgName, size: (30, 30), bgColor: UIColor.init(cssStr: model.logoColor ?? "") ?? .random()))
            namelabel.text = orgName
            
            let orgStatus = model.orgStatus ?? ""
            typeLabel.text = orgStatus
            TagsLabelColorConfig.nameLabelColor(from: typeLabel)
            
            tagLabel.text = model.groupName ?? ""
            tagLabel.textColor = .init(cssStr: "#FF7D00")!
            tagLabel.backgroundColor = .init(cssStr: "#FFEEDE")!
            
            let startDate = model.startDate ?? ""
            let endDate = model.endDate ?? ""
            timeDetailLabel.text = "\(startDate)至\(endDate)"
            
            let total = model.totalRiskCnt ?? 0
            let curTotal = model.curRiskCnt ?? 0
            numLabel.text = "\(curTotal)/\(total)条"
            
            let total1 = model.totalHighRiskCnt ?? 0
            let curTotal1 = model.curHighRiskCnt ?? 0
            highLabel.text = "高风险\(curTotal1)/\(total1)"
            
            let total2 = model.totalLowRiskCnt ?? 0
            let curTotal2 = model.curLowRiskCnt ?? 0
            lowLabel.text = "低风险\(curTotal2)/\(total2)"
            
            let total3 = model.totalTipRiskCnt ?? 0
            let curTotal3 = model.curTipRiskCnt ?? 0
            hintLabel.text = "提示\(curTotal3)/\(total3)"
            
            let recentRisk = model.recentRisk ?? ""
            riskLabel.text = !recentRisk.isEmpty ? recentRisk : "暂无动态"
        }
    }
    
    var peopleModel: rowsModel? {
        didSet {
            guard let model = peopleModel else { return }
            lineView.isHidden = false
            let logo = model.logo ?? ""
            let personName = model.personName ?? ""
            ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(personName, size: (30, 30), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            namelabel.text = personName
            
            let orgStatus = model.orgStatus ?? ""
            if orgStatus.isEmpty {
                typeLabel.text = ""
                typeLabel.isHidden = true
                tagLabel.snp.makeConstraints { make in
                    make.left.equalTo(namelabel.snp.left)
                }
            }else {
                typeLabel.text = orgStatus
                typeLabel.isHidden = false
                TagsLabelColorConfig.nameLabelColor(from: typeLabel)
            }
            
            tagLabel.text = model.groupName ?? ""
            tagLabel.textColor = .init(cssStr: "#FF7D00")!
            tagLabel.backgroundColor = .init(cssStr: "#FFEEDE")!
            
            let startDate = model.startDate ?? ""
            let endDate = model.endDate ?? ""
            timeDetailLabel.text = "\(startDate)至\(endDate)"
            
            let total = model.totalRiskCnt ?? 0
            let curTotal = model.curRiskCnt ?? 0
            numLabel.text = "\(curTotal)/\(total)条"
            
            let total1 = model.totalHighRiskCnt ?? 0
            let curTotal1 = model.curHighRiskCnt ?? 0
            highLabel.text = "高风险\(curTotal1)/\(total1)"
            
            let total2 = model.totalLowRiskCnt ?? 0
            let curTotal2 = model.curLowRiskCnt ?? 0
            lowLabel.text = "低风险\(curTotal2)/\(total2)"
            
            let total3 = model.totalTipRiskCnt ?? 0
            let curTotal3 = model.curTipRiskCnt ?? 0
            hintLabel.text = "提示\(curTotal3)/\(total3)"
            
            let recentRisk = model.recentRisk ?? ""
            riskLabel.text = !recentRisk.isEmpty ? recentRisk : "暂无动态"
        }
    }
    
}
