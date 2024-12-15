//
//  MembershipCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  会员中心页面

import UIKit

class MembershipCenterViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "会员中心"
        headView.bgView.backgroundColor = .clear
        return headView
    }()
    
    lazy var memView: MembershipCenterView = {
        let memView = MembershipCenterView()
        return memView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(memView)
        memView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
