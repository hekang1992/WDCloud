//
//  InviteFriendViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/16.
//  邀请好友

import UIKit
import TYAlertController

class PopWechatView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F6F6F7")
        return bgView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "分享至"
        mlabel.textColor = UIColor.init(cssStr: "#27344B")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 14)
        return mlabel
    }()
    
    lazy var friendBtn: UIButton = {
        let friendBtn = UIButton(type: .custom)
        friendBtn.adjustsImageWhenHighlighted = false
        friendBtn.setImage(UIImage(named: "微信好友"), for: .normal)
        return friendBtn
    }()
    
    lazy var cycleBtn: UIButton = {
        let cycleBtn = UIButton(type: .custom)
        cycleBtn.adjustsImageWhenHighlighted = false
        cycleBtn.setImage(UIImage(named: "朋友圈"), for: .normal)
        return cycleBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#27344B"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(mlabel)
        bgView.addSubview(friendBtn)
        bgView.addSubview(cycleBtn)
        bgView.addSubview(cancelBtn)
        bgView.snp.makeConstraints { make in
            make.height.equalTo(228)
            make.bottom.left.right.equalToSuperview()
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(17)
        }
        friendBtn.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 56, height: 77))
        }
        cycleBtn.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(28)
            make.left.equalTo(friendBtn.snp.right).offset(26)
            make.size.equalTo(CGSize(width: 56, height: 77))
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(cycleBtn.snp.bottom).offset(24.5)
            make.bottom.right.left.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 10)
    }
    
}

class InviteFriendViewController: WDBaseViewController {
    
    lazy var wechatView: PopWechatView = {
        let wechatView = PopWechatView(frame: self.view.bounds)
        return wechatView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "邀请好友"
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "yaoqingbg")
        return ctImageView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.isUserInteractionEnabled = true
        oneImageView.image = UIImage(named: "yaoqingguize")
        return oneImageView
    }()
    
    lazy var viteBtn: UIButton = {
        let viteBtn = UIButton(type: .custom)
        viteBtn.adjustsImageWhenHighlighted = false
        viteBtn.setImage(UIImage(named: "yaoqingbtnimage"), for: .normal)
        return viteBtn
    }()
    
    var inviteStr: String = ""
    
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
            make.size.equalTo(CGSize(width: 336, height: 193))
        }
        
        ctImageView.addSubview(viteBtn)
        viteBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 344, height: 55))
            make.top.equalTo(oneImageView.snp.bottom).offset(3)
        }
        
        viteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let alertVc = TYAlertController(alert: wechatView, preferredStyle: .actionSheet)
            self.present(alertVc!, animated: true)
            wechatView.friendBtn.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true) {
                    self.friendInfo()
                }
            }).disposed(by: disposeBag)
            wechatView.cycleBtn.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true) {
                    self.cycleInfo()
                }
            }).disposed(by: disposeBag)
            wechatView.cancelBtn.rx.tap.subscribe(onNext: {
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        let recommendCustomernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        inviteStr = base_url + "/propagate-buy?recommendType=2&isRootCustomer=1&recommendCustomernumber=\(recommendCustomernumber)"
    }
    
}

extension InviteFriendViewController {
    
    private func friendInfo() {
        
        shareContent(
            title: "问道云邀请您即刻领取会员",
            description: "注册有好礼,开通会员,享专属权益",
            thumbImageName: "wechaimageicon",
            webpageUrl: inviteStr,
            scene: Int32(WXSceneSession.rawValue)
        )
    }
    
    private func cycleInfo() {
        shareContent(
            title: "问道云邀请您即刻领取会员",
            description: "注册有好礼,开通会员,享专属权益",
            thumbImageName: "wechaimageicon",
            webpageUrl: inviteStr,
            scene: Int32(WXSceneTimeline.rawValue)
        )
    }
    
    private func shareContent(title: String, description: String, thumbImageName: String, webpageUrl: String, scene: Int32) {
        guard WXApi.isWXAppInstalled() else {
            ToastViewConfig.showToast(message: "您尚未安装微信，请先完成安装后再尝试分享")
            return
        }
        guard let thumbImage = UIImage(named: thumbImageName) else {
            return
        }
        let message = WXMediaMessage()
        message.title = title
        message.description = description
        message.setThumbImage(thumbImage)
        
        let webpageObject = WXWebpageObject()
        webpageObject.webpageUrl = webpageUrl
        message.mediaObject = webpageObject
        
        let req = SendMessageToWXReq()
        req.message = message
        req.bText = false
        req.scene = scene
        
        WXApi.send(req) { success in
            print(success ? "请求发送成功" : "请求发送失败")
        }
    }
    
}
