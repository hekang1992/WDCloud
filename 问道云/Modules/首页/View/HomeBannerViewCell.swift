//
//  HomeBannerViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/6.
//

import UIKit
import RxSwift

class HomeBannerViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    lazy var ipoImgaView: UIImageView = {
        let ipoImgaView = UIImageView()
        ipoImgaView.contentMode = .scaleAspectFill
        return ipoImgaView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ipoImgaView)
        ipoImgaView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
