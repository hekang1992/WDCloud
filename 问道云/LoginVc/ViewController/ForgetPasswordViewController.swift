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
