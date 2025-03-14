//
//  GroupListViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/2.
//  团队成员列表页面

import UIKit
import TYAlertController

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
    
    lazy var changeView: PopChangePeopleView = {
        let changeView = PopChangePeopleView(frame: self.view.bounds)
        return changeView
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
            guard let self = self else { return }
            self.changePeopleInfo(from: model)
        }
        
        //删除
        listView.deleteBlock = { [weak self] model in
            self?.deletePeopleInfo(from: model)
        }
        
        listView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let addVc = AddGroupPeopleViewController()
            self?.navigationController?.pushViewController(addVc, animated: true)
        }).disposed(by: disposeBag)
        
        listView.vipBtn.rx.tap.subscribe(onNext: { [weak self] in
            let memVc = MembershipCenterViewController()
            self?.navigationController?.pushViewController(memVc, animated: true)
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
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerinfo/subaccountlist",
                       method: .get) { result in
            
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
    private func changePeopleInfo(from model: rowsModel) {
        let alertVc = TYAlertController(alert: changeView, preferredStyle: .actionSheet)
        changeView.model.accept(model)
        self.present(alertVc!, animated: true)
        
        changeView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        changeView.sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let man = RequestManager()
            
            let name = changeView.nameTx.text ?? ""
            let friendphone = model.username ?? ""
            let maincustomernumber = GetSaveLoginInfoConfig.getPhoneNumber()
            let newfriendphone = changeView.phoneTx.text ?? ""
            if name.isEmpty {
                ToastViewConfig.showToast(message: "请输入成员姓名")
                return
            }
            let dict = ["name": name,
                        "friendphone": friendphone,
                        "maincustomernumber": maincustomernumber,
                        "newfriendphone": newfriendphone]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/customerinfo/updatesubaccount",
                           method: .post) { result in
                
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        self.dismiss(animated: true)
                        self.getListInfo()
                        ToastViewConfig.showToast(message: "转让成功")
                    }else {
                        ToastViewConfig.showToast(message: success.msg ?? "")
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
}
