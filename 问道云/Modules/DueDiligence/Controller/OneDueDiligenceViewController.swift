//
//  OneDueDiligenceViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit

class OneDueDiligenceViewController: WDBaseViewController {
    
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
    
    var ddonenumber: String = "1"
    
    var ddtwonumber: String = "11"
    
    weak var nav: UINavigationController?
    
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
        
        oneView.block = { [weak self] ddnumber in
            self?.ddonenumber = ddnumber
        }
        
        oneView.threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchVc = SearchDueDiligenceViewController()
                searchVc.ddNumber = ddonenumber
                nav?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
        
        twoView.block = { [weak self] ddnumber in
            self?.ddtwonumber = ddnumber
        }
        
        twoView.clickBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchVc = SearchDueDiligenceViewController()
                searchVc.ddNumber = ddtwonumber
                self.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
}
