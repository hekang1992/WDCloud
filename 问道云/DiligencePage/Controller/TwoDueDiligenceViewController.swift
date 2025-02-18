//
//  TwoDueDiligenceViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/17.
//

import UIKit

class TwoDueDiligenceViewController: WDBaseViewController {
    
    var headGrand: Bool? {
        didSet {
            guard let headGrand = headGrand else { return }
            oneView.isHidden = headGrand
            twoView.isHidden = !headGrand
        }
    }
    
    lazy var oneView: DueDiligenceOneView = {
        let oneView = DueDiligenceOneView()
        return oneView
    }()
    
    lazy var twoView: DueDiligenceTwoView = {
        let twoView = DueDiligenceTwoView()
        twoView.isHidden = true
        return twoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(oneView)
        view.addSubview(twoView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        twoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneView.threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let searchVc = SearchDueDiligenceViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
        twoView.threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let searchVc = SearchDueDiligenceViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
}
