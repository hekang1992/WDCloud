//
//  MyOpinioDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/15.
//  反馈详情页面

import UIKit
import RxRelay

class MyOpinioDetailViewController: WDBaseViewController {
    
    var rowsModel = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "反馈详情"
        return headView
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
        threeView.layer.cornerRadius = 3
        return threeView
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 13)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#333333")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 13)
        return twolabel
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timelabel.textAlignment = .center
        timelabel.font = .regularFontOfSize(size: 12)
        return timelabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "iconimgefankui")
        return ctImageView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .mediumFontOfSize(size: 16)
        let phone = GetSaveLoginInfoConfig.getPhoneNumber()
        phonelabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
        return phonelabel
    }()
    
    lazy var detaillabel: UILabel = {
        let detaillabel = UILabel()
        detaillabel.textColor = UIColor.init(cssStr: "#333333")
        detaillabel.textAlignment = .left
        detaillabel.font = .regularFontOfSize(size: 13)
        detaillabel.numberOfLines = 0
        return detaillabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(threeView)
        
        oneView.addSubview(onelabel)
        twoView.addSubview(twolabel)
        
        view.addSubview(timelabel)
        
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(8)
            make.height.equalTo(43)
        }
        
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom).offset(4)
            make.height.equalTo(43)
        }
        
        threeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(twoView.snp.bottom).offset(38.5)
            make.height.equalTo(184)
        }
        
        timelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom).offset(12)
            make.height.equalTo(16.5)
        }
        
        onelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.bottom.right.equalToSuperview()
        }
        
        twolabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.bottom.right.equalToSuperview()
        }
        
        threeView.addSubview(ctImageView)
        threeView.addSubview(phonelabel)
        threeView.addSubview(detaillabel)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 38, height: 38))
        }
        
        phonelabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView)
            make.height.equalTo(22.5)
            make.left.equalTo(ctImageView.snp.right).offset(10)
        }
        
        detaillabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.rowsModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            onelabel.text = "反馈类型       \(model.feedbacksubtype ?? "")"
            let handlestate = model.handlestate ?? ""
            if handlestate == "1"  {
                twolabel.text = "客服进度       客服已处理"
            }else {
                twolabel.text = "客服进度       客服未处理"
            }
            timelabel.text = model.createtime ?? ""
            detaillabel.text = model.question ?? ""
            let pics = model.piclist ?? []
            
            let padding: CGFloat = 9
            var previousImageView: UIImageView?
            
            for picUrl in pics {
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: picUrl))
                threeView.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    if let previousImageView = previousImageView {
                        make.leading.equalTo(previousImageView.snp.trailing).offset(padding)
                        make.top.equalTo(self.detaillabel.snp.bottom).offset(9)
                        make.size.equalTo(previousImageView)
                    } else {
                        make.leading.equalToSuperview().offset(padding)
                        make.top.equalTo(self.detaillabel.snp.bottom).offset(9)
                        make.size.equalTo(CGSize(width: 50, height: 50))
                    }
                }
                previousImageView = imageView
            }
        }).disposed(by: disposeBag)
        
    }
    
}

