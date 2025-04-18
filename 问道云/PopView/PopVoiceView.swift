//
//  PopVoiceView.swift
//  问道云
//
//  Created by 何康 on 2025/4/11.
//

import UIKit
import Lottie

class PopVoiceView: BaseView {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "倾听中"
        mlabel.textColor = UIColor.white
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bgView.layer.cornerRadius = 20
        return bgView
    }()
    
    lazy var voiceView: LottieAnimationView = {
        let voiceView = LottieAnimationView(name: "yuyindonghua.json", bundle: Bundle.main)
        voiceView.loopMode = .loop
        voiceView.play()
        return voiceView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.text = "语音识别能力由苹果提供"
        desclabel.textColor = UIColor.init(cssStr: "#BABABA")
        desclabel.textAlignment = .center
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(mlabel)
        bgView.addSubview(voiceView)
        bgView.addSubview(desclabel)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 273.pix(), height: 200.pix()))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22.5)
        }
        voiceView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.pix())
            make.size.equalTo(CGSize(width: 180.pix(), height: 180.pix()))
            make.centerX.equalToSuperview()
        }
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(15)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
