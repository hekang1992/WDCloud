//
//  HomeOneReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit

class HomeOneReportViewController: WDBaseViewController {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "一键报告"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入关键词", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "plageimagebaogao")
        return ctImageView
    }()
    
    lazy var footerView: LoginFootView = {
        let footerView = LoginFootView()
        return footerView
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.isUserInteractionEnabled = true
        return coverView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(searchView)
        view.addSubview(ctImageView)
        view.addSubview(footerView)
        view.addSubview(coverView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 337, height: 524))
        }
        footerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(51.5)
        }
        coverView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        
        
        coverView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let oneVc = SearchOneReportViewController()
                self.navigationController?.pushViewController(oneVc, animated: true)
        }).disposed(by: disposeBag)
    }

}
