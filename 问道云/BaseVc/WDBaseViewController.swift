//
//  WDBaseViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import RxSwift

class WDBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var emptyView: LLemptyView = {
        let emptyView = LLemptyView()
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(cssStr: "#F4F6FC")
    }

}


extension WDBaseViewController {
    
    func popLogin() {
        let loginVc = WDLoginViewController()
        let rootVc = WDNavigationController(rootViewController: loginVc)
        rootVc.modalPresentationStyle = .overFullScreen
        self.present(rootVc, animated: true)
        
        loginVc.loginView.backBtn.rx.tap.subscribe(onNext: {
            WDLoginConfig.removeLoginInfo()
            NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
        }).disposed(by: disposeBag)
    }
    
    func pushWebPage(from pageUrl: String) {
        let webVc = WebPageViewController()
        let webUrl = base_url + pageUrl
        webVc.pageUrl.accept(webUrl)
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func addNodataView(form view: UIView) {
        view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 163) * 0.5)
            make.size.equalTo(CGSize(width: 163, height: 163))
        }
    }
    
}

