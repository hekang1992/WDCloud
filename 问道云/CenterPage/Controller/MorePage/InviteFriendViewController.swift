//
//  InviteFriendViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/16.
//  邀请好友

import UIKit

class InviteFriendViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "邀请好友"
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "yaoqingbg")
        return ctImageView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "yaoqingguize")
        return oneImageView
    }()
    
    lazy var viteBtn: UIButton = {
        let viteBtn = UIButton(type: .custom)
        viteBtn.setImage(UIImage(named: "yaoqingbtnimage"), for: .normal)
        return viteBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        view.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(863)
            make.top.equalTo(headView.snp.bottom)
        }
        ctImageView.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(384)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 336, height: 222))
        }
        
        ctImageView.addSubview(viteBtn)
        viteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 344, height: 55))
            make.top.equalTo(oneImageView.snp.bottom).offset(3)
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

