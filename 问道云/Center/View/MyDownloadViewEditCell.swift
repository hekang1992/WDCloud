//
//  MyDownloadViewEditCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/12.
//

import UIKit
import RxSwift

class MyDownloadViewEditCell: BaseViewCell {
    
    var block: ((rowsModel) -> Void)?
    
    lazy var checkIcon: UIImageView = {
        let checkIcon = UIImageView()
        checkIcon.image = UIImage(named: "Check_nor")
        return checkIcon
    }()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkIcon)
        contentView.addSubview(bgView)
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(gongsiLabel)
        contentView.addSubview(timeLabel)
        checkIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(54)
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
        bgView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-9)
            make.left.equalToSuperview().offset(42)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(84.5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.downloadfilename ?? ""
            gongsiLabel.text = model.firmname ?? ""
            timeLabel.text = model.createtime ?? ""
        }
    }
    
    func configureDeleteCell(isChecked: Bool) {
        checkIcon.image = isChecked ? UIImage(named: "Checkb_sel") : UIImage(named: "Check_nor")
    }

}
