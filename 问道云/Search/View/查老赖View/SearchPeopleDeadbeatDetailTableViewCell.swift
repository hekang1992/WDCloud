//
//  SearchPeopleDeadbeatDetailTableViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit

class SearchPeopleDeadbeatDetailTableViewCell: BaseViewCell {

    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 13)
        namelabel.numberOfLines = 0
        return namelabel
    }()

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(namelabel)
        contentView.addSubview(ctImageView)
        namelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-15)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-7)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
