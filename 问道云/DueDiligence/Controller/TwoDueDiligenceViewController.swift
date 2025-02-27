//
//  TwoDueDiligenceViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
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
        oneView.oneListView.ddnumber = "11"
        oneView.twoListView.ddnumber = "12"
        oneView.threeListView.ddnumber = "13"
        oneView.fourListView.ddnumber = "14"
        return oneView
    }()
    
    lazy var twoView: DueDiligenceTwoView = {
        let twoView = DueDiligenceTwoView()
        twoView.oneListView.ddnumber = "15"
        twoView.twoListView.ddnumber = "16"
        twoView.threeListView.ddnumber = "17"
        twoView.fourListView.ddnumber = "18"
        twoView.fiveListView.ddnumber = "19"
        twoView.sixListView.ddnumber = "20"
        twoView.isHidden = true
        return twoView
    }()
    
    var ddonenumber: String = "5"
    
    var ddtwonumber: String = "15"
    
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
            guard let self = self else { return }
            let num = String((Int(ddnumber) ?? 0) + 10)
            self.ddonenumber = num
        }
        
        oneView.threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchVc = SearchDueDiligenceViewController()
                searchVc.ddNumber = ddonenumber
                self.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
        twoView.block = { [weak self] ddnumber in
            guard let self = self else { return }
            let num = String((Int(ddnumber) ?? 0) + 10)
            self.ddtwonumber = num
        }
        
        twoView.threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchVc = SearchDueDiligenceViewController()
                searchVc.ddNumber = ddtwonumber
                self.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
        
    }
    
}
