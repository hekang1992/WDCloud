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
        
        //转让
        listView.changeBlock = { [weak self] model in
            ToastViewConfig.showToast(message: model.username ?? "")
            
        }
        
        //删除
        listView.deleteBlock = { [weak self] model in
            self?.deletePeopleInfo(from: model)
        }
        
        listView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let addVc = AddGroupPeopleViewController()
            self?.navigationController?.pushViewController(addVc, animated: true)
        }).disposed(by: disposeBag)
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
                if let model = success.data {
                    self.listView.model.accept(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //删除成员
    private func deletePeopleInfo(from model: rowsModel) {
        
        ShowAlertManager.showAlert(title: "提醒", message: "是否确认删除当前团体成员?", confirmAction: {
            let customernumber = model.customernumber ?? ""
            let dict = ["customernumber": customernumber]
            let man = RequestManager()
            man.requestAPI(params: dict,
                           pageUrl: "/operation/customerinfo/subaccount/delete",
                           method: .delete) { [weak self] result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        self?.getListInfo()
                        ToastViewConfig.showToast(message: "删除成功")
                    }else {
                        ToastViewConfig.showToast(message: success.msg ?? "")
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //转让成员
    private func changePeopleInfo() {
        
    }
}
