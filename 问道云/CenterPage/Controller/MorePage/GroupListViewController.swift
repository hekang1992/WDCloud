//
//  GroupListViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/2.
//  团队成员列表页面

import UIKit

class GroupListViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "套餐管理"
        return headView
    }()
    
    lazy var listView: GroupListView = {
        let listView = GroupListView()
        listView.backgroundColor = .white
        return listView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(listView)
        listView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListInfo()
    }
    
}

extension GroupListViewController {
    
    //获取套餐列表信息
    private func getListInfo() {
        let man = RequestManager()
        let phoneNumber = GetSaveLoginInfoConfig.getPhoneNumber()
        let dict = ["maincustomernumber": phoneNumber]
        man.requestAPI(params: dict, pageUrl: "/operation/customerinfo/subaccountlist", method: .get) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}
