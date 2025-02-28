//
//  BuyOneVipViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/28.
//  购买一次权益

import UIKit

class BuyOneVipViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "购买服务"
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage(named: "onebuyimges")
        return bgImageView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "onebuyimageView")
        return ctImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "miaoshuoneimage")
        return descImageView
    }()
    
    lazy var norBtn: UIButton = {
        let norBtn = UIButton(type: .custom)
        norBtn.isSelected = true
        norBtn.setImage(UIImage(named: "onenormail_nor"), for: .normal)
        norBtn.setImage(UIImage(named: "onenormail_sel"), for: .selected)
        return norBtn
    }()
    
    lazy var proBtn: UIButton = {
        let proBtn = UIButton(type: .custom)
        proBtn.setImage(UIImage(named: "onepromail_nor"), for: .normal)
        proBtn.setImage(UIImage(named: "onepromail_sel"), for: .selected)
        return proBtn
    }()
    
    lazy var bImageView: UIImageView = {
        let bImageView = UIImageView()
        bImageView.image = UIImage(named: "tipsnoebuyimage")
        return bImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(bgImageView)
        bgImageView.addSubview(ctImageView)
        bgImageView.addSubview(descImageView)
        bgImageView.addSubview(norBtn)
        bgImageView.addSubview(proBtn)
        bgImageView.addSubview(bImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 351.pix(), height: 71.pix()))
            make.top.equalToSuperview().offset(18.5)
            make.left.equalToSuperview().offset(15.5)
        }
        descImageView.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.size.equalTo(CGSize(width: 77, height: 13))
            make.top.equalTo(ctImageView.snp.bottom).offset(15.5)
        }
        
        norBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 170.pix(), height: 106.pix()))
            make.top.equalTo(descImageView.snp.bottom).offset(6.5)
            make.left.equalToSuperview().offset(15.5)
        }
        proBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 170.pix(), height: 106.pix()))
            make.top.equalTo(descImageView.snp.bottom).offset(6.5)
            make.right.equalToSuperview().offset(-15.5)
        }
        bImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 358.pix(), height: 110.pix()))
            make.left.equalTo(descImageView.snp.left)
            make.top.equalTo(proBtn.snp.bottom).offset(5)
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
