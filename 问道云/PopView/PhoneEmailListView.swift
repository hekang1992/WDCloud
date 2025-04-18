//
//  PhoneEmailListView.swift
//  问道云
//
//  Created by Andrew on 2025/3/8.
//

import UIKit

class PhoneEmailListView: BaseView {
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#3F96FF")
        namelabel.textAlignment = .left
        namelabel.numberOfLines = 0
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 12)
        return desclabel
    }()
    
    lazy var numlabel: PaddedLabel = {
        let numlabel = PaddedLabel()
        numlabel.textColor = UIColor.init(cssStr: "#F9F9F9")
        numlabel.textAlignment = .center
        numlabel.font = .regularFontOfSize(size: 11)
        numlabel.textColor = .init(cssStr: "#333333")
        numlabel.layer.borderWidth = 1
        numlabel.layer.cornerRadius = 3
        numlabel.layer.borderColor = UIColor.init(cssStr: "#D8D8D8")?.cgColor
        return numlabel
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.isHidden = true
        tagLabel.layer.cornerRadius = 2
        tagLabel.layer.borderWidth = 1
        tagLabel.layer.borderColor = UIColor.init(cssStr: "#9FA4AD")?.cgColor
        tagLabel.font = .regularFontOfSize(size: 11)
        tagLabel.textColor = .init(cssStr: "#9FA4AD")
        tagLabel.textAlignment = .center
        return tagLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(lineView)
        addSubview(namelabel)
        addSubview(desclabel)
        addSubview(numlabel)
        addSubview(tagLabel)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(1)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(9)
            make.width.equalTo(247.pix())
            make.left.equalToSuperview().offset(10)
        }
        desclabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(1)
            make.left.equalTo(namelabel.snp.left)
            make.height.equalTo(16.5)
            make.bottom.equalToSuperview().offset(-7)
        }
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(desclabel.snp.top)
            make.centerY.equalTo(desclabel.snp.centerY)
            make.left.equalTo(desclabel.snp.right).offset(5)
        }
        numlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
