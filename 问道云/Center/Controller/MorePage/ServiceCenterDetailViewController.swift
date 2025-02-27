//
//  ServiceCenterDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/15.
//

import UIKit
import RxRelay

class ServiceCenterDetailViewController: WDBaseViewController {
    
    var itemModel = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "常见问题"
        return headView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#666666")
        descLabel.font = .regularFontOfSize(size: 14)
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(nameLabel)
        view.addSubview(descLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.top.equalTo(headView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(16)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.left.equalTo(nameLabel.snp.left)
        }
        
        self.itemModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.title ?? ""
            let content = model.content ?? ""
            if let attributedString = content.htmlToAttributedString {
                descLabel.attributedText = attributedString
            }
        }).disposed(by: disposeBag)
        
        
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
