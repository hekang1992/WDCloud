//
//  PropertyThreeCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import DropMenuBar

class PropertyThreeCompanyViewController: WDBaseViewController {
    
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
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
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
        //获取分组信息
        getGroupInfo()
    }
    
}

/** 网络数据请求 */
extension PropertyThreeCompanyViewController {
    
    //获取分组
    private func getGroupInfo() {
        let dict = [String: String]()
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/firminfo/monitor/group", method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
