//
//  CorrelationViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/16.
//

import UIKit
import RxRelay

class CorrelationViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
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
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 12)
        mlabel.text = "担任:"
        return mlabel
    }()
    
    lazy var workLabel: UILabel = {
        let workLabel = UILabel()
        workLabel.font = .regularFontOfSize(size: 12)
        workLabel.textAlignment = .left
        workLabel.textColor = .init(cssStr: "#547AFF")
        return workLabel
    }()
    
    lazy var statusLabel: PaddedLabel = {
        let statusLabel = PaddedLabel()
        statusLabel.font = .regularFontOfSize(size: 11)
        return statusLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lineView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(mlabel)
        contentView.addSubview(workLabel)
        contentView.addSubview(statusLabel)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.bottom.equalToSuperview().offset(-27)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.left.equalTo(ctImageView.snp.right).offset(8)
            make.height.equalTo(20)
        }
        
        mlabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(5.5)
            make.size.equalTo(CGSize(width: 33, height: 15))
        }
        workLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mlabel.snp.centerY)
            make.height.equalTo(15)
            make.left.equalTo(mlabel.snp.right)
        }
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(15)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.left.right.bottom.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.relateEntityName ?? "", size: (40, 40)))
            
            namelabel.text = model.relateEntityName ?? ""
            //职位
            let originalString = model.workAs ?? ""
            let attributedString = NSMutableAttributedString(string: originalString)
            // 定义要查找的范围
            let pattern = "\\(([^)]+)\\)" // 正则表达式，匹配括号内的内容
            let regex = try! NSRegularExpression(pattern: pattern)
            // 查找匹配的范围
            let matches = regex.matches(in: originalString, range: NSRange(location: 0, length: originalString.utf16.count))
            // 遍历匹配结果
            for match in matches {
                let range = match.range(at: 1) // 获取括号内的内容范围
                attributedString.addAttribute(.foregroundColor, value: UIColor.init(cssStr: "#F55B5B")!, range: range) // 设置颜色
            }
            workLabel.attributedText = attributedString
            
            statusLabel.text = model.entityStatus ?? ""
            TagsLabelColorConfig.nameLabelColor(from: statusLabel)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
