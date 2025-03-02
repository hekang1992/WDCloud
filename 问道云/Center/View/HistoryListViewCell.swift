//
//  HistoryListViewCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/27.
//

import UIKit
import RxRelay

class HistoryListViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 6
        bgView.backgroundColor = .init(cssStr: "#FFFFFF")
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 14)
        return namelabel
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#999999")
        timelabel.textAlignment = .right
        timelabel.font = .regularFontOfSize(size: 12)
        return timelabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(timelabel)
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.top.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        timelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-22)
            make.height.equalTo(18)
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ctImageView.snp.right).offset(7.5)
            make.height.equalTo(20)
            make.right.equalTo(timelabel.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-11)
        }
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let personname = model.personname ?? ""
            if personname.isEmpty {
                namelabel.text = model.firmname
            }else {
                namelabel.text = personname
            }
            timelabel.text = model.createhourtime
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (24, 24)))
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
