//
//  PasswordLoginViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class PasswordLoginViewController: WDBaseViewController {
    
    lazy var passView: PasswordLoginView = {
        let passView = PasswordLoginView()
        return passView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(passView)
        passView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        passView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        ViewHud.addLoadView()
        
        tapClick()
    }

}

extension PasswordLoginViewController {
    
    func tapClick() {
        
        self.passView.wangjimimaBtn.rx.tap.subscribe(onNext: { [weak self] in
            let forgetVc = ForgetPasswordViewController()
            self?.navigationController?.pushViewController(forgetVc, animated: true)
        }).disposed(by: disposeBag)
        
        
        
    }
    
}
