//
//  MonitoringCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  监控cell

import UIKit
import TagListView

class MonitoringCell: BaseViewCell {
    
    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            let logo = model.logo ?? ""
            var firmname = model.firmname ?? ""
            if firmname.isEmpty {
                firmname = model.personname ?? ""
            }
            let tags = model.firstate ?? ""
            let relate = model.relate ?? []
            ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(firmname, size: (30, 30)))
            namelabel.text = firmname
            var strArray: [String] = []
            if !tags.isEmpty {
                strArray.append(tags)
            }else {
                for str in relate {
                    strArray.append(str)
                }
            }
            self.tagListView.removeAllTags()
            self.tagListView.addTags(strArray)
            timeDetailLabel.text = model.createtime ?? ""
            numLabel.text = "\(model.riskSumup ?? 0)条"
            highLabel.text = "高风险\(model.high_risk ?? 0)/\(model.high_risk_sum ?? 0)"
            lowLabel.text = "低风险\(model.low_risk ?? 0)/\(model.low_risk_sum ?? 0)"
            hintLabel.text = "提示\(model.hint ?? 0)/\(model.hint_sum ?? 0)"
            if let riskData = model.riskData, let risktime = riskData.risktime, !risktime.isEmpty {
                riskLabel.text = "\(riskData.risktime ?? "")" + " " + "\(riskData.itemname ?? "")"
            }else {
                riskLabel.text = "暂无动态"
            }
            
        }
    }
    
    lazy var footView: UIView = {
        let footView = UIView()
        footView.backgroundColor = .init(cssStr: "#F7F8FB")
        return footView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F1F1F1")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 2
        tagListView.paddingX = 2
        tagListView.paddingY = 2
        tagListView.marginX = 4
        tagListView.marginY = 4
        tagListView.textColor = .init(cssStr: "#FF7D00")!
        tagListView.tagBackgroundColor = .init(cssStr: "#FFEEDE")!
        tagListView.textFont = .regularFontOfSize(size: 10)
        return tagListView
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "moreniacion"), for: .normal)
        return moreBtn
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.textAlignment = .left
        timeLabel.textColor = .init(cssStr: "#9FA4AD")
        timeLabel.text = "监控周期"
        return timeLabel
    }()
    
    lazy var timeDetailLabel: UILabel = {
        let timeDetailLabel = UILabel()
        timeDetailLabel.font = .regularFontOfSize(size: 12)
        timeDetailLabel.textAlignment = .left
        timeDetailLabel.textColor = .init(cssStr: "#333333")
        timeDetailLabel.text = "2023-03-26至2024-03-26"
        return timeDetailLabel
    }()
    
    lazy var todayLabel: UILabel = {
        let todayLabel = UILabel()
        todayLabel.font = .regularFontOfSize(size: 12)
        todayLabel.textAlignment = .left
        todayLabel.textColor = .init(cssStr: "#9FA4AD")
        todayLabel.text = "今日/累计事件"
        return todayLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 12)
        return numLabel
    }()
    
    lazy var highLabel: UILabel = {
        let highLabel = UILabel()
        highLabel.textAlignment = .left
        highLabel.textColor = .init(cssStr: "#FF4D4F")
        highLabel.font = .regularFontOfSize(size: 12)
        return highLabel
    }()
    
    lazy var lowLabel: UILabel = {
        let lowLabel = UILabel()
        lowLabel.textAlignment = .left
        lowLabel.textColor = .init(cssStr: "#FF7D00")
        lowLabel.font = .regularFontOfSize(size: 12)
        return lowLabel
    }()
    
    lazy var hintLabel: UILabel = {
        let hintLabel = UILabel()
        hintLabel.textAlignment = .left
        hintLabel.textColor = .init(cssStr: "#3F96FF")
        hintLabel.font = .regularFontOfSize(size: 12)
        return hintLabel
    }()
    
    lazy var dImageView: UIImageView = {
        let dImageView = UIImageView()
        dImageView.backgroundColor = .random()
        return dImageView
    }()
    
    lazy var riskLabel: UILabel = {
        let riskLabel = UILabel()
        riskLabel.font = .regularFontOfSize(size: 12)
        riskLabel.textAlignment = .left
        riskLabel.textColor = .init(cssStr: "#333333")
        return riskLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(tagListView)
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
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.height.equalTo(21)
        }
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14.5)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.right).offset(6.5)
            make.centerY.equalTo(namelabel.snp.centerY)
            make.height.equalTo(15)
            make.width.equalTo(250)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(6)
            make.left.equalTo(namelabel.snp.left)
            make.size.equalTo(CGSize(width: 58, height: 17))
        }
        timeDetailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.height.equalTo(17)
            make.left.equalTo(timeLabel.snp.right)
        }
        todayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.left.equalTo(namelabel.snp.left)
            make.size.equalTo(CGSize(width: 88, height: 17))
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(todayLabel.snp.right)
            make.height.equalTo(17)
        }
        highLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(numLabel.snp.right).offset(5)
            make.height.equalTo(17)
        }
        lowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(highLabel.snp.right).offset(5)
            make.height.equalTo(17)
        }
        hintLabel.snp.makeConstraints { make in
            make.centerY.equalTo(todayLabel.snp.centerY)
            make.left.equalTo(lowLabel.snp.right).offset(5)
            make.height.equalTo(17)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(highLabel.snp.bottom).offset(6)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-34)
        }
        dImageView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 46, height: 13.5))
        }
        riskLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dImageView.snp.centerY)
            make.left.equalTo(dImageView.snp.right).offset(6.5)
            make.height.equalTo(17)
        }
        footView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(6)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
