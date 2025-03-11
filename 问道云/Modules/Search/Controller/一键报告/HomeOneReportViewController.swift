//
//  HomeOneReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit

class HomeOneReportViewController: WDBaseViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "onereportbgimage")
        return headImageView
    }()

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "一键报告"
        headView.lineView.isHidden = true
        headView.titlelabel.textColor = .white
        headView.bgView.backgroundColor = .clear
        headView.backBtn.setImage(UIImage(named: "whitebackimge"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入要搜索的企业", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .clear
        return searchView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "reportimageone")
        return ctImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "reporttwoimgea")
        return twoImageView
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
        view.addSubview(headImageView)
        addHeadView(from: headView)
        view.addSubview(scrollView)
        view.addSubview(searchView)
        view.addSubview(footerView)
        view.addSubview(coverView)
        scrollView.addSubview(ctImageView)
        scrollView.addSubview(twoImageView)
        
        headImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(156.pix())
        }
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
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
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.footerView.snp.top)
            make.top.equalTo(searchView.snp.bottom).offset(8)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 337.pix(), height: 152.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(21)
            make.size.equalTo(CGSize(width: 337.pix(), height: 468.pix()))
            make.bottom.equalToSuperview().offset(-5)
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
