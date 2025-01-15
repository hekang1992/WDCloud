//
//  CompanyStockInfoView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit
import SwiftyJSON
import RxRelay
import RxSwift

class StockViewModel {
    var imageUrl: String
    var nameUrl: String
    var wenUrl: String
    init(json: JSON) {
        self.imageUrl = json["imageUrl"].stringValue
        self.nameUrl = json["nameUrl"].stringValue
        self.wenUrl = json["wenUrl"].stringValue
    }
}

let jsonData1 = JSON([
    "imageUrl": "重大事项",
    "nameUrl": "企业简介",
    "wenUrl": "/listed-company/company-profile"
])

let jsonData2 = JSON([
    "imageUrl": "证券信息",
    "nameUrl": "证券信息",
    "wenUrl": "/listed-company/securities-information"
])

let jsonData3 = JSON([
    "imageUrl": "财务指标",
    "nameUrl": "财务指标",
    "wenUrl": "/listed-company/financial-indicator"
])

let jsonData4 = JSON([
    "imageUrl": "董监高",
    "nameUrl": "董监高信息",
    "wenUrl": "/listed-company/dong-jian-gao-info"
])

let jsonData5 = JSON([
    "imageUrl": "股东持股情况",
    "nameUrl": "主要股东",
    "wenUrl": "/listed-company/top-ten-shareholders"
])

let jsonData6 = JSON([
    "imageUrl": "公司公告",
    "nameUrl": "公告大全",
    "wenUrl": "/listed-company/listing-announcement"
])

let jsonData7 = JSON([
    "imageUrl": "新闻舆情",
    "nameUrl": "新闻舆情",
    "wenUrl": "/listed-company/enterprise-opinion"
])

let jsonData8 = JSON([
    "imageUrl": "联系信息",
    "nameUrl": "联系信息",
    "wenUrl": "/listed-company/contact-information"
])

let model1 = StockViewModel(json: jsonData1)
let model2 = StockViewModel(json: jsonData2)
let model3 = StockViewModel(json: jsonData3)
let model4 = StockViewModel(json: jsonData4)
let model5 = StockViewModel(json: jsonData5)
let model6 = StockViewModel(json: jsonData6)
let model7 = StockViewModel(json: jsonData7)
let model8 = StockViewModel(json: jsonData8)

class CompanyStockInfoView: BaseView {
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    let modelArray = [model1, model2, model3, model4, model5, model6, model7, model8]
    
    var modelArrayRx = BehaviorRelay<[StockViewModel]>(value: [])
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#666666")
        return lineView
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .mediumFontOfSize(size: 11)
        timeLabel.textColor = .init(cssStr: "#666666")
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var jgLabel: UILabel = {
        let jgLabel = UILabel()
        jgLabel.font = .boldFontOfSize(size: 18)
        jgLabel.textColor = .init(cssStr: "#4DC929")
        jgLabel.textAlignment = .left
        return jgLabel
    }()
    
    //detail_stock_down
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "detailstockdown")
        return ctImageView
    }()
    
    lazy var zdLabel: UILabel = {
        let zdLabel = UILabel()
        zdLabel.font = .semiboldFontOfSize(size: 11)
        zdLabel.textColor = .init(cssStr: "#4DC929")
        zdLabel.textAlignment = .center
        return zdLabel
    }()
    
    lazy var typeLabel: PaddedLabel = {
        let typeLabel = PaddedLabel()
        typeLabel.font = .regularFontOfSize(size: 11)
        typeLabel.textAlignment = .center
        typeLabel.textColor = .init(cssStr: "#666666")
        typeLabel.layer.cornerRadius = 1
        typeLabel.backgroundColor = .init(cssStr: "#F3F3F3")
        return typeLabel
    }()
    
    lazy var updateLabel: UILabel = {
        let updateLabel = UILabel()
        updateLabel.font = .mediumFontOfSize(size: 11)
        updateLabel.textColor = .init(cssStr: "#666666")
        updateLabel.textAlignment = .right
        return updateLabel
    }()
    
    lazy var itemView1: ItemStockView = {
        let itemView1 = ItemStockView()
        itemView1.nameLabel.text = "总市值"
        return itemView1
    }()
    
    lazy var itemView2: ItemStockView = {
        let itemView2 = ItemStockView()
        itemView2.nameLabel.text = "市净率"
        return itemView2
    }()
    
    lazy var itemView3: ItemStockView = {
        let itemView3 = ItemStockView()
        itemView3.nameLabel.text = "市盈率"
        return itemView3
    }()
    
    lazy var itemView4: ItemStockView = {
        let itemView4 = ItemStockView()
        itemView4.nameLabel.text = "今日开盘价"
        return itemView4
    }()
    
    lazy var itemView5: ItemStockView = {
        let itemView5 = ItemStockView()
        itemView5.nameLabel.text = "流通市值"
        return itemView5
    }()
    
    lazy var itemView6: ItemStockView = {
        let itemView6 = ItemStockView()
        itemView6.nameLabel.text = "今日成交量"
        return itemView6
    }()
    
    lazy var itemView7: ItemStockView = {
        let itemView7 = ItemStockView()
        itemView7.nameLabel.text = "今日成交额"
        return itemView7
    }()
    
    lazy var itemView8: ItemStockView = {
        let itemView8 = ItemStockView()
        itemView8.nameLabel.text = "前日收盘价"
        return itemView8
    }()
    
    let itemWidth = floor((SCREEN_WIDTH) * 0.25)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: 18)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collectView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        collectView.backgroundColor = .white
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.alwaysBounceHorizontal = false
        collectView.clipsToBounds = true
        collectView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        collectView.isScrollEnabled = false
        collectView.register(DetailStockViewCell.self, forCellWithReuseIdentifier: "DetailStockViewCell")
        return collectView
    }()
    
    lazy var tlineView: UIView = {
        let tlineView = UIView()
        tlineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return tlineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(nameLabel)
        addSubview(lineView)
        addSubview(timeLabel)
        addSubview(icon)
        addSubview(jgLabel)
        addSubview(ctImageView)
        addSubview(zdLabel)
        addSubview(typeLabel)
        addSubview(updateLabel)
        addSubview(itemView1)
        addSubview(itemView2)
        addSubview(itemView3)
        addSubview(itemView4)
        addSubview(itemView5)
        addSubview(itemView6)
        addSubview(itemView7)
        addSubview(itemView8)
        addSubview(collectionView)
        addSubview(tlineView)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.equalTo(0.5)
            make.height.equalTo(12)
            make.left.equalTo(nameLabel.snp.right).offset(5)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(12)
            make.left.equalTo(lineView.snp.right).offset(5)
        }
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-13)
            make.size.equalTo(CGSize(width: 28, height: 16))
        }
        jgLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(21)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(jgLabel.snp.centerY)
            make.left.equalTo(jgLabel.snp.right).offset(3)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        zdLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(15)
            make.left.equalTo(ctImageView.snp.right).offset(3)
        }
        typeLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(zdLabel.snp.right).offset(4)
        }
        updateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(15)
        }
        itemView1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(updateLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView2.snp.makeConstraints { make in
            make.left.equalTo(itemView1.snp.right)
            make.top.equalTo(updateLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView3.snp.makeConstraints { make in
            make.left.equalTo(itemView2.snp.right)
            make.top.equalTo(updateLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView4.snp.makeConstraints { make in
            make.left.equalTo(itemView3.snp.right)
            make.top.equalTo(updateLabel.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView5.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(itemView1.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView6.snp.makeConstraints { make in
            make.left.equalTo(itemView5.snp.right)
            make.top.equalTo(itemView1.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView7.snp.makeConstraints { make in
            make.left.equalTo(itemView6.snp.right)
            make.top.equalTo(itemView1.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        itemView8.snp.makeConstraints { make in
            make.left.equalTo(itemView7.snp.right)
            make.top.equalTo(itemView1.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH * 0.25, height: 34.5))
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(itemView8.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
//        tlineView.snp.makeConstraints { make in
//            make.left.right.equalToSuperview()
//            make.height.equalTo(4)
//            make.top.equalTo(collectionView.snp.bottom).offset(6.5)
//        }
        
        modelArrayRx.accept(modelArray)
        
        modelArrayRx.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "DetailStockViewCell", cellType: DetailStockViewCell.self)) { row, model, cell in
            cell.model.accept(model)
        }.disposed(by: disposeBag)
        
        dataModel.asObservable().subscribe(onNext: { [weak self] model in
            if let self = self, let stockModel = model?.stockInfo?.first, let valueModel = stockModel.value {
                self.icon.image = UIImage(named: stockModel.key ?? "")
                
                self.nameLabel.text = valueModel.stockName ?? ""
                
                self.timeLabel.text = "\(valueModel.listingTime ?? "")上市"
                
                let yClosePrice = Double(valueModel.yClosePrice ?? "") ?? 0.0
                
                let riseFall = Double(valueModel.riseFall ?? "") ?? 0.0
                
                let jgPrice = String(format: "%.2f", yClosePrice + riseFall)
                
                if riseFall > 0 {
                    self.ctImageView.isHidden = false
                    self.ctImageView.image = UIImage(named: "shangshsenicon")
                    self.jgLabel.textColor = .init(cssStr: "#F55B5B")
                    self.zdLabel.textColor = .init(cssStr: "#F55B5B")
                }else if riseFall == 0 {
                    self.ctImageView.isHidden = true
                    self.jgLabel.textColor = .init(cssStr: "#4DC929")
                    self.zdLabel.textColor = .init(cssStr: "#4DC929")
                }else {
                    self.ctImageView.isHidden = false
                    self.ctImageView.image = UIImage(named: "detailstockdown")
                    self.jgLabel.textColor = .init(cssStr: "#4DC929")
                    self.zdLabel.textColor = .init(cssStr: "#4DC929")
                }
                self.jgLabel.text = jgPrice
                
                self.zdLabel.text = "(\(valueModel.riseFallRatio ?? "--")%)"
                
                let listingStatus = model?.firmInfo?.listingStatus ?? ""
                if listingStatus != "1" {
                    self.typeLabel.text = "退市"
                    self.typeLabel.textColor = .init(cssStr: "#666666")
                }else {
                    self.typeLabel.text = "上市"
                    self.typeLabel.textColor = .init(cssStr: "#4DC929")
                }
                
                self.updateLabel.text = "\(valueModel.updateDate ?? "")更新"
                
                self.itemView1.numLabel.text = valueModel.totalMarketValue ?? ""
                self.itemView2.numLabel.text = valueModel.netRate ?? ""
                self.itemView3.numLabel.text = valueModel.earningsRatio ?? ""
                self.itemView4.numLabel.text = valueModel.openPriceToday ?? ""
                self.itemView5.numLabel.text = valueModel.circulatingMarketValue ?? ""
                self.itemView6.numLabel.text = valueModel.tradingVolume ?? ""
                self.itemView7.numLabel.text = valueModel.volumeOfBusiness ?? ""
                self.itemView8.numLabel.text = valueModel.yClosePrice
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ItemStockView: UIView {
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = .regularFontOfSize(size: 11)
        nameLabel.textColor = .init(cssStr: "#9FA4AD")
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .center
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#333333")
        return numLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#D9D9D9")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(numLabel)
        addSubview(lineView)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(15)
        }
        numLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(10.5)
            make.right.equalToSuperview()
            make.width.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DetailStockViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<StockViewModel?>(value: nil)
    
    private lazy var imv: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(cssStr: "#333333")
        label.font = .regularFontOfSize(size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        contentView.addSubview(imv)
        contentView.addSubview(titleLabel)
        
        imv.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imv.snp.right).offset(2)
            make.centerY.equalTo(imv.snp.centerY)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            titleLabel.text = model?.nameUrl
            imv.image = UIImage(named: model?.imageUrl ?? "")
        }).disposed(by: disposeBag)
        
    }
    
//    func setUI(with data: StockItem) {
//        titleLabel.text = data.title
//        imv.image = .init(named: data.imageName)
//    }
    
    
    
}
