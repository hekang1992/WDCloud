//
//  MembershipCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  会员中心页面

import UIKit
import RxRelay
import JXSegmentedView

class MembershipCenterViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var currentIndex: Int = 0
    
    var payBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "会员中心"
        headView.lineView.isHidden = true
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "wodediingdan"), for: .normal)
        return headView
    }()
    
    lazy var memView: MembershipCenterView = {
        let memView = MembershipCenterView()
        return memView
    }()
    
    var vipTypeModel = BehaviorRelay<DataModel?>(value: nil)
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [MembershipListViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(memView)
        memView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vipTypeModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            memView.vipTypeModel.accept(model)
        }).disposed(by: disposeBag)
        
        addHeadView(from: headView)
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let orderListVc = UserAllOrderSController()
            self?.navigationController?.pushViewController(orderListVc, animated: true)
        }).disposed(by: disposeBag)
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
        //获取套餐信息
        getPriceInfo()
    }
    
}

extension MembershipCenterViewController: JXSegmentedViewDelegate {
    
    //代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.currentIndex = index
        let targetVc = listVCArray[index]
        model.asObservable().subscribe(onNext: { model in
            guard let model = model, let rows = model.rows, !rows.isEmpty else { return  }
            targetVc.getPriceModelInfo(from: index, model: model)
        }).disposed(by: disposeBag)
        if index == 0 {
            UIView.transition(with: self.memView.ctImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.memView.ctImageView.image = UIImage(named: "huibgimage")
            }, completion: nil)
            self.memView.bgImageView.image = UIImage(named: "vipjuxingimage")
            self.memView.desclabel.textColor = UIColor.init(cssStr: "#999999")
            self.headView.titlelabel.textColor = .init(cssStr: "#333333")
            self.headView.backBtn.setImage(UIImage(named: "backimage"), for: .normal)
            self.headView.oneBtn.setImage(UIImage(named: "wodediingdan"), for: .normal)
        }else if index == 1 {
            UIView.transition(with: self.memView.ctImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.memView.ctImageView.image = UIImage(named: "svipimagebg")
            }, completion: nil)
            self.memView.bgImageView.image = UIImage(named: "ssvihuipimage")
            self.memView.desclabel.textColor = UIColor.init(cssStr: "#999999")
            self.headView.titlelabel.textColor = .init(cssStr: "#333333")
            self.headView.backBtn.setImage(UIImage(named: "backimage"), for: .normal)
            self.headView.oneBtn.setImage(UIImage(named: "wodediingdan"), for: .normal)
        }else {
            UIView.transition(with: self.memView.ctImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.memView.ctImageView.image = UIImage(named: "blackimagevip")
            }, completion: nil)
            self.memView.bgImageView.image = UIImage(named: "jinseimagevip")
            self.memView.desclabel.textColor = UIColor.init(cssStr: "#3F1C00")
            self.headView.titlelabel.textColor = .white
            self.headView.backBtn.setImage(UIImage(named: "whitebackimge"), for: .normal)
            self.headView.oneBtn.setImage(UIImage(named: "whiteorderimge"), for: .normal)
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["VIP会员", "SVIP会员", "团队套餐"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 15)
        segmurce.titleNormalFont = .regularFontOfSize(size: 15)
        segmurce.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedView.dataSource = segmurce
        let indicator = createSegmentedIndicator()
        segmentedView.indicators = [indicator]
        segmentedView.contentScrollView = cocsciew
        return segmentedView
    }
    
    private func createCocsciew() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: 0)
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 22
        indicator.indicatorHeight = 4
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        return indicator
    }
    
    func addsentMentView() {
        view.addSubview(segmentedView)
        view.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(memView.ctImageView.snp.bottom)
            make.height.equalTo(44)
        }
        cocsciew.frame = CGRectMake(0, StatusHeightManager.navigationBarHeight + 76 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44 - 76)
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        for _ in 0..<3 {
            let vc = MembershipListViewController()
            vc.ordertype = 1
            cocsciew.addSubview(vc.view)
            listVCArray.append(vc)
            vc.agreeView.descLabel.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.pushWebPage(from: base_url + membership_agreement)
            }).disposed(by: disposeBag)
            
            vc.payBlock = { [weak self] in
                self?.getBuymoreinfo()
                ShowAlertManager.showAlert(title: "支付结果", message: "您已经支付成功,感谢您的支持!")
            }
        }
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44 - 76)
        }
    }
    
}

extension MembershipCenterViewController {
    
    //获取套餐信息
    func getPriceInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let emptyDict = [String: Any]()
        man.requestAPI(params: emptyDict,
                       pageUrl: "/operation/combo/selectmember",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.model.accept(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getBuymoreinfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm/buymoreinfo",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.vipTypeModel.accept(model)
                }
                break
            case .failure(_):
                
                break
            }
        }
    }
    
}
