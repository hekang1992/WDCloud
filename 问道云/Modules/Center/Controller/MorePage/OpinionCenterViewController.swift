//
//  OpinionCenterViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/14.
//

import UIKit

class OpinionCenterViewController: WDBaseViewController {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.oneBtn.setBackgroundImage(UIImage(named: "wodeyijianfankui"), for: .normal)
        headView.titlelabel.text = "意见反馈"
        return headView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.text = "请选择反馈的问题类型"
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "dianhuemailimage")
        return ctImageView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.backgroundColor = .white
        oneBtn.setImage(UIImage(named: "oneyijinaimage"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.backgroundColor = .white
        twoBtn.setImage(UIImage(named: "twoyijinaimage"), for: .normal)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.backgroundColor = .white
        threeBtn.setImage(UIImage(named: "threeyijinaimage"), for: .normal)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.backgroundColor = .white
        fourBtn.setImage(UIImage(named: "fouryijinaimage"), for: .normal)
        return fourBtn
    }()
    
    lazy var fiveBtn: UIButton = {
        let fiveBtn = UIButton(type: .custom)
        fiveBtn.backgroundColor = .white
        fiveBtn.setImage(UIImage(named: "fiveyijinaimage"), for: .normal)
        return fiveBtn
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.backgroundColor = .white
        return threeView
    }()
    
    lazy var fourView: UIView = {
        let fourView = UIView()
        fourView.backgroundColor = .white
        return fourView
    }()
    
    lazy var fiveView: UIView = {
        let fiveView = UIView()
        fiveView.backgroundColor = .white
        return fiveView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(desclabel)
        
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(threeView)
        view.addSubview(fourView)
        view.addSubview(fiveView)
        
        oneView.addSubview(oneBtn)
        twoView.addSubview(twoBtn)
        threeView.addSubview(threeBtn)
        fourView.addSubview(fourBtn)
        fiveView.addSubview(fiveBtn)
        
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 188, height: 81))
            make.bottom.equalToSuperview().offset(-40)
        }
        desclabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12.5)
        }
        
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(68.5)
            make.top.equalTo(desclabel.snp.bottom).offset(10)
        }
        
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(68.5)
            make.top.equalTo(oneView.snp.bottom).offset(8)
        }
        
        threeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(68.5)
            make.top.equalTo(twoView.snp.bottom).offset(8)
        }
        
        fourView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(68.5)
            make.top.equalTo(threeView.snp.bottom).offset(8)
        }
        
        fiveView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(68.5)
            make.top.equalTo(fourView.snp.bottom).offset(8)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 339.pix(), height: 44.pix()))
        }
        
        twoBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 339.pix(), height: 44.pix()))
        }
        
        threeBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 339.pix(), height: 44.pix()))
        }
        
        fourBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 339.pix(), height: 44.pix()))
        }
        
        fiveBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 339, height: 44))
        }
        tapClickInfo()
    }

}

extension OpinionCenterViewController {
    
    private func tapClickInfo() {
        
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let myVc = MyOpinioViewController()
            self?.navigationController?.pushViewController(myVc, animated: true)
        }).disposed(by: disposeBag)
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let listVc = OpinionListCenterViewController()
            listVc.feedbacktype.accept("1")
            listVc.titles = ["页面无法打卡/报错",
                             "页面加载缓慢",
                             "页面闪退/黑屏白屏/卡顿",
                             "按钮点击异常/无反应",
                             "无法支付/支付异常",
                             "无法开具发票",
                             "无法导出/下载"]
            self?.navigationController?.pushViewController(listVc, animated: true)
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            let listVc = OpinionListCenterViewController()
            listVc.feedbacktype.accept("2")
            listVc.titles = ["数据更新不及时",
                             "数据展示报错",
                             "搜索无数据",
                             "数据展示涉及个人隐私",
                             "其他数据问题"]
            self?.navigationController?.pushViewController(listVc, animated: true)
        }).disposed(by: disposeBag)
        
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            let listVc = OpinionListCenterViewController()
            listVc.feedbacktype.accept("3")
            listVc.titles = ["会员无法购买",
                             "会员权益为生效",
                             "会员时长不确定",
                             "变更会员手机号",
                             "其他会员问题"]
            self?.navigationController?.pushViewController(listVc, animated: true)
        }).disposed(by: disposeBag)
        fourBtn.rx.tap.subscribe(onNext: {
            ToastViewConfig.showToast(message: "敬请期待")
        }).disposed(by: disposeBag)
        
        fiveBtn.rx.tap.subscribe(onNext: { [weak self] in
            let uploadVc = OpinioUpLoadViewController()
            uploadVc.questionTitle = "问题类型: 向开发者反馈产品及服务相关优化建议"
            self?.navigationController?.pushViewController(uploadVc, animated: true)
            uploadVc.feedbacktype.accept("5")
        }).disposed(by: disposeBag)

    }
    
}
