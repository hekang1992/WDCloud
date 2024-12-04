//
//  WDLoginViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class WDLoginViewController: WDBaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.mimaBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.tapClick()
        }).disposed(by: disposeBag)
    }

}

extension WDLoginViewController {
    
    func tapClick() {
        let passwordVc = PasswordLoginViewController()
        self.navigationController?.pushViewController(passwordVc, animated: true)
    }
    
}
