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
            
        }
    }
    
    lazy var oneView: DueDiligenceOneView = {
        let oneView = DueDiligenceOneView()
        return oneView
    }()
    
    var ddonenumber: String = "1"
    
    weak var nav: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
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
        
        oneView.twoListView.isHidden = true
        oneView.threeListView.isHidden = true
        oneView.fourListView.isHidden = true
        
    }
    
}
