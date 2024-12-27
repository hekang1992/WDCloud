//
//  MembershipListView.swift
//  问道云
//
//  Created by 何康 on 2024/12/27.
//

import UIKit

let squareWidth = (SCREEN_WIDTH - 45) / 3

class PriceView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 7.5
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.init(cssStr: "#E5E2ED")?.cgColor
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MembershipListView: BaseView {
    
    lazy var oneView: PriceView = {
        let oneView = PriceView()
        oneView.backgroundColor = .clear
        return oneView
    }()
    
    lazy var twoView: PriceView = {
        let twoView = PriceView()
        twoView.backgroundColor = .clear
        return twoView
    }()
    
    
    lazy var threeView: PriceView = {
        let threeView = PriceView()
        threeView.backgroundColor = .clear
        return threeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        addSubview(twoView)
        addSubview(threeView)
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12.5)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        twoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(oneView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        threeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(twoView.snp.right).offset(10)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        
        // 设置默认第一个视图有边框颜色
        setBorder(for: oneView)
        
        // 添加点击手势
        [oneView, twoView, threeView].enumerated().forEach { index, view in
            view.tag = index
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        }
        
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        // 重置所有视图的边框
        resetBorders()
        // 设置点击的视图边框
        setBorder(for: tappedView)
    }
    
    private func resetBorders() {
        [oneView, twoView, threeView].forEach { view in
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 7.5
            view.layer.borderColor = UIColor.init(cssStr: "#E5E2ED")?.cgColor
        }
    }
    
    private func setBorder(for view: UIView) {
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 7.5
        view.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
