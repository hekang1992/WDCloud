//
//  MyCollectionSpecialReusableView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//  企业详情的自定义头部

import UIKit
import RxSwift
import RxRelay

class MyCollectionSpecialReusableView: UICollectionReusableView {
        
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    static let identifier = "MyCollectionSpecialReusableView"
    
    lazy var headView: CompanyDetailHeadView = {
        let headView = CompanyDetailHeadView()
        return headView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            headView.oneHeadView.iconImageView.kf.setImage(with: URL(string: model.firmInfo?.logo ?? ""), placeholder: UIImage.imageOfText(model.firmInfo?.entityName ?? "", size: (40, 40)))
            headView.oneHeadView.namelabel.text = model.firmInfo?.entityName ?? ""
            headView.oneHeadView.numlabel.text = model.firmInfo?.usCreditCode ?? ""
           
            let riskLabels = model.warnLabels?.compactMap{ $0.name } ?? []
            headView.oneHeadView.tagArray.accept(riskLabels)
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
