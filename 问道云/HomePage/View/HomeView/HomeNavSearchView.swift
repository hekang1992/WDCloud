//
//  HomeNavSearchView.swift
//  问道云
//
//  Created by 何康 on 2025/2/8.
//

import UIKit
import RxRelay
import TXScrollLabelView
import SwiftyJSON

class HomeNavSearchView: BaseView {
    
    var textBlock: ((rowsModel) -> Void)?
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var scrollLabelView: TXScrollLabelView?
    
    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        searchView.layer.cornerRadius = 5
        return searchView
    }()
    
    lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView()
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.image = UIImage(named: "searchiconf")
        return searchIcon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchView)
        searchView.addSubview(searchIcon)
        searchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(45)
        }
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        modelArray.compactMap { $0 }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let titlesArray = modelArray.map { $0.name ?? "" }
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
            searchView.addSubview(scrollLabelView)
            scrollLabelView.beginScrolling()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeNavSearchView: TXScrollLabelViewDelegate {
    
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
