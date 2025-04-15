//
//  ContactUsViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/15.
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
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        return threeBtn
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
        let height = SCREEN_WIDTH / 376 * 314
        view.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: height))
            make.top.equalTo(mlabel.snp.bottom).offset(18.5)
        }
        
        ctImageView.addSubview(oneBtn)
        ctImageView.addSubview(twoBtn)
        ctImageView.addSubview(threeBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(50)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneBtn.snp.bottom)
            make.height.equalTo(50)
        }
        
        threeBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoBtn.snp.bottom)
            make.height.equalTo(50)
        }
        
        oneBtn.rx.tap.subscribe(onNext: {
            if let url = URL(string: "mailto:kefu@wintaocloud.com") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            makePhoneCall(phoneNumber: "4006326699")
        }).disposed(by: disposeBag)
        
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let pageUrl = "https://www.wintaocloud.com"
            self.pushWebPage(from: pageUrl)
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
