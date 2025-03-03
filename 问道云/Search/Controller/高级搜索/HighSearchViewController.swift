//
//  HighSearchViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/21.
//

import UIKit
import RxRelay
import DropMenuBar

class HighSearchViewController: WDBaseViewController {
    
    //搜索条件
    var searchConditionArray: [String]?
    
    //行业
    var industryType: String?
    //地区
    var region: String?
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "高级搜索"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneView: HighSearchKeyView = {
        let oneView = HighSearchKeyView()
        return oneView
    }()
    
    lazy var twoView: HighTwoView = {
        let twoView = HighTwoView()
        return twoView
    }()
    
    lazy var threeView: HighThreeView = {
        let threeView = HighThreeView()
        return threeView
    }()
    
    lazy var fourView: HighFourView = {
        let fourView = HighFourView()
        return fourView
    }()
    
    lazy var fiveView: HighFiveView = {
        let fiveView = HighFiveView()
        return fiveView
    }()
    
    lazy var sixView: HighSixView = {
        let sixView = HighSixView()
        return sixView
    }()
    
    lazy var agentView: HighAgentView = {
        let agentView = HighAgentView()
        return agentView
    }()
    
    lazy var companyTypeView: HighCompanyTypeView = {
        let companyTypeView = HighCompanyTypeView()
        return companyTypeView
    }()
    
    lazy var peopleView: HighPeopleView = {
        let peopleView = HighPeopleView()
        return peopleView
    }()
    
    lazy var statusView: HighStatusView = {
        let statusView = HighStatusView()
        return statusView
    }()
    
    lazy var blockView: HighBlockView = {
        let blockView = HighBlockView()
        return blockView
    }()
    
    lazy var emailView: HighEmailView = {
        let emailView = HighEmailView()
        return emailView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "支持同时选择多个条件查找公司"
        descLabel.font = .regularFontOfSize(size: 11)
        descLabel.textColor = .init(cssStr: "#9FA4AD")
        descLabel.textAlignment = .center
        return descLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("重置", for: .normal)
        oneBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        oneBtn.setTitleColor(.white, for: .normal)
        oneBtn.backgroundColor = .init(cssStr: "#D0D4DA")
        oneBtn.layer.cornerRadius = 5
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("查看结果", for: .normal)
        twoBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        twoBtn.setTitleColor(.white, for: .normal)
        twoBtn.backgroundColor = .init(cssStr: "#547AFF")
        twoBtn.layer.cornerRadius = 5
        return twoBtn
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .white
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        getHighMessageInfo()
        addListView()
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            //登记状态
            let orgStatusArray = model.ORG_REG_STATUS ?? []
            for (_, model) in orgStatusArray.enumerated() {
                let name = model.name ?? ""
                if name == "未知" {
                    if let titles = model.children {
                        fourView.view0.allButton.setTitle(name, for: .normal)
                        fourView.view0.configureButtons(modelArray: titles)
                    }
                }else if name == "正常" {
                    if let titles = model.children {
                        fourView.view1.allButton.setTitle(name, for: .normal)
                        fourView.view1.configureButtons(modelArray: titles)
                    }
                }else if name == "异常" {
                    if let titles = model.children {
                        fourView.view2.allButton.setTitle(name, for: .normal)
                        fourView.view2.configureButtons(modelArray: titles)
                    }
                }else if name == "其他" {
                    if let titles = model.children {
                        fourView.view3.allButton.setTitle(name, for: .normal)
                        fourView.view3.configureButtons(modelArray: titles)
                    }
                }
            }
            
            //成立年限
            let timeArray = model.INC_DATE_LEVEL ?? []
            var timeTitles: [String] = []
            for (_, model) in timeArray.enumerated() {
                timeTitles.append(model.name ?? "")
            }
            fiveView.tagListView.addTags(timeTitles)
            
            //注册资本
            let moneyArray = model.REG_CAP_LEVEL ?? []
            var moneyTitles: [String] = []
            for (_, model) in moneyArray.enumerated() {
                moneyTitles.append(model.name ?? "")
            }
            sixView.tagListView.addTags(moneyTitles)
            
            //机构类型
            let agentArray = model.ORG_CATEGORY ?? []
            var agentTitles: [String] = []
            for (_, model) in agentArray.enumerated() {
                agentTitles.append(model.name ?? "")
            }
            agentView.tagListView.addTags(agentTitles)
            
            //企业类型
            let companyTypeArray = model.ORG_ECON ?? []
            var companyTypeTitles: [String] = []
            for (_, model) in companyTypeArray.enumerated() {
                companyTypeTitles.append(model.name ?? "")
            }
            companyTypeView.tagListView.addTags(companyTypeTitles)
            
            //参保人数
            let peopleArray = model.SIP_LEVEL ?? []
            var peopleTitles: [String] = []
            for (_, model) in peopleArray.enumerated() {
                peopleTitles.append(model.name ?? "")
            }
            peopleView.tagListView.addTags(peopleTitles)
            
            //上市状态
            let statusArray = model.LIST_STATUS ?? []
            var statusTitles: [String] = []
            for (_, model) in statusArray.enumerated() {
                statusTitles.append(model.name ?? "")
            }
            statusView.tagListView.addTags(statusTitles)
            
            //上市板块
            let blockArray = model.LIST_SECTOR ?? []
            var blockTitles: [String] = []
            for (_, model) in blockArray.enumerated() {
                blockTitles.append(model.name ?? "")
            }
            blockView.tagListView.addTags(blockTitles)
            
            //联系邮箱
            let emailArray = ["有", "无"]
            emailView.tagListView.addTags(emailArray)
        }).disposed(by: disposeBag)
        
        
        
        
    }
    
}

extension HighSearchViewController {
    
    private func getHighMessageInfo() {
        let dict = ["typeVec": ""]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict, pageUrl: "/entity/v2/meta", method: .get) { [weak self] result in
            guard let self = self else { return }
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let model = success.data {
                        self.model.accept(model)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func addListView() {
        view.addSubview(scrollView)
        scrollView.addSubview(oneView)
        scrollView.addSubview(twoView)
        scrollView.addSubview(threeView)
        scrollView.addSubview(fourView)
        scrollView.addSubview(fiveView)
        scrollView.addSubview(sixView)
        scrollView.addSubview(agentView)
        scrollView.addSubview(companyTypeView)
        scrollView.addSubview(peopleView)
        scrollView.addSubview(statusView)
        scrollView.addSubview(blockView)
        scrollView.addSubview(emailView)
        view.addSubview(footerView)
        footerView.addSubview(descLabel)
        footerView.addSubview(oneBtn)
        footerView.addSubview(twoBtn)
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
        }
        oneView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(43)
        }
        twoView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(43)
        }
        threeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(43)
        }
        fourView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(threeView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(203)
        }
        fiveView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(fourView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(120)
        }
        sixView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(fiveView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(155)
        }
        agentView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(sixView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(115)
        }
        companyTypeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(agentView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(80)
        }
        peopleView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(companyTypeView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(120)
        }
        statusView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(peopleView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        blockView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(statusView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
        }
        emailView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(blockView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(45)
            make.bottom.equalToSuperview().offset(-95)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(95)
        }
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(15)
        }
        oneBtn.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(15.pix())
            make.size.equalTo(CGSize(width: 120.pix(), height: 45.pix()))
        }
        twoBtn.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-15.pix())
            make.size.equalTo(CGSize(width: 216.pix(), height: 45.pix()))
        }
        
        //行业
        let industryMenu = MenuAction(title: "", style: .typeList)!
        industryMenu.setImage(UIImage(named: ""), for: .normal)
        industryMenu.setImage(UIImage(named: ""), for: .selected)
        let menuView = DropMenuBar(action: [industryMenu])!
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.top)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(43)
        }
        self.model.asObservable().map { $0?.INDUSTRY ?? [] }.subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeIndustryInfo(from: modelArray)
            industryMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            industryMenu.setTitle("", for: .normal)
            twoView.descLabel.text = model?.displayText ?? ""
            twoView.descLabel.textColor = .init(cssStr: "#333333")
            self.industryType = model?.currentID ?? ""
        }
        
        //地区
        let regionMenu = MenuAction(title: "", style: .typeList)!
        regionMenu.setImage(UIImage(named: ""), for: .normal)
        regionMenu.setImage(UIImage(named: ""), for: .selected)
        let menView = DropMenuBar(action: [regionMenu])!
        view.addSubview(menView)
        menView.snp.makeConstraints { make in
            make.top.equalTo(threeView.snp.top)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(43)
        }
        self.model.asObservable().map { $0?.REGION ?? [] }.subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray)
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            regionMenu.setTitle("", for: .normal)
            threeView.descLabel.text = model?.displayText ?? ""
            threeView.descLabel.textColor = .init(cssStr: "#333333")
            self.region = model?.currentID ?? ""
        }
        
        //重置
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            //关键词
            self.oneView.nameTx.text = ""
            //行业
            self.twoView.descLabel.text = "非必填"
            self.twoView.descLabel.textColor = UIColor.init(cssStr: "#ACACAC")
            //地区
            self.threeView.descLabel.text = "全部"
            self.threeView.descLabel.textColor = UIColor.init(cssStr: "#ACACAC")
            //登记状态
            self.fourView.view0.removeBtnConfig()
            self.fourView.view1.removeBtnConfig()
            self.fourView.view2.removeBtnConfig()
            self.fourView.view3.removeBtnConfig()
            //成立年限
            self.fiveView.clearStateOfSelected()
            self.fiveView.startBtn.setTitle("开始日期", for: .normal)
            self.fiveView.startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            self.fiveView.endBtn.setTitle("结束日期", for: .normal)
            self.fiveView.endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            //注册资本
            self.sixView.clearStateOfSelected()
            self.sixView.startTx.text = ""
            self.sixView.endTx.text = ""
            //机构类型
            self.agentView.clearStateOfSelected()
            //企业类型
            self.companyTypeView.clearStateOfSelected()
            //参保人数
            self.peopleView.clearStateOfSelected()
            self.peopleView.startTx.text = ""
            self.peopleView.endTx.text = ""
            //上市状态
            self.statusView.clearStateOfSelected()
            //上市板块
            self.blockView.clearStateOfSelected()
            //邮箱
            self.emailView.clearStateOfSelected()
        }).disposed(by: disposeBag)
        
        //确认结果
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            //关键词
            let keyword = self.oneView.nameTx.text ?? ""
            
            //精度
            let matchType = self.oneView.matchType ?? ""
            
            //行业
            let industryType = self.industryType ?? ""
            
            //地区
            let region = self.region ?? ""
            
            //登记状态
            var regStatusVec: [String] = []//ID
            var regStatusTitles: [String] = []//名称
            if let oneStatus = self.fourView.view0.dengjiBinder.value {
                regStatusVec.append(contentsOf: oneStatus)
            }
            if let twoStatus = self.fourView.view1.dengjiBinder.value {
                regStatusVec.append(contentsOf: twoStatus)
            }
            if let threeStatus = self.fourView.view2.dengjiBinder.value {
                regStatusVec.append(contentsOf: threeStatus)
            }
            if let fourStatus = self.fourView.view3.dengjiBinder.value {
                regStatusVec.append(contentsOf: fourStatus)
            }
            
            if let oneStatus = self.fourView.view0.dengjiStringBinder.value {
                regStatusTitles.append(contentsOf: oneStatus)
            }
            if let twoStatus = self.fourView.view1.dengjiStringBinder.value {
                regStatusTitles.append(contentsOf: twoStatus)
            }
            if let threeStatus = self.fourView.view2.dengjiStringBinder.value {
                regStatusTitles.append(contentsOf: threeStatus)
            }
            if let fourStatus = self.fourView.view3.dengjiStringBinder.value {
                regStatusTitles.append(contentsOf: fourStatus)
            }
            
            //成立年限
            let startTime = self.fiveView.startBtn.titleLabel?.text ?? ""
            let endTime = self.fiveView.startBtn.titleLabel?.text ?? ""
            var selectArray = self.fiveView.selectArray
            let timeIds = self.model.value?.INC_DATE_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredModels = timeIds.filter { model in
                selectArray.contains(model.name ?? "")
            }
            //成立年限参数
            let incDateTypeVec: [String] = filteredModels.map { $0.code ?? "" }
            let incDateRange = startTime + "-" + endTime
            
            //注册资本
            let startMoney = self.sixView.startTx.text ?? ""
            let endMoney = self.sixView.endTx.text ?? ""
            var selectMoneyArray = self.sixView.selectArray
            let moneyIds = self.model.value?.REG_CAP_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredMoneyModels = moneyIds.filter { model in
                selectMoneyArray.contains(model.name ?? "")
            }
            //成立年限参数
            let regCapLevelVec: [String] = filteredMoneyModels.map { $0.code ?? "" }
            let regCapRange = startMoney + "-" + endMoney
            
            //机构类型
            var selectAgentArray = self.agentView.selectArray
            let agentIds = self.model.value?.ORG_CATEGORY ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredAgentModels = agentIds.filter { model in
                selectAgentArray.contains(model.name ?? "")
            }
            //机构类型参数
            let econTypeVec: [String] = filteredAgentModels.map { $0.code ?? "" }
            
            //企业类型
            var selectCompanyArray = self.companyTypeView.selectArray
            let companyIds = self.model.value?.ORG_ECON ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredCompanyModels = companyIds.filter { model in
                selectCompanyArray.contains(model.name ?? "")
            }
            //机构类型参数
            let categoryVec: [String] = filteredCompanyModels.map { $0.code ?? "" }
            
            //参保人数
            var selectNumArray = self.peopleView.selectArray
            let numIds = self.model.value?.SIP_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredNumModels = numIds.filter { model in
                selectNumArray.contains(model.name ?? "")
            }
            //参保人数参数
            let sipCountLevelVec: [String] = filteredNumModels.map { $0.code ?? "" }
            let startPeople = self.peopleView.startTx.text ?? ""
            let endPeople = self.peopleView.endTx.text ?? ""
            let sipCountRange = startPeople + "-" + endPeople
            
            //上市状态
            var selectStatusArray = self.statusView.selectArray
            let statusIds = self.model.value?.LIST_STATUS ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredStatusModels = statusIds.filter { model in
                selectStatusArray.contains(model.name ?? "")
            }
            //上市状态参数
            let listStatusVec: [String] = filteredStatusModels.map { $0.code ?? "" }
            
            //上市板块
            var selectBlockArray = self.blockView.selectArray
            let blockIds = self.model.value?.LIST_SECTOR ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredBlockModels = blockIds.filter { model in
                selectBlockArray.contains(model.name ?? "")
            }
            //上市状态参数
            let listingSectorVec: [String] = filteredBlockModels.map { $0.code ?? "" }
            
            //邮箱
            
            
            
            let resultVc = HighSearchResultViewController()
            resultVc.searchConditionArray = []
            self.navigationController?.pushViewController(resultVc, animated: true)
        }).disposed(by: disposeBag)
        
    }
}

extension HighSearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
            return
        }
    }
    
}
