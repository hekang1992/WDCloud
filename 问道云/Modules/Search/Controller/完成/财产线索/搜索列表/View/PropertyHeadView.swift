//
//  PropertyHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/3/13.
//

import UIKit

class PropertyHeadView: BaseView {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "财产线索"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var searchHeadView: HomeItemSearchView = {
        let searchHeadView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入企业名、人名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchHeadView.searchTx.attributedPlaceholder = attrString
        searchHeadView.backgroundColor = .white
        return searchHeadView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        addSubview(searchHeadView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        searchHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
