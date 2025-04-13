//
//  MyTicketViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/17.
//  我的开票

import UIKit
import RxRelay
import JXSegmentedView
import TYAlertController

class DescTicketView: UIView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "kaipiaomiaoshu")
        return bgImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 311.pix(), height: 450.pix()))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyTicketViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.oneBtn.setImage(UIImage(named: "kaipiaoshuoming"), for: .normal)
        headView.titlelabel.text = "发票列表"
        return headView
    }()
    
    lazy var ticketView: MyTicketView = {
        let ticketView = MyTicketView()
        ticketView.backgroundColor = .white
        return ticketView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(ticketView)
        ticketView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let ticketView = DescTicketView(frame: self.view.bounds)
            let alertVc = TYAlertController(alert: ticketView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            ticketView.bgImageView.rx.tapGesture().when(.recognized).subscribe(onNext: {_ in 
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
}

extension MyTicketViewController: JXSegmentedViewDelegate {
    
    //代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            let oneVc = self.listVCArray[0] as! OneTicketViewController
            oneVc.getListInfo()
            oneVc.pageNum = 1
        }else {
            let twoVc = self.listVCArray[1] as! TwoTicketViewController
            twoVc.getListInfo()
            twoVc.pageNum = 1
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["发票申请", "发票记录"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 15)
        segmurce.titleNormalFont = .regularFontOfSize(size: 15)
        segmurce.titleNormalColor = UIColor.init(cssStr: "#666666")!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#547AFF")!
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
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: 0)
        return scrollView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 15
        indicator.indicatorHeight = 4
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        return indicator
    }
    
    func addsentMentView() {
        ticketView.addSubview(segmentedView)
        ticketView.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(40)
        }
        cocsciew.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 40)
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        let oneVc = OneTicketViewController()
        oneVc.model.accept(model.value)
        cocsciew.addSubview(oneVc.view)
        listVCArray.append(oneVc)
        
        let twoVc = TwoTicketViewController()
        twoVc.model.accept(model.value)
        cocsciew.addSubview(twoVc.view)
        listVCArray.append(twoVc)
        
        //push到发票抬头页面
        oneVc.toOpenTicketBlock = { [weak self] model in
            let listVc = InvoiceListViewController()
            listVc.rowModel.accept(model)
            listVc.model.accept(self?.model.value)
            self?.navigationController?.pushViewController(listVc, animated: true)
        }
        
        twoVc.linkBlock = { [weak self] model in
            self?.pushWebPage(from: model.localpdflink ?? "")
        }
        
        updateViewControllersLayout()
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44)
        }
    }
    
}
