//
//  ThreeDueDiligenceViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit

class ThreeDueDiligenceViewController: WDBaseViewController {
    
    weak var nav: UINavigationController?
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "lianxikefuimagedue")
        return ctImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("联系客服", for: .normal)
        oneBtn.setTitleColor(UIColor.white, for: .normal)
        oneBtn.layer.cornerRadius = 22
        oneBtn.backgroundColor = .init(cssStr: "#547AFF")
        return oneBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(ctImageView)
        ctImageView.addSubview(oneBtn)
        scrollView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
        }
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(375.pix())
            make.height.equalTo(622.pix())
            make.bottom.equalToSuperview().offset(-5)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 118, height: 44))
            make.bottom.equalToSuperview().offset(-35)
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            makePhoneCall(phoneNumber: "4000129988")
        }).disposed(by: disposeBag)
    }
    
}

extension ThreeDueDiligenceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
            return
        }
    }
    
}
