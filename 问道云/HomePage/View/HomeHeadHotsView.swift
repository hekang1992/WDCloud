//
//  HomeHeadHotsView.swift
//  问道云
//
//  Created by 何康 on 2025/1/5.
//  首页热词

import UIKit
import RxRelay

class HomeHeadHotsView: BaseView {
    
    var hotWordsBlock: ((rowsModel) -> Void)?
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "hotwordsimage")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.layer.cornerRadius = 0.5
        return lineView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        return oneView
    }()
    
    //刷新按钮
    lazy var refreshImageView: UIImageView = {
        let refreshImageView = UIImageView()
        refreshImageView.isUserInteractionEnabled = true
        refreshImageView.image = UIImage(named: "refreshbtnimagehome")
        refreshImageView.contentMode = .scaleAspectFit
        return refreshImageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(HomeHotWordsCell.self, forCellWithReuseIdentifier: "HomeHotWordsCell")
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(lineView)
        addSubview(oneView)
        addSubview(refreshImageView)
        oneView.addSubview(collectionView)
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 12))
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.top.equalTo(ctImageView.snp.top).offset(0.5)
            make.width.equalTo(1)
        }
        refreshImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        oneView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalTo(ctImageView.snp.top)
            make.left.equalTo(lineView.snp.right).offset(10)
            make.right.equalTo(refreshImageView.snp.left).offset(-3.5)
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        refreshImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.5, animations: {
                    self.refreshImageView.transform = self.refreshImageView.transform.rotated(by: .pi)
                })
            }).disposed(by: disposeBag)
        
        modelArray.compactMap { $0 }.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "HomeHotWordsCell", cellType: HomeHotWordsCell.self)) { row, model ,cell in
            cell.namelabel.text = model.firmname ?? ""
        }.disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(rowsModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.hotWordsBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeHeadHotsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = modelArray.value?[indexPath.row]
        let text = model?.firmname ?? ""
        let width = text.size(withAttributes: [.font: UIFont.regularFontOfSize(size: 11)]).width
        return CGSize(width: width + 10, height: 12)
    }
    
}
