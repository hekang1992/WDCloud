//
//  MyTwoSettingViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit

class MyTwoSettingViewController: WDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //获取用户监控设置
        getUserSettingInfo()
    }
}

extension MyTwoSettingViewController {
    
    private func getUserSettingInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor_settings/configs",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}
