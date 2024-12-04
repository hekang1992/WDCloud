//
//  WDCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class WDCenterViewController: WDBaseViewController {
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = .orange
        nextBtn.setTitle("登录/注册", for: .normal)
        nextBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return nextBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if IS_LOGIN {
            print("登录成功=================")
        }
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.popLogin()
        }).disposed(by: disposeBag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
