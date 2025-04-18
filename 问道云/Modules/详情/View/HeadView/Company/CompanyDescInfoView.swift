//
//  CompanyDescInfoView.swift
//  问道云
//
//  Created by Andrew on 2025/1/14.
//

import UIKit

class CompanyDescInfoView: BaseView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .init(cssStr: "#000000")?.withAlphaComponent(0.25)
        return scrollView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var desLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.font = .regularFontOfSize(size: 13)
        desLabel.textColor = .init(cssStr: "#666666")
        desLabel.textAlignment = .left
        desLabel.numberOfLines = 0
        return desLabel
    }()

    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "rightHeadLogo")
        return icon
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "特别提示：数据来源是基于公开信息通过风险模型大数据分析后的结果，风险等级是基于具体身份、处罚结果的严重程度进行的判断，仅供用户参考，并不代表问道云的任何明示、暗示之观点或保证。"
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 9)
        mlabel.numberOfLines = 0
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(whiteView)
        scrollView.addSubview(desLabel)
        scrollView.addSubview(icon)
        scrollView.addSubview(mlabel)
        scrollView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.5)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.top.equalToSuperview()
        }
        icon.snp.makeConstraints { make in
            make.top.equalTo(desLabel.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon.snp.centerY)
            make.width.equalTo(SCREEN_WIDTH - 57)
            make.left.equalTo(icon.snp.right).offset(7)
            make.bottom.equalToSuperview().offset(-10)
        }
        whiteView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(mlabel.snp.bottom).offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CompanyDescInfoView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
}
