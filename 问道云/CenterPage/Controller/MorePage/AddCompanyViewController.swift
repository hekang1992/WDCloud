//
//  AddCompanyViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/17.
//

import UIKit

class AddCompanyViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "添加企业"
        return headView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "tianjiaaddcompany")
        return ctImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(oneView)
        oneView.addSubview(ctImageView)
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(110)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: 346, height: 89))
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
