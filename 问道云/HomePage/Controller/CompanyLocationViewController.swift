//
//  CompanyLocationViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/10.
//

import UIKit

class CompanyLocationViewController: WDBaseViewController {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHeadView(from: headView)
    }

}
