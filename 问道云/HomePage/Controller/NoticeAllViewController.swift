//
//  NoticeAllViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//  公告大全页面

import UIKit

class NoticeAllViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "公告大全"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入股票名称、代码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var covreView: UIView = {
        let covreView = UIView()
        covreView.backgroundColor = .init(cssStr: "#F3F3F3")
        return covreView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var items: [String] = ["全部", "沪京深", "IPO申报", "上市辅导", "港股", "新三板", "债券", "基金"]
    
    var buttons: [UIButton] = []
    
    var previousButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(searchView)
        view.addSubview(covreView)
        covreView.addSubview(scrollView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        covreView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(35)
        }
        scrollView.snp.makeConstraints { make in
            make.center.equalTo(covreView)
            make.left.equalToSuperview().offset(2)
            make.top.equalToSuperview().offset(2.5)
            make.height.equalTo(30)
        }
        for (index, menuName) in items.enumerated() {
            // 创建按钮
            let button = UIButton(type: .custom)
            button.setTitle(menuName, for: .normal)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
            button.titleLabel?.font = .regularFontOfSize(size: 12)
            button.layer.cornerRadius = 2
            button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
            scrollView.addSubview(button)
            button.tag = index + 10 // 设置 tag 以便区分按钮
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // 添加点击事件
            buttons.append(button) // 将按钮添加到数组中
            // 设置按钮的约束
            button.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(5)
                make.height.equalTo(22)
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).offset(9)
                } else {
                    make.left.equalToSuperview().offset(9)
                }
            }
            previousButton = button
            if index == items.count - 1 {
                button.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-5)
                }
            }
        }
        if let firstBtn = buttons.first {
            buttonTapped(firstBtn)
        }
    }
    
    //按钮点击方法
    @objc func buttonTapped(_ sender: UIButton) {
        // 恢复所有按钮的默认样式
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        // 设置被点击按钮的样式
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
    }

}
