//
//  BindWechatViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/27.
//

import UIKit

class BindWechatViewController: WDBaseViewController {
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "backimage"), for: .normal)
        return backBtn
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "jiebangoimge")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "jiebangotwo")
        return twoImageView
    }()
    
    lazy var bindBtn: UIButton = {
        let bindBtn = UIButton(type: .custom)
        bindBtn.setTitle("解除绑定", for: .normal)
        bindBtn.backgroundColor = .init(cssStr: "#547AFF")
        bindBtn.layer.cornerRadius = 4
        bindBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
        bindBtn.setTitleColor(.white, for: .normal)
        return bindBtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(oneImageView)
        view.addSubview(twoImageView)
        view.addSubview(bindBtn)
        view.addSubview(backBtn)
        
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 375.pix()))
        }
        
        twoImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 340.pix(), height: 340.pix()))
        }
        
        bindBtn.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(30.5.pix())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(twoImageView.snp.top).offset(-26.5)
            make.width.equalTo(147.pix())
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 10)
            make.left.equalToSuperview().offset(26)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        bindBtn.rx.tap.subscribe(onNext: { [weak self] in
            ShowAlertManager.showAlert(title: "解绑提示", message: "解绑后，您将不能在微信公众号中收到提醒，可能错过重要消息", confirmTitle: "仍要解绑", cancelTitle: "我在想想", confirmAction: {
                self?.cancelBindInfo()
            })
        }).disposed(by: disposeBag)
        
    }

}

extension BindWechatViewController {
    
    private func cancelBindInfo() {
        let man = RequestManager()
        man.requestAPI(params: [String: String](),
                       pageUrl: "/entity/wechat-bind/cancelBindPubMsg",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "解绑成功")
                    self?.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
