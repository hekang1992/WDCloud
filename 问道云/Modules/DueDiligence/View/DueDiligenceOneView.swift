//
//  DueDiligenceOneView.swift
//  问道云
//
//  Created by Andrew on 2025/2/18.
//

import UIKit

class DueDiligenceOneView: BaseView {
    
    var block: ((String) -> Void)?
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "duenoolgonimge")
        return oneImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.isUserInteractionEnabled = true
        threeImageView.image = UIImage(named: "startjinzhiimge")
        return threeImageView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        return oneView
    }()
    
    lazy var oneListView: DueDiligenceListView = {
        let oneListView = DueDiligenceListView()
        oneListView.isUserInteractionEnabled = true
        oneListView.rightImageView.isHidden = false
        oneListView.ctImageView.image = UIImage(named: "onedeuimge")
        oneListView.mlabel.text = "企业尽职调查"
        oneListView.bgView.layer.borderWidth = 1
        oneListView.bgView.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return oneListView
    }()
    
    lazy var twoListView: DueDiligenceListView = {
        let twoListView = DueDiligenceListView()
        twoListView.isUserInteractionEnabled = true
        twoListView.rightImageView.isHidden = true
        twoListView.ctImageView.image = UIImage(named: "badzichaimage")
        twoListView.mlabel.text = "不良资产尽职调查"
        twoListView.bgView.layer.borderWidth = 1
        twoListView.bgView.layer.borderColor = UIColor.clear.cgColor
        return twoListView
    }()
    
    lazy var threeListView: DueDiligenceListView = {
        let threeListView = DueDiligenceListView()
        threeListView.isUserInteractionEnabled = true
        threeListView.rightImageView.isHidden = true
        threeListView.ctImageView.image = UIImage(named: "qiyedaikuaniamge")
        threeListView.mlabel.text = "企业贷款尽职调查"
        threeListView.bgView.layer.borderWidth = 1
        threeListView.bgView.layer.borderColor = UIColor.clear.cgColor
        return threeListView
    }()
    
    lazy var fourListView: DueDiligenceListView = {
        let fourListView = DueDiligenceListView()
        fourListView.isUserInteractionEnabled = true
        fourListView.rightImageView.isHidden = true
        fourListView.ctImageView.image = UIImage(named: "dueimgelawimage")
        fourListView.mlabel.text = "企业法律尽职调查"
        fourListView.bgView.layer.borderWidth = 1
        fourListView.bgView.layer.borderColor = UIColor.clear.cgColor
        return fourListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneImageView)
        addSubview(oneView)
        oneView.addSubview(oneListView)
        oneView.addSubview(twoListView)
        oneView.addSubview(threeListView)
        oneView.addSubview(fourListView)
        addSubview(threeImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 325) * 0.5)
            make.top.equalToSuperview().offset(25)
            make.size.equalTo(CGSize(width: 325, height: 94))
        }
        oneView.snp.makeConstraints { make in
            make.centerX.equalTo(oneImageView.snp.centerX)
            make.top.equalTo(oneImageView.snp.bottom).offset(20.5)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(180.pix())
        }
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 154.pix(), height: 78.pix()))
        }
        twoListView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 154.pix(), height: 78.pix()))
        }
        threeListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(18)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 154.pix(), height: 78.pix()))
        }
        fourListView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom).offset(18)
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 154.pix(), height: 78.pix()))
        }
        threeImageView.snp.makeConstraints { make in
            make.centerX.equalTo(oneImageView.snp.centerX)
            make.size.equalTo(CGSize(width: 118, height: 44))
            make.bottom.equalToSuperview().offset(-50)
        }
        
        oneListView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.removeLayer()
                self.clickListView(from: oneListView, type: "1")
            }).disposed(by: disposeBag)
        
        twoListView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                ToastViewConfig.showToast(message: "敬请期待")
                return
                guard let self = self else { return }
                self.removeLayer()
                self.clickListView(from: twoListView, type: "2")
            }).disposed(by: disposeBag)
        
        threeListView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                ToastViewConfig.showToast(message: "敬请期待")
                return
                guard let self = self else { return }
                self.removeLayer()
                self.clickListView(from: threeListView, type: "3")
            }).disposed(by: disposeBag)
        
        fourListView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                ToastViewConfig.showToast(message: "敬请期待")
                return
                guard let self = self else { return }
                self.removeLayer()
                self.clickListView(from: fourListView, type: "4")
            }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeLayer() {
        self.oneListView.bgView.layer.borderColor = UIColor.clear.cgColor
        self.twoListView.bgView.layer.borderColor = UIColor.clear.cgColor
        self.threeListView.bgView.layer.borderColor = UIColor.clear.cgColor
        self.fourListView.bgView.layer.borderColor = UIColor.clear.cgColor
        self.oneListView.rightImageView.isHidden = true
        self.twoListView.rightImageView.isHidden = true
        self.threeListView.rightImageView.isHidden = true
        self.fourListView.rightImageView.isHidden = true
    }
    
    private func clickListView(from view: DueDiligenceListView, type: String) {
        view.rightImageView.isHidden = false
        view.bgView.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        self.block?(type)
    }
    
}
