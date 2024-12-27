//
//  MembershipListViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/27.
//  具体购买页面

import UIKit

class MembershipListViewController: WDBaseViewController {
    
    lazy var listView: MembershipListView = {
        let listView = MembershipListView()
        return listView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension MembershipListViewController {
    
    //获取套餐信息
    func getPriceModelInfo(from index: Int, model: DataModel) {
        if index == 2 {
            self.addNodataView(from: view)
        }
        ToastViewConfig.showToast(message: model.rows?[index].combotypename ?? "")
    }
    
    
}
