//
//  HomeHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/5.
//  首页头部View

import UIKit

class HomeHeadView: BaseView {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "appheadbgimage")
        return ctImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "appbiaoqianimage")
        return iconImageView
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.isUserInteractionEnabled = true
        vipImageView.image = UIImage(named: "homehuiyuanicon")
        return vipImageView
    }()
    
    //tab切换
    lazy var tabView: HomeHeadTabView = {
        let tabView = HomeHeadTabView()
        return tabView
    }()
    
    //热词
    lazy var hotsView: HomeHeadHotsView = {
        let hotsView = HomeHeadHotsView()
        return hotsView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(iconImageView)
        ctImageView.addSubview(vipImageView)
        ctImageView.addSubview(tabView)
        ctImageView.addSubview(hotsView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(233)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight)
            make.size.equalTo(CGSize(width: 99, height: 25))
            make.left.equalToSuperview().offset(15.5)
        }
        vipImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.size.equalTo(CGSize(width: 67, height: 25))
        }
        tabView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(vipImageView.snp.bottom).offset(35)
            make.height.equalTo(83.5)
        }
        hotsView.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

