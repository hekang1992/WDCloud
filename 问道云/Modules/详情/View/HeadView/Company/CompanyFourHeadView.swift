//
//  CompanyFourHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//  风险追踪

import UIKit
import RxRelay

class CompanyFourHeadView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "detailriskicon")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneRiskView: DetailRiskItemView = {
        let oneRiskView = DetailRiskItemView()
        oneRiskView.isUserInteractionEnabled = true
        return oneRiskView
    }()
    
    lazy var twoRiskView: DetailRiskItemView = {
        let twoRiskView = DetailRiskItemView()
        twoRiskView.isUserInteractionEnabled = true
        return twoRiskView
    }()
    
    lazy var threeRiskView: DetailRiskItemView = {
        let threeRiskView = DetailRiskItemView()
        threeRiskView.isUserInteractionEnabled = true
        return threeRiskView
    }()
    
    lazy var fourRiskView: DetailRiskItemView = {
        let fourRiskView = DetailRiskItemView()
        fourRiskView.isUserInteractionEnabled = true
        return fourRiskView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(lineView)
        addSubview(scrollView)
        scrollView.addSubview(oneRiskView)
        scrollView.addSubview(twoRiskView)
        scrollView.addSubview(threeRiskView)
        scrollView.addSubview(fourRiskView)
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 17, height: 60))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(6)
            make.height.equalTo(4)
        }
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-4)
            make.height.equalTo(60)
        }
        oneRiskView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(105)
        }
        twoRiskView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.left.equalTo(oneRiskView.snp.right).offset(6)
            make.width.equalTo(105)
        }
        threeRiskView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.left.equalTo(twoRiskView.snp.right).offset(6)
            make.width.equalTo(105)
        }
        fourRiskView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.left.equalTo(threeRiskView.snp.right).offset(6)
            make.width.equalTo(105)
            make.right.equalToSuperview().offset(-5)
        }
        
        oneRiskView.block = { [weak self] in
            guard let self = self else { return }
            self.goRiskDetailInfo()
        }
        
        twoRiskView.block = { [weak self] in
            guard let self = self else { return }
            self.goRiskDetailInfo()
        }
        
        threeRiskView.block = { [weak self] in
            guard let self = self else { return }
            self.goRiskDetailInfo()
        }
        
        fourRiskView.block = { [weak self] in
            guard let self = self else { return }
            self.goRiskDetailInfo()
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyFourHeadView {
    
    private func goRiskDetailInfo() {
        let model = self.model.value
        let riskDetailVc = CompanyRiskDetailViewController()
        let vc = ViewControllerUtils.findViewController(from: self)
        riskDetailVc.enityId = model?.basicInfo?.orgId ?? ""
        riskDetailVc.name = model?.basicInfo?.orgName ?? ""
        vc?.navigationController?.pushViewController(riskDetailVc, animated: true)
    }
    
}
