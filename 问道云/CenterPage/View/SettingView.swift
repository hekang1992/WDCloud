//
//  SettingView.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//

import UIKit

enum RightType {
    case image
    case text
}

class SettingListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 14)
        return namelabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    lazy var rightlabel: UILabel = {
        let rightlabel = UILabel()
        rightlabel.textColor = UIColor.init(cssStr: "#999999")
        rightlabel.textAlignment = .right
        rightlabel.font = .regularFontOfSize(size: 14)
        return rightlabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#E3E3E3")
        return lineView
    }()
   
    init(frame: CGRect, type: RightType) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(namelabel)
        bgView.addSubview(rightlabel)
        bgView.addSubview(ctImageView)
        bgView.addSubview(lineView)
        if type == .image {
            ctImageView.isHidden = false
            rightlabel.isHidden = true
        }else {
            ctImageView.isHidden = true
            rightlabel.isHidden = false
        }
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.right.equalToSuperview().offset(-19)
        }
        rightlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SettingView: BaseView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneListView: SettingListView = {
        let oneListView = SettingListView(frame: .zero, type: .image)
        oneListView.namelabel.text = "账号管理"
        oneListView.lineView.isHidden = true
        return oneListView
    }()
    
    lazy var twoListView: SettingListView = {
        let twoListView = SettingListView(frame: .zero, type: .image)
        twoListView.namelabel.text = "消息推送设置"
        return twoListView
    }()
    
    lazy var threeListView: SettingListView = {
        let threeListView = SettingListView(frame: .zero, type: .text)
        threeListView.namelabel.text = "清除缓存"
        let cacheSize = GetCacheConfig.getCacheSizeInMB()
        threeListView.rightlabel.text = cacheSize
        return threeListView
    }()
    
    lazy var fourListView: SettingListView = {
        let fourListView = SettingListView(frame: .zero, type: .text)
        fourListView.namelabel.text = "版本更新"
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            fourListView.rightlabel.text = "当前版本：V\(version)"
        }
        fourListView.lineView.isHidden = true
        return fourListView
    }()
    
    lazy var fiveListView: SettingListView = {
        let fiveListView = SettingListView(frame: .zero, type: .image)
        fiveListView.namelabel.text = "第三方信息共享清单"
        return fiveListView
    }()
    
    lazy var sixListView: SettingListView = {
        let sixListView = SettingListView(frame: .zero, type: .image)
        sixListView.namelabel.text = "个人信息收集清单"
        return sixListView
    }()
    
    lazy var sevListView: SettingListView = {
        let sevListView = SettingListView(frame: .zero, type: .image)
        sevListView.namelabel.text = "问道云用户协议"
        return sevListView
    }()
    
    lazy var eigListView: SettingListView = {
        let eigListView = SettingListView(frame: .zero, type: .image)
        eigListView.namelabel.text = "问道云隐私政策"
        return eigListView
    }()
    
    lazy var nineListView: SettingListView = {
        let nineListView = SettingListView(frame: .zero, type: .image)
        nineListView.namelabel.text = "问道云会员服务协议"
        return nineListView
    }()
    
    lazy var tenListView: SettingListView = {
        let tenListView = SettingListView(frame: .zero, type: .image)
        tenListView.namelabel.text = "隐私权限设置"
        return tenListView
    }()
    
    lazy var eleListView: SettingListView = {
        let eleListView = SettingListView(frame: .zero, type: .image)
        eleListView.namelabel.text = "关于我们"
        eleListView.lineView.isHidden = true
        return eleListView
    }()
    
    lazy var exitBtn: UIButton = {
        let exitBtn = UIButton(type: .custom)
        exitBtn.backgroundColor = .white
        exitBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        exitBtn.setTitle("退出当前账号", for: .normal)
        exitBtn.setTitleColor(UIColor.init(cssStr: "#F55B5B"), for: .normal)
        return exitBtn
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(oneListView)
        scrollView.addSubview(twoListView)
        scrollView.addSubview(threeListView)
        scrollView.addSubview(fourListView)
        scrollView.addSubview(fiveListView)
        scrollView.addSubview(sixListView)
        scrollView.addSubview(sevListView)
        scrollView.addSubview(eigListView)
        scrollView.addSubview(nineListView)
        scrollView.addSubview(tenListView)
        scrollView.addSubview(eleListView)
        scrollView.addSubview(exitBtn)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        threeListView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        fourListView.snp.makeConstraints { make in
            make.top.equalTo(threeListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        fiveListView.snp.makeConstraints { make in
            make.top.equalTo(fourListView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        sixListView.snp.makeConstraints { make in
            make.top.equalTo(fiveListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        sevListView.snp.makeConstraints { make in
            make.top.equalTo(sixListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        eigListView.snp.makeConstraints { make in
            make.top.equalTo(sevListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        nineListView.snp.makeConstraints { make in
            make.top.equalTo(eigListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        tenListView.snp.makeConstraints { make in
            make.top.equalTo(nineListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        eleListView.snp.makeConstraints { make in
            make.top.equalTo(tenListView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        exitBtn.snp.makeConstraints { make in
            make.top.equalTo(eleListView.snp.bottom).offset(13)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
