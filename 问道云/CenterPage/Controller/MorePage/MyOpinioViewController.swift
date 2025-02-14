//
//  MyOpinioViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/14.
//

import UIKit

class MyOpinioViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "我的反馈"
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addHeadView(from: headView)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyOpinionInfo()
    }

}

extension MyOpinioViewController {
    
    private func getMyOpinionInfo() {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/operationFeedback/list",
                       method: .get) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}
