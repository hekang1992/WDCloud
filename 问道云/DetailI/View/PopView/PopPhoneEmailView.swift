//
//  PopPhoneEmailView.swift
//  问道云
//
//  Created by 何康 on 2025/3/7.
//

import UIKit
import RxRelay

class PopPhoneEmailView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)

    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .white
        return bgViwe
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.text = "电话号码"
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .mediumFontOfSize(size: 15)
        return phonelabel
    }()
    
    lazy var addresslabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.text = "地址"
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .mediumFontOfSize(size: 15)
        return phonelabel
    }()
    
    lazy var websitelabel: UILabel = {
        let websitelabel = UILabel()
        websitelabel.text = "网址"
        websitelabel.textColor = UIColor.init(cssStr: "#333333")
        websitelabel.textAlignment = .left
        websitelabel.font = .mediumFontOfSize(size: 15)
        return websitelabel
    }()
    
    lazy var emaillabel: UILabel = {
        let emaillabel = UILabel()
        emaillabel.text = "邮箱"
        emaillabel.textColor = UIColor.init(cssStr: "#333333")
        emaillabel.textAlignment = .left
        emaillabel.font = .mediumFontOfSize(size: 15)
        return emaillabel
    }()
    
    lazy var wechatlabel: UILabel = {
        let wechatlabel = UILabel()
        wechatlabel.text = "公众号"
        wechatlabel.textColor = UIColor.init(cssStr: "#333333")
        wechatlabel.textAlignment = .left
        wechatlabel.font = .mediumFontOfSize(size: 15)
        return wechatlabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(600)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopPhoneEmailView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgViwe.setTopCorners(radius: 10)
    }
    
}
