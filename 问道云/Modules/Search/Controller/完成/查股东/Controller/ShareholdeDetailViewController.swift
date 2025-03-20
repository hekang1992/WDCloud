//
//  ShareholdeDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/17.
//

import UIKit
import DropMenuBar

class ShareholdeDetailViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "股东情况"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        let oneMenu = MenuAction(title: "持股", style: .typeList)!
        let twoMenu = MenuAction(title: "状态", style: .typeList)!
        let threeMenu = MenuAction(title: "地区", style: .typeList)!
        let fourMenu = MenuAction(title: "行业", style: .typeList)!
        let menuView = DropMenuBar(action: [oneMenu, twoMenu, threeMenu, fourMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(headView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
        }
    }

}
