//
//  SearchJobViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit

class SearchJobViewController: WDBaseViewController {
    
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
        headView.titlelabel.text = "求职检测"
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
        ctImageView.image = UIImage(named: "qiuzhijainceim")
        return ctImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "qijaniagm")
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
        ctImageView.addSubview(twoImageView)
        
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
            make.top.equalToSuperview().offset(40)
            make.size.equalTo(CGSize(width: 376.pix(), height: 568.pix()))
            make.bottom.equalToSuperview().offset(-5)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ctImageView.snp.top).offset(40)
            make.size.equalTo(CGSize(width: 344.pix(), height: 198.pix()))
        }
        coverView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let oneVc = SearchJobListViewController()
                self.navigationController?.pushViewController(oneVc, animated: true)
        }).disposed(by: disposeBag)
    }

}
