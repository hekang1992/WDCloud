//
//  BothReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  日报

import UIKit
import MJRefresh
import TYAlertController

class BothReportViewController: WDBaseViewController {
    
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        return noLoginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_LOGIN {
            self.noLoginView.isHidden = true
        }else {
            view.addSubview(noLoginView)
            noLoginView.loginBlock = { [weak self] in
                guard let self = self else { return }
                self.popLogin()
            }
            noLoginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.noLoginView.isHidden = false
        }
    }
    
}
