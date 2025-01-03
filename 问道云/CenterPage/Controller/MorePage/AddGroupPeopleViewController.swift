//
//  AddGroupPeopleViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/3.
//  添加团体成员

import UIKit
import ContactsUI

class AddGroupPeopleViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "添加人员"
        return headView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var onelineView: UIView = {
        let onelineView = UIView()
        onelineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return onelineView
    }()
    
    lazy var twolineView: UIView = {
        let twolineView = UIView()
        twolineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return twolineView
    }()
    
    lazy var threelineView: UIView = {
        let threelineView = UIView()
        threelineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return threelineView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "添加团体成员"
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .mediumFontOfSize(size: 14)
        oneLabel.textAlignment = .left
        return oneLabel
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "手机号码"
        phoneLabel.textColor = .init(cssStr: "#333333")
        phoneLabel.font = .regularFontOfSize(size: 14)
        phoneLabel.textAlignment = .left
        return phoneLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "成员姓名"
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 14)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("确认添加", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 4
        return nextBtn
    }()
    
    lazy var phoneImageView: UIImageView = {
        let phoneImageView = UIImageView()
        phoneImageView.image = UIImage(named: "phonimagetonxunlu")
        phoneImageView.isUserInteractionEnabled = true
        return phoneImageView
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入成员手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 13)
        ])
        phoneTx.textAlignment = .right
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#27344B")
        return phoneTx
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入成员姓名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 13)
        ])
        nameTx.textAlignment = .right
        nameTx.attributedPlaceholder = attrString
        nameTx.font = .regularFontOfSize(size: 14)
        nameTx.textColor = UIColor.init(cssStr: "#27344B")
        return nameTx
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
        
        view.addSubview(whiteView)
        
        whiteView.addSubview(onelineView)
        whiteView.addSubview(twolineView)
        whiteView.addSubview(threelineView)
        
        whiteView.addSubview(oneLabel)
        
        whiteView.addSubview(phoneLabel)
        whiteView.addSubview(phoneImageView)
        whiteView.addSubview(phoneTx)
        
        
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(nameTx)
        
        view.addSubview(nextBtn)
        
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(162)
        }
        
        onelineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(47)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        twolineView.snp.makeConstraints { make in
            make.top.equalTo(onelineView.snp.bottom).offset(56)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        threelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(onelineView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(twolineView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        phoneImageView.snp.makeConstraints { make in
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        phoneTx.snp.makeConstraints { make in
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.right.equalTo(phoneImageView.snp.left).offset(-9)
            make.size.equalTo(CGSize(width: 150, height: 22))
        }
        nameTx.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 200, height: 22))
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(27.5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-23)
        }
        
        phoneImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                let manager = ContactManager()
                manager.requestAccess { [weak self] granted, error in
                    guard let self = self else { return }
                    if granted {
                        self.present(contactPicker, animated: true, completion: nil)
                    }
                }
                
        }).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.addInfo()
        }).disposed(by: disposeBag)
        
        phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 11 {
                    self.phoneTx.text = String(text.prefix(11))
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension AddGroupPeopleViewController {
    
    //添加成员
    private func addInfo() {
        let friendphone = self.phoneTx.text ?? ""
        let maincustomernumber = GetSaveLoginInfoConfig.getPhoneNumber()
        let name = self.nameTx.text ?? ""
        let dict = ["friendphone": friendphone,
                    "maincustomernumber": maincustomernumber,
                    "name": name.filter { !$0.isWhitespace }]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/customerinfo/addsubaccount", method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.navigationController?.popViewController(animated: true)
                    ToastViewConfig.showToast(message: "添加成功")
                }else {
                    ToastViewConfig.showToast(message: success.msg ?? "")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    
}

extension AddGroupPeopleViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let fullName = "\(contact.givenName) \(contact.familyName)"
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            self.phoneTx.text = phoneNumber
            self.nameTx.text = fullName
        } else {
            print("error")
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
}
