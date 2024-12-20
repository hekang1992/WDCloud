//
//  AccountManagerViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//  账号管理页面

import UIKit

class AccountManagerViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "账号管理"
        return headView
    }()
    
    lazy var oneSettingView: SettingListView = {
        let oneSettingView = SettingListView(frame: .zero, type: .image)
        oneSettingView.namelabel.text = "密码设置"
        oneSettingView.namelabel.font = .mediumFontOfSize(size: 14)
        return oneSettingView
    }()
    
    lazy var twoSettingView: SettingListView = {
        let twoSettingView = SettingListView(frame: .zero, type: .image)
        twoSettingView.namelabel.text = "账号注销"
        twoSettingView.namelabel.font = .mediumFontOfSize(size: 14)
        return twoSettingView
    }()
    
    lazy var threeSettingView: SettingListView = {
        let threeSettingView = SettingListView(frame: .zero, type: .text)
        let phone = UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
        threeSettingView.rightlabel.text = phone
        threeSettingView.namelabel.text = "我的手机号"
        threeSettingView.namelabel.font = .mediumFontOfSize(size: 14)
        return threeSettingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        view.addSubview(oneSettingView)
        view.addSubview(twoSettingView)
        view.addSubview(threeSettingView)
        
        oneSettingView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        twoSettingView.snp.makeConstraints { make in
            make.top.equalTo(oneSettingView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        threeSettingView.snp.makeConstraints { make in
            make.top.equalTo(twoSettingView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        
        oneSettingView.bgView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            let setpassVc = SettingPasswordViewController()
            self?.navigationController?.pushViewController(setpassVc, animated: true)
        }).disposed(by: disposeBag)
        
        
        twoSettingView.bgView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            let setpassVc = DeleteAccountViewController()
            self?.navigationController?.pushViewController(setpassVc, animated: true)
        }).disposed(by: disposeBag)
        
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
