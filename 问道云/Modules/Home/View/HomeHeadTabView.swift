//
//  HomeHeadTabView.swift
//  问道云
//
//  Created by Andrew on 2025/1/5.
//  首页头部tab切换

import UIKit
import RxRelay
import TXScrollLabelView
import SwiftyJSON

class HomeHeadTabView: BaseView {
    
    var textBlock: ((rowsModel) -> Void)?
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("查企业", for: .normal)
        oneBtn.titleLabel?.font = .semiboldFontOfSize(size: 16)
        oneBtn.setTitleColor(.white, for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("查风险", for: .normal)
        twoBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
        twoBtn.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setTitle("查财产", for: .normal)
        threeBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
        threeBtn.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        return threeBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.layer.cornerRadius = 1
        return lineView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 5
        return whiteView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "searchiconf")
        return ctImageView
    }()
    
    var scrollLabelView: TXScrollLabelView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneBtn)
        addSubview(twoBtn)
        addSubview(threeBtn)
        addSubview(lineView)
        addSubview(whiteView)
        whiteView.addSubview(ctImageView)
        twoBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.pix(), height: 25))
            make.centerX.equalToSuperview()
        }
        oneBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.pix(), height: 25))
            make.right.equalTo(twoBtn.snp.left).offset(-44.pix())
        }
        threeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.pix(), height: 25))
            make.left.equalTo(twoBtn.snp.right).offset(44.pix())
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalTo(oneBtn.snp.centerX)
            make.top.equalTo(oneBtn.snp.bottom).offset(3.5)
            make.size.equalTo(CGSize(width: 25, height: 2))
        }
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(45)
            make.top.equalTo(lineView.snp.bottom).offset(12)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(whiteView)
            make.left.equalToSuperview().offset(11.5)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneBtn.setTitleColor(UIColor.white, for: .normal)
            self.twoBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.threeBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.oneBtn.titleLabel?.font = .semiboldFontOfSize(size: 16)
            self.twoBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            self.threeBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            UIView.animate(withDuration: 0.25) {
                self.lineView.center.x = self.oneBtn.center.x
            }
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.twoBtn.setTitleColor(UIColor.white, for: .normal)
            self.threeBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.oneBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            self.twoBtn.titleLabel?.font = .semiboldFontOfSize(size: 16)
            self.threeBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            UIView.animate(withDuration: 0.25) {
                self.lineView.center.x = self.twoBtn.center.x
            }
        }).disposed(by: disposeBag)
        
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.twoBtn.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            self.threeBtn.setTitleColor(UIColor.white, for: .normal)
            self.oneBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            self.twoBtn.titleLabel?.font = .semiboldFontOfSize(size: 15)
            self.threeBtn.titleLabel?.font = .semiboldFontOfSize(size: 16)
            UIView.animate(withDuration: 0.25) {
                self.lineView.center.x = self.threeBtn.center.x
            }
        }).disposed(by: disposeBag)
        
        modelArray.compactMap { $0 }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let titlesArray = modelArray.map { $0.entityName ?? "" }
            //创建文字上下轮博
            self.scrollLabelView?.endScrolling()
            let scrollLabelView = TXScrollLabelView(textArray: titlesArray, type: .flipNoRepeat, velocity: 2.0, options: .curveEaseInOut, inset: .zero)!
            scrollLabelView.backgroundColor = .white
            scrollLabelView.textAlignment = .left
            scrollLabelView.font = .regularFontOfSize(size: 13)
            scrollLabelView.scrollTitleColor = .init(cssStr: "#333333")
            scrollLabelView.frame = CGRectMake(38, 0, SCREEN_WIDTH - 70, 45)
            scrollLabelView.scrollLabelViewDelegate = self
            self.scrollLabelView = scrollLabelView
            whiteView.addSubview(scrollLabelView)
            scrollLabelView.beginScrolling()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeHeadTabView: TXScrollLabelViewDelegate {
    
    func scrollLabelView(_ scrollLabelView: TXScrollLabelView!, didClickWithText text: String!, at index: Int) {
        if let modelArray = self.modelArray.value, !modelArray.isEmpty {
            let model = modelArray[index]
            self.textBlock?(model)
        }else {
            let json: JSON = ["name": "上海问道云人工智能科技有限公司", "type": "0"]
            let model = rowsModel(json: json)
            self.textBlock?(model)
        }
    }
    
}
