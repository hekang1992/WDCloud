//
//  PopIndustryView.swift
//  问道云
//
//  Created by 何康 on 2025/3/7.
//

import UIKit
import RxRelay

class PopIndustryView: BaseView {
    
    var titles = BehaviorRelay<[String]?>(value: nil)
    
    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .white
        bgViwe.layer.cornerRadius = 10
        return bgViwe
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "问道云行业详情"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        cancelBtn.setTitle("关闭", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        cancelBtn.layer.cornerRadius = 3
        return cancelBtn
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#666666")
        desclabel.textAlignment = .left
        desclabel.numberOfLines = 0
        desclabel.font = .regularFontOfSize(size: 14)
        return desclabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.addSubview(mlabel)
        bgViwe.addSubview(desclabel)
        bgViwe.addSubview(cancelBtn)
        bgViwe.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(220)
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22.5)
        }
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mlabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(15)
        }
        cancelBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 130, height: 40.pix()))
        }
        
        titles.asObservable().subscribe(onNext: { [weak self] titles in
            guard let self = self, let titles = titles, titles.count > 0 else { return }
            // 1. 将 titles 数组拼接成字符串
            let descTitleStr = titles.joined(separator: ">")
            
            // 2. 按 ">" 拆分字符串
            let components = descTitleStr.components(separatedBy: ">")
            
            // 3. 获取最后一个部分
            guard let lastComponent = components.last else { return }
            
            // 4. 创建富文本
            let attributedString = NSMutableAttributedString(string: descTitleStr)
            
            // 5. 找到最后一个 ">" 的位置
            if let range = descTitleStr.range(of: "\(lastComponent)", options: .backwards) {
                let nsRange = NSRange(range, in: descTitleStr)
                
                // 6. 设置最后一部分的字体加粗
                attributedString.addAttributes(
                    [
                        .font: UIFont.mediumFontOfSize(size: 14),
                        .foregroundColor: UIColor.init(cssStr: "#333333") as Any
                    ],
                    range: nsRange
                )
            }
            
            // 7. 设置富文本到 label
            self.desclabel.attributedText = attributedString
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
