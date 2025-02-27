//
//  PropertyCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay

class PropertyCompanyViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    var entityArea: String = ""//公司时候的地区
    
    var keyWords = BehaviorRelay<String>(value: "")

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
