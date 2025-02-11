//
//  HomePeopleSanctionViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//  个人行政处罚

import UIKit
import RxRelay

class HomePeopleSanctionViewController: WDBaseViewController {
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var keyWords = BehaviorRelay<String>(value: "")
    var pageNum: Int = 1
    var pageSize: Int = 20
    var type: String = "1"
    var model: DataModel?
    var allArray: [itemsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension HomePeopleSanctionViewController {
    
    
    
}
