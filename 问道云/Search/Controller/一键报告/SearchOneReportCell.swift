//
//  SearchOneReportCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/19.
//

import UIKit
import RxRelay

class SearchOneReportCell: BaseViewCell {
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 14)
        return mlabel
    }()

    lazy var riImageView: UIImageView = {
        let riImageView = UIImageView()
        riImageView.image = UIImage(named: "yijianbaoimgedd")
        return riImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(mlabel)
        contentView.addSubview(riImageView)
        contentView.addSubview(lineView)
        
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        riImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 53, height: 23))
            make.right.equalToSuperview().offset(-10)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.firmInfo?.entityName ?? ""
            ctImageView.kf.setImage(with: URL(string: model.firmInfo?.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (30, 30)))
            mlabel.text = name
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
