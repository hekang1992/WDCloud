//
//  HomeHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/5.
//  首页头部View

import UIKit
import TYCyclePagerView
import RxSwift
import RxRelay

class HomeHeadView: BaseView {
    
    //banner数组
    var bannerModelArray: [rowsModel]? {
        didSet {
            self.bannerView.reloadData()
        }
    }
    
    //首页items数组
    var itemModelArray = BehaviorRelay<[childrenModel]?>(value: nil)
    
    var bannerBlock: (() -> Void)?
    var itemBlock: ((childrenModel) -> Void)?
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "appheadbgimage")
        return ctImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "appbiaoqianimage")
        return iconImageView
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.isUserInteractionEnabled = true
        vipImageView.image = UIImage(named: "homehuiyuanicon")
        return vipImageView
    }()
    
    //tab切换
    lazy var tabView: HomeHeadTabView = {
        let tabView = HomeHeadTabView()
        return tabView
    }()
    
    //热词
    lazy var hotsView: HomeHeadHotsView = {
        let hotsView = HomeHeadHotsView()
        return hotsView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .init(cssStr: "#F8F8F8")
        return twoView
    }()
    
    lazy var bannerView: TYCyclePagerView = {
        let bannerView = TYCyclePagerView()
        bannerView.delegate = self
        bannerView.dataSource = self
        bannerView.isInfiniteLoop = true
        bannerView.autoScrollInterval = 2.0
        bannerView.register(HomeBannerViewCell.self,
                            forCellWithReuseIdentifier: "HomeBannerViewCell")
        return bannerView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(HomeItemViewCell.self, forCellWithReuseIdentifier: "HomeItemViewCell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var itemBgImageView: UIImageView = {
        let itemBgImageView = UIImageView()
        itemBgImageView.image = UIImage(named: "homeitembgicon")
        return itemBgImageView
    }()
    
    lazy var grayImageView: UIImageView = {
        let grayImageView = UIImageView()
        grayImageView.image = UIImage(named: "homeitemiconcycle")
        return grayImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(iconImageView)
        ctImageView.addSubview(vipImageView)
        ctImageView.addSubview(tabView)
        ctImageView.addSubview(hotsView)
        addSubview(twoView)
        twoView.addSubview(bannerView)
        addSubview(oneView)
        oneView.addSubview(collectionView)
        oneView.addSubview(itemBgImageView)
        itemBgImageView.addSubview(grayImageView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(233)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight)
            make.size.equalTo(CGSize(width: 99, height: 25))
            make.left.equalToSuperview().offset(15.5)
        }
        vipImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.size.equalTo(CGSize(width: 67, height: 25))
        }
        tabView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(vipImageView.snp.bottom).offset(35)
            make.height.equalTo(83.5)
        }
        hotsView.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        twoView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(85)
        }
        bannerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(6)
        }
        oneView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom)
            make.bottom.equalTo(twoView.snp.top)
            make.left.right.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-22)
        }
        itemBgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 4))
            make.top.equalTo(collectionView.snp.bottom).offset(10)
        }
        grayImageView.frame = CGRectMake(0, 0, 12.5, 4)
        
        itemModelArray.compactMap { $0 }.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "HomeItemViewCell", cellType: HomeItemViewCell.self)) { row, model ,cell in
            let picUrl = model.icon ?? ""
            cell.iconImageView.kf.setImage(with: URL(string: picUrl))
            cell.titlelabel.text = model.menuName ?? ""
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(childrenModel.self).subscribe(onNext: { [weak self] model in
            self?.itemBlock?(model)
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeHeadView: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    func numberOfItems(in pagerView: TYCyclePagerView) -> Int {
        return self.bannerModelArray?.count ?? 0
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "HomeBannerViewCell", for: index) as? HomeBannerViewCell else { return UICollectionViewCell() }
        let model = self.bannerModelArray?[index]
        cell.ipoImgaView.kf.setImage(with: URL(string: model?.banner ?? ""))
        return cell
        
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        self.bannerBlock?()
    }
    
    func layout(for pagerView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSizeMake(SCREEN_WIDTH - 20, 71.5)
        layout.itemSpacing = 5
        return layout
    }
    
}

extension HomeHeadView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = SCREEN_WIDTH / 5
        return CGSize(width: itemWidth, height: 62.pix())
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        UIView.animate(withDuration: 0.25) {
            if currentPage == 0 {
                self.grayImageView.mj_x = 0
            }else {
                self.grayImageView.mj_x = 12.5
            }
        }
    }
    
}
