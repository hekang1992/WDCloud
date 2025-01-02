//
//  DonateMembershipViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/31.
//  赠送会员页面

import UIKit
import RxRelay
import ContactsUI
import JXSegmentedView

class DonateMembershipViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.bgView.backgroundColor = .clear
        return headView
    }()
    
    lazy var donateView: DonateMembershipView = {
        let donateView = DonateMembershipView()
        return donateView
    }()
    
    var vipTypeModel = BehaviorRelay<DataModel?>(value: nil)
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [MembershipListViewController]()
    
    lazy var contactPicker: CNContactPickerViewController = {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        return contactPicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(donateView)
        donateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        donateView.vipTypeModel.accept(vipTypeModel.value)
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
        
        //发送短信是否
        donateView.sendBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            donateView.sendBtn.isSelected.toggle()
            listVCArray[0].pushmsflag = donateView.sendBtn.isSelected ? 1 : 0
            listVCArray[1].pushmsflag = donateView.sendBtn.isSelected ? 1 : 0
            listVCArray[2].pushmsflag = donateView.sendBtn.isSelected ? 1 : 0
        }).disposed(by: disposeBag)
        
        //获取联系人
        donateView.contactBtn.rx.tap.subscribe(onNext: { [weak self] in
            let manager = ContactManager()
            manager.requestAccess { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    self.present(contactPicker, animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
        
        donateView.phoneTx
            .rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] phone in
                self?.listVCArray[0].friendphone = phone
                self?.listVCArray[1].friendphone = phone
                self?.listVCArray[2].friendphone = phone
            }).disposed(by: disposeBag)
        
    }
    
}

extension DonateMembershipViewController: JXSegmentedViewDelegate {
    
    //代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        let targetVc = listVCArray[index]
        model.asObservable().subscribe(onNext: { model in
            guard let model = model, let rows = model.rows, !rows.isEmpty else { return  }
            targetVc.getPriceModelInfo(from: index, model: model)
        }).disposed(by: disposeBag)
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
            make.top.equalTo(donateView.ctImageView.snp.bottom).offset(60)
            make.height.equalTo(44)
        }
        cocsciew.frame = CGRectMake(0, StatusHeightManager.navigationBarHeight + 240, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 240)
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        for _ in 0..<3 {
            let vc = MembershipListViewController()
            vc.ordertype = 2
            cocsciew.addSubview(vc.view)
            listVCArray.append(vc)
            vc.agreeView.descLabel.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.pushWebPage(from: membership_agreement)
                }).disposed(by: disposeBag)
        }
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 240)
        }
    }
    
}


extension DonateMembershipViewController {
    
    //获取套餐信息
    func getPriceInfo() {
        let man = RequestManager()
        let emptyDict = [String: Any]()
        man.requestAPI(params: emptyDict, pageUrl: getCombo_selectmember, method: .get) { [weak self] result in
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
    
}

extension DonateMembershipViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
            self.donateView.phoneTx.text = phoneNumber
        } else {
            print("error")
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
    
}
