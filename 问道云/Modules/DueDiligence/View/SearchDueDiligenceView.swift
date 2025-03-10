//
//  SearchDueDiligenceView.swift
//  问道云
//
//  Created by Andrew on 2025/2/18.
//

import UIKit

class SearchDueDiligenceView: BaseView {

    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "bgimagedueim")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.isUserInteractionEnabled = true
        twoImageView.image = UIImage(named: "goumaivimiagedue")
        return twoImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneImageView)
        addSubview(twoImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(375.pix())
            make.height.equalTo(552.pix())
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 351, height: 112))
            make.bottom.equalToSuperview().offset(-26)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
