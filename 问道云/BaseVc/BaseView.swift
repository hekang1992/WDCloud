//
//  BaseView.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import RxSwift

// 公司模型（模拟）
struct CompanyModel {
    var isOpenTag: Bool
}

class BaseView: UIView {
    let disposeBag = DisposeBag()
}

class BaseViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
}

enum NavRightType {
    case none
    case oneBtn
    case twoBtn
    case threeBtn
}

//导航栏headview
class HeadView: UIView {
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backimage"), for: .normal)
        return backBtn
    }()
    
    lazy var titlelabel: UILabel = {
        let titlelabel = UILabel()
        titlelabel.textColor = .init(cssStr: "#333333")
        titlelabel.textAlignment = .center
        titlelabel.font = .mediumFontOfSize(size: 18)
        return titlelabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.adjustsImageWhenHighlighted = false
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.adjustsImageWhenHighlighted = false
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.adjustsImageWhenHighlighted = false
        return threeBtn
    }()
    
    lazy var headTitleView: UIView = {
        let headTitleView = UIView()
        headTitleView.isHidden = true
        return headTitleView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    init(frame: CGRect, typeEnum: NavRightType) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(backBtn)
        bgView.addSubview(titlelabel)
        bgView.addSubview(oneBtn)
        bgView.addSubview(twoBtn)
        bgView.addSubview(threeBtn)
        bgView.addSubview(headTitleView)
        bgView.addSubview(lineView)
        let hiddenStates: [Bool]
        switch typeEnum {
        case .none:
            hiddenStates = [true, true, true]
            break
        case .oneBtn:
            hiddenStates = [false, true, true]
            break
        case .twoBtn:
            hiddenStates = [false, false, true]
            break
        case .threeBtn:
            hiddenStates = [false, false, false]
            break
        }
        [oneBtn, twoBtn, threeBtn].enumerated().forEach { index, button in
            button.isHidden = hiddenStates[index]
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 10)
            make.left.equalToSuperview().offset(26)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        titlelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(backBtn.snp.right).offset(10)
            make.centerY.equalTo(backBtn.snp.centerY)
            make.height.equalTo(20)
        }
        headTitleView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(25)
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.right.equalTo(oneBtn.snp.left).offset(-5)
            make.height.equalTo(25)
        }
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.right.equalTo(twoBtn.snp.left).offset(-5)
            make.height.equalTo(25)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
