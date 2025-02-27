//
//  WDRefreshHeader.swift
//  问道云
//
//  Created by Andrew on 2025/1/5.
//

import UIKit
import Lottie
import MJRefresh

class WDRefreshHeader: MJRefreshHeader {

    lazy var headTapView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "refreshloading.json", bundle: Bundle.main)
        animationView.animationSpeed = 2
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = .mediumFontOfSize(size: 12)
        nameLabel.textColor = .black
        nameLabel.text = "下拉刷新"
        return nameLabel
    }()

    override func prepare() {
        super.prepare()
        addSubview(headTapView)
        addSubview(nameLabel)
        self.mj_h = 80
    }

    override func placeSubviews() {
        super.placeSubviews()
        headTapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 65, height: 65))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headTapView.snp.bottom)
            make.size.equalTo(CGSize(width: 120, height: 13))
        }
    }

    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        let isDragging = scrollView?.isDragging ?? false
        if isDragging {
            if self.state == .pulling {
                nameLabel.text = "松开刷新"
            }else if self.state == .refreshing {
                nameLabel.text = "正在刷新"
            }else {
                nameLabel.text = "下拉刷新"
            }
        }else {
            if self.state == .pulling {
                nameLabel.text = "松开刷新"
            }else if self.state == .refreshing {
                nameLabel.text = "正在刷新"
            }else if self.state == .idle {
                nameLabel.text = ""
            }else {
                nameLabel.text = "下拉刷新"
            }
        }
    }    
}
