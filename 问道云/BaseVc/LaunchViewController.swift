//
//  LaunchViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit
import TYAlertController

let CLICK_PRIVACY = "CLICK_PRIVACY"

class LaunchViewController: WDBaseViewController {
    
    lazy var homeBgImageView: UIImageView = {
        let homeBgImageView = UIImageView()
        homeBgImageView.image = UIImage(named: "homelacunchimage")
        homeBgImageView.contentMode = .scaleAspectFit
        return homeBgImageView
    }()
    
    lazy var priImageView: UIImageView = {
        let priImageView = UIImageView()
        priImageView.isUserInteractionEnabled = true
        priImageView.image = UIImage(named: "apppriimage")
        priImageView.contentMode = .scaleAspectFit
        return priImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeBgImageView)
        view.addSubview(priImageView)
        homeBgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let clickStr = UserDefaults.standard.object(forKey: CLICK_PRIVACY) as? String ?? ""
        if clickStr == "1" {
            NetworkManager.shared.startListening()
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.showAlertPrivacyView()
            }
        }
        
        
    }
    
}

extension LaunchViewController {
    
    private func showAlertPrivacyView() {
        let popView = PopPrivacyView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 400.pix()))
        let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)!
        self.present(alertVc, animated: true)
        
        popView.cancelBtn.rx.tap.subscribe(onNext: {
            exit(0)
        }).disposed(by: disposeBag)
        
        popView.sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.savePrivacyInfo()
            NetworkManager.shared.startListening()
        }).disposed(by: disposeBag)
        
        popView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let pageUrl = base_url + privacy_url
            let webVc = WebPageViewController()
            webVc.modalPresentationStyle = .fullScreen
            webVc.pageUrl.accept(pageUrl)
            self.dismiss(animated: true, completion: {
                self.present(webVc, animated: true)
            })
            webVc.headView.backBtn.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.showAlertPrivacyView()
                    }
                })
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        popView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let pageUrl = base_url + agreement_url
            let webVc = WebPageViewController()
            webVc.modalPresentationStyle = .fullScreen
            webVc.pageUrl.accept(pageUrl)
            self.dismiss(animated: true, completion: {
                self.present(webVc, animated: true)
            })
            webVc.headView.backBtn.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.showAlertPrivacyView()
                    }
                })
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
    }
    
    private func savePrivacyInfo() {
        UserDefaults.standard.setValue("1", forKey: CLICK_PRIVACY)
        UserDefaults.standard.synchronize()
    }
    
}
