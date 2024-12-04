//
//  ForgetPasswordViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class ForgetPasswordViewController: WDBaseViewController {
    
    lazy var forgetView: ForgetPasswordView = {
        let forgetView = ForgetPasswordView()
        return forgetView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(forgetView)
        forgetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapClick()
        
    }
    
}

extension ForgetPasswordViewController {
    
    
    func tapClick() {
        
        self.forgetView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        
    }
    
}
