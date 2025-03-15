//
//  MyVipUseViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit

class MyVipUseViewController: WDBaseViewController {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "权益使用记录"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
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
