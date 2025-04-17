//
//  GroupTeamViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/2.
//  团体中心

import UIKit
import RxSwift
import ContactsUI

class GroupTeamViewController: WDBaseViewController {
    
    var model: DataModel? {
        didSet {
            
        }
    }
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "团体中心"
        return headView
    }()
    
    lazy var norView: GroupTeamNorView = {
        let norView = GroupTeamNorView()
        norView.isHidden = true
        return norView
    }()
    
    lazy var specView: GroupTeamSpecView = {
        let specView = GroupTeamSpecView()
        specView.isHidden = true
        return specView
    }()
    
    lazy var contactPicker: CNContactPickerViewController = {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        return contactPicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(norView)
        view.addSubview(specView)
        norView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        specView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        
        norView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let firmname = self.norView.nameTx.text ?? ""
            let email = self.norView.emailTx.text ?? ""
            if firmname.isEmpty || email.isEmpty {
                ToastViewConfig.showToast(message: "请您填写好所有信息")
            }else {
                createGroupInfo(from: firmname, email: email)
            }
        }).disposed(by: disposeBag)
        
        //电话号码
        specView.phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(specView.phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 11 {
                    specView.phoneTx.text = String(text.prefix(11))
                }
                if text.count > 0 {
                    specView.sureBtn.isEnabled = true
                    specView.sureBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
                }else {
                    specView.sureBtn.isEnabled = false
                    specView.sureBtn.backgroundColor = UIColor.init(cssStr: "#ADBFFF")
                }
            })
            .disposed(by: disposeBag)
        
        specView.nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let listVc = GroupListViewController()
            self?.navigationController?.pushViewController(listVc, animated: true)
        }).disposed(by: disposeBag)
        
        specView.whiteTwoView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            let listVc = GroupListViewController()
            self?.navigationController?.pushViewController(listVc, animated: true)
        }).disposed(by: disposeBag)
        
        specView.phoneImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
            let manager = ContactManager()
            manager.requestAccess { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    self.present(contactPicker, animated: true, completion: nil)
                }else {
                    ShowAlertManager.showAlert(title: "权限申请", message: "请在iphone的“设置-问道云-通讯录”选项中,允许问道云访问你的通讯录", confirmAction: {[weak self] in
                        self?.openSettings()
                    })
                }
            }
        }).disposed(by: disposeBag)
        
        //添加成员
        specView.sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            let friendphone = self?.specView.phoneTx.text ?? ""
            let maincustomernumber = GetSaveLoginInfoConfig.getPhoneNumber()
            let name = self?.specView.nameTx.text ?? ""
            if name.isEmpty {
                ToastViewConfig.showToast(message: "请输入成员姓名")
                return
            }
            let dict = ["friendphone": friendphone,
                        "maincustomernumber": maincustomernumber,
                        "name": name.filter { !$0.isWhitespace }]
            let man = RequestManager()
            man.requestAPI(params: dict,
                           pageUrl: "/operation/customerinfo/addsubaccount",
                           method: .post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        self?.getGroupTeamLeader()
                        ToastViewConfig.showToast(message: "添加成功")
                    }else {
                        ToastViewConfig.showToast(message: success.msg ?? "")
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }).disposed(by: disposeBag)
        
        //跳转续费会员
        specView.vipBtn.rx.tap.subscribe(onNext: { [weak self] in
            let memVc = MembershipCenterViewController()
            self?.navigationController?.pushViewController(memVc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //是否是团体长
        getGroupTeamLeader()
    }
    
}

extension GroupTeamViewController {
    func getGroupTeamLeader() {
        let man = RequestManager()
        let dict = [String: Any]()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm/bycustomernumber",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data, let dataid = model.dataid, !dataid.isEmpty {
                    self.norView.isHidden = true
                    self.specView.isHidden = false
                    self.descTextInfo(from: model)
                }else {
                    self.norView.isHidden = false
                    self.specView.isHidden = true
                }
                break
            case .failure(_):
                self.addNodataView(from: norView)
                break
            }
        }
    }
    
    func createGroupInfo(from name: String, email: String) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["firmname": name, "email": email]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.norView.isHidden = true
                    self?.specView.isHidden = false
                }else {
                    ToastViewConfig.showToast(message: success.msg ?? "")
                }
                break
            case .failure(_):
                break
            }
        }
    }

    func descTextInfo(from model: DataModel) {
        self.specView.headView.mlabel.text = "团体名称: \(model.firmname ?? "")"
        self.specView.headView.clabel.text = "邮箱: \(model.email ?? "")"
        self.specView.viplabel.text = "团体VIP"
        self.specView.timelabel.text = model.endtime ?? ""
        let currentNum = (Int(model.useaccountcount ?? "0") ?? 0) + 1
        let peopleNumStr = (String(currentNum)) + "/" + (model.accountcount ?? "");
        self.specView.currentlabel.text = "当前套餐人数: \(peopleNumStr)"
        self.specView.numBtn.setTitle(model.useaccountcount, for: .normal)
    }
    
}

extension GroupTeamViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fullName = "\(contact.givenName) \(contact.familyName)"
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            self.specView.phoneTx.text = phoneNumber
            self.specView.sureBtn.isEnabled = true
            self.specView.sureBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
            self.specView.nameTx.text = fullName
        } else {
            print("error")
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
}
