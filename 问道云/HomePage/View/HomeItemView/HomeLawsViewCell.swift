//
//  HomeLawsViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit

class HomeLawsViewCell: BaseViewCell {

    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            namelabel.text = model.title ?? ""
            qlabel.text = model.formulatingAuthority ?? ""
            wlabel.text = model.lawCategory ?? ""
            elabel.text = "--"
            let entryIntoForceTime = model.entryIntoForceTime ?? ""
            if entryIntoForceTime.isEmpty {
                rlabel.text = "--"
            }else {
                rlabel.text = entryIntoForceTime
            }
            tlabel.text = model.lawCategory ?? ""
            let timeliness = model.timeliness ?? ""
            if timeliness.contains("有效") {
                taglabel.backgroundColor = .init(cssStr: "#4DC929")?.withAlphaComponent(0.1)
                taglabel.textColor = .init(cssStr: "#4DC929")
            }else {
                taglabel.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.1)
                taglabel.textColor = .init(cssStr: "#F55B5B")
            }
        }
    }
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 14)
        return namelabel
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 13)
        onelabel.text = "制定机关:"
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 13)
        twolabel.text = "效力位阶:"
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        threelabel.textAlignment = .left
        threelabel.font = .regularFontOfSize(size: 13)
        threelabel.text = "公布时间:"
        return threelabel
    }()
    
    lazy var fourlabel: UILabel = {
        let fourlabel = UILabel()
        fourlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        fourlabel.textAlignment = .left
        fourlabel.font = .regularFontOfSize(size: 13)
        fourlabel.text = "生效时间:"
        return fourlabel
    }()
    
    lazy var fivelabel: UILabel = {
        let fivelabel = UILabel()
        fivelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        fivelabel.textAlignment = .left
        fivelabel.font = .regularFontOfSize(size: 13)
        fivelabel.text = "全文检索:"
        return fivelabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "rightlrayimge")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    
    lazy var qlabel: UILabel = {
        let qlabel = UILabel()
        qlabel.textColor = UIColor.init(cssStr: "#333333")
        qlabel.textAlignment = .left
        qlabel.font = .regularFontOfSize(size: 13)
        return qlabel
    }()
    
    lazy var wlabel: UILabel = {
        let wlabel = UILabel()
        wlabel.textColor = UIColor.init(cssStr: "#333333")
        wlabel.textAlignment = .left
        wlabel.font = .regularFontOfSize(size: 13)
        return wlabel
    }()
    
    lazy var elabel: UILabel = {
        let elabel = UILabel()
        elabel.textColor = UIColor.init(cssStr: "#333333")
        elabel.textAlignment = .left
        elabel.font = .regularFontOfSize(size: 13)
        return elabel
    }()
    
    lazy var rlabel: UILabel = {
        let rlabel = UILabel()
        rlabel.textColor = UIColor.init(cssStr: "#333333")
        rlabel.textAlignment = .left
        rlabel.font = .regularFontOfSize(size: 13)
        return rlabel
    }()
    
    lazy var tlabel: UILabel = {
        let tlabel = UILabel()
        tlabel.textColor = UIColor.init(cssStr: "#333333")
        tlabel.textAlignment = .left
        tlabel.font = .regularFontOfSize(size: 13)
        tlabel.numberOfLines = 0
        return tlabel
    }()
    
    lazy var taglabel: PaddedLabel = {
        let taglabel = PaddedLabel()
        taglabel.textColor = UIColor.init(cssStr: "#333333")
        taglabel.textAlignment = .center
        taglabel.font = .regularFontOfSize(size: 10)
        taglabel.backgroundColor = .init(cssStr: "#4DC929")?.withAlphaComponent(0.1)
        taglabel.textColor = .init(cssStr: "#4DC929")
        return taglabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(namelabel)
        contentView.addSubview(onelabel)
        contentView.addSubview(twolabel)
        contentView.addSubview(threelabel)
        contentView.addSubview(fourlabel)
        contentView.addSubview(fivelabel)
        contentView.addSubview(lineView)
        contentView.addSubview(qlabel)
        contentView.addSubview(wlabel)
        contentView.addSubview(elabel)
        contentView.addSubview(rlabel)
        contentView.addSubview(tlabel)
        contentView.addSubview(taglabel)
        contentView.addSubview(ctImageView)
        namelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
            make.height.equalTo(20)
        }
        onelabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(3)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        twolabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(onelabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        threelabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(twolabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        fourlabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(threelabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        fivelabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(fourlabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        qlabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(onelabel.snp.right)
            make.height.equalTo(18.5)
        }
        wlabel.snp.makeConstraints { make in
            make.centerY.equalTo(twolabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right)
            make.height.equalTo(18.5)
        }
        elabel.snp.makeConstraints { make in
            make.centerY.equalTo(threelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right)
            make.height.equalTo(18.5)
        }
        rlabel.snp.makeConstraints { make in
            make.centerY.equalTo(fourlabel.snp.centerY)
            make.left.equalTo(fourlabel.snp.right)
            make.height.equalTo(18.5)
        }
        tlabel.snp.makeConstraints { make in
            make.centerY.equalTo(fivelabel.snp.centerY)
            make.left.equalTo(fivelabel.snp.right)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-15.5)
        }
        taglabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-26)
            make.height.equalTo(15)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
