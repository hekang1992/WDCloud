//
//  ComanyRiskMoreDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/5.
//

import UIKit
import RxRelay

class ComanyRiskMoreDetailViewController: WDBaseViewController {
    
    var itemsModel = BehaviorRelay<itemsModel?>(value: nil)
    
    var entityid: String = ""
    var itemnumber: Int = 0
    var itemtype: String = ""
    var dateType: String = ""
    var caseproperty: String = ""
    var casetype: String = ""
    var pageNum: Int = 1
    var pageSize: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        let model = itemsModel.value
        entityid = model?.entityId ?? ""
        itemnumber = model?.itemnumber ?? 0
        caseproperty = model?.caseproperty ?? ""
    }
    

}
