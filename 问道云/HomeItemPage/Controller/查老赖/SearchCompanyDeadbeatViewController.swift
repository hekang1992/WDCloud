//
//  SearchCompanyDeadbeatViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/12.
//

import UIKit
import RxRelay

class SearchCompanyDeadbeatViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var keyWords = BehaviorRelay<String>(value: "")
    var pageNum: Int = 1
    var pageSize: Int = 20
    var model: DataModel?
    var allArray: [rowsModel] = []
    var numBlock: ((DataModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
