//
//  PropertyThreeBothViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit
import DropMenuBar

class PropertyThreeBothViewController: WDBaseViewController {
    
    weak var navController: UINavigationController?
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入企业、人员名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(0.5)
            make.height.equalTo(45)
        }
        let oneMenu = MenuAction(title: "类型", style: .typeList)!
        let twoMenu = MenuAction(title: "时间", style: .typeList)!
        let threeMenu = MenuAction(title: "更多", style: .typeList)!
        let menuView = DropMenuBar(action: [oneMenu, twoMenu, threeMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(32)
        }
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
