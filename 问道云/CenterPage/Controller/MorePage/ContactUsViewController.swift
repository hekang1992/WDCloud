//
//  ContactUsViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  联系我们

import UIKit

class ContactUsViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "联系我们"
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "lianxiwomimag")
        return ctImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "launchlogo")
        
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.top.equalTo(headView.snp.bottom).offset(32)
        }
        
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 18)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            mlabel.text = "问道云 V\(version)"
        }
        view.addSubview(mlabel)
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(15)
            make.height.equalTo(25)
        }
        
        view.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(312)
            make.top.equalTo(mlabel.snp.bottom).offset(18.5)
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
