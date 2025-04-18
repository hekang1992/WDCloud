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
    var industryType: String = ""
    //地区
    var region: String = ""
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "高级搜索"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
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
                if name == "正常" {
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
        ViewHud.addLoadView()
        let dict = ["typeVec": ""]
        let man = RequestManager()
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
            make.height.equalTo(163)
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
            self.region = model?.currentID ?? ""
            threeView.descLabel.text = model?.displayText ?? ""
            threeView.descLabel.textColor = .init(cssStr: "#333333")
        }
        
        //重置
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.oneView.selectFuzzy()
            //关键词
            self.oneView.nameTx.text = ""
            //行业
            self.twoView.descLabel.text = "非必填"
            self.twoView.descLabel.textColor = UIColor.init(cssStr: "#ACACAC")
            //地区
            self.threeView.descLabel.text = "全部"
            self.threeView.descLabel.textColor = UIColor.init(cssStr: "#ACACAC")
            //登记状态
//            self.fourView.view0.removeBtnConfig()
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
            var nameStr = self.oneView.nameTx.text ?? ""
            if nameStr.contains("非必填") {
                nameStr = ""
            }
            let keyword = nameStr
            
            //精度
            let matchType = Int(self.oneView.matchType ?? "1")
            
            //行业
            let industryType = self.industryType
            
            //地区
            let region = self.region
            
            //登记状态
            var regStatusVec: [Int] = []//ID
            var regStatusTitles: [String] = []//名称
//            if let oneStatus = self.fourView.view0.dengjiBinder.value {
//                regStatusVec.append(contentsOf: oneStatus.map { Int($0) ?? 0 })
//            }
            if let twoStatus = self.fourView.view1.dengjiBinder.value {
                regStatusVec.append(contentsOf: twoStatus.map { Int($0) ?? 0 })
            }
            if let threeStatus = self.fourView.view2.dengjiBinder.value {
                regStatusVec.append(contentsOf: threeStatus.map { Int($0) ?? 0 })
            }
            if let fourStatus = self.fourView.view3.dengjiBinder.value {
                regStatusVec.append(contentsOf: fourStatus.map { Int($0) ?? 0 })
            }
            
//            if let oneStatus = self.fourView.view0.dengjiStringBinder.value {
//                regStatusTitles.append(contentsOf: oneStatus)
//            }
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
            let endTime = self.fiveView.endBtn.titleLabel?.text ?? ""
            let selectArray = self.fiveView.selectArray
            let timeIds = self.model.value?.INC_DATE_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredModels = timeIds.filter { model in
                selectArray.contains(model.name ?? "")
            }
            //成立年限参数
            let incDateTypeVec: [Int] = filteredModels.map { Int($0.code ?? "0") ?? 0 }
            var incDateRange = startTime + "|" + endTime
            if startTime > endTime {
                ToastViewConfig.showToast(message: "开始日期大于结束日期,请重新选择")
                return
            }
            if incDateRange.contains("日期") {
                incDateRange = ""
            }
            
            //注册资本
            let startMoney = self.sixView.startTx.text ?? ""
            let endMoney = self.sixView.endTx.text ?? ""
            let selectMoneyArray = self.sixView.selectArray
            let moneyIds = self.model.value?.REG_CAP_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredMoneyModels = moneyIds.filter { model in
                selectMoneyArray.contains(model.name ?? "")
            }
            //注册资本参数
            let regCapLevelVec: [Int] = filteredMoneyModels.map { Int($0.code ?? "0") ?? 0 }
            
            var regCapRange = startMoney + "-" + endMoney
            if (Float(startMoney) ?? 0) > (Float(endMoney) ?? 0) {
                ToastViewConfig.showToast(message: "最低资本大于最高资本,请重新填写")
                return
            }
            if regCapRange == "-" {
                regCapRange = ""
            }
            
            //机构类型
            let selectAgentArray = self.agentView.selectArray
            let agentIds = self.model.value?.ORG_CATEGORY ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredAgentModels = agentIds.filter { model in
                selectAgentArray.contains(model.name ?? "")
            }
            //机构类型参数
            let econTypeVec: [Int] = filteredAgentModels.map { Int($0.code ?? "0") ?? 0 }
            
            //企业类型
            let selectCompanyArray = self.companyTypeView.selectArray
            let companyIds = self.model.value?.ORG_ECON ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredCompanyModels = companyIds.filter { model in
                selectCompanyArray.contains(model.name ?? "")
            }
            //企业类型参数
            let categoryVec: [Int] = filteredCompanyModels.map { Int($0.code ?? "0") ?? 0 }
            
            //参保人数
            let selectNumArray = self.peopleView.selectArray
            let numIds = self.model.value?.SIP_LEVEL ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredNumModels = numIds.filter { model in
                selectNumArray.contains(model.name ?? "")
            }
            //参保人数参数
            let sipCountLevelVec: [Int] = filteredNumModels.map { Int($0.code ?? "0") ?? 0 }
            let startPeople = self.peopleView.startTx.text ?? ""
            let endPeople = self.peopleView.endTx.text ?? ""
            var sipCountRange = startPeople + "-" + endPeople
            if (Float(startPeople) ?? 0) > (Float(endPeople) ?? 0) {
                ToastViewConfig.showToast(message: "最低人数大于最高人数,请重新选择")
                return
            }
            if sipCountRange == "-" {
                sipCountRange = ""
            }
            
            //上市状态
            let selectStatusArray = self.statusView.selectArray
            let statusIds = self.model.value?.LIST_STATUS ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredStatusModels = statusIds.filter { model in
                selectStatusArray.contains(model.name ?? "")
            }
            //上市状态参数
            let listStatusVec: [Int] = filteredStatusModels.map { Int($0.code ?? "0") ?? 0 }
            
            //上市板块
            let selectBlockArray = self.blockView.selectArray
            let blockIds = self.model.value?.LIST_SECTOR ?? []
            // 过滤出与字符串数组匹配的模型
            let filteredBlockModels = blockIds.filter { model in
                selectBlockArray.contains(model.name ?? "")
            }
            //上市板块参数
            let listingSectorVec: [Int] = filteredBlockModels.map { Int($0.code ?? "0") ?? 0 }
            
            //邮箱
            var hasEmail: Bool
            let selectEmailStr = self.emailView.selectArray.first ?? ""
            hasEmail = selectEmailStr == "有" ? true : false
            //所有参数
            var searchConditionArray: [String] = []
            searchConditionArray.append(keyword)//名字
            let indStr = (self.twoView.descLabel.text ?? "") == "非必填" ? "" : (self.twoView.descLabel.text ?? "")
            let reginStr = self.threeView.descLabel.text ?? ""
            searchConditionArray.append(indStr)
            searchConditionArray.append(reginStr)
            searchConditionArray.append(contentsOf: regStatusTitles)//登记状态
            searchConditionArray.append(contentsOf: selectArray)//成立时间
            searchConditionArray.append(incDateRange)//自定义时间
            searchConditionArray.append(contentsOf: selectMoneyArray)//注册资本
            searchConditionArray.append(regCapRange)//自定义资本
            searchConditionArray.append(contentsOf: selectAgentArray)//机构类型
            searchConditionArray.append(contentsOf: selectCompanyArray)//企业类型
            searchConditionArray.append(contentsOf: selectNumArray)//参保人数
            searchConditionArray.append(sipCountRange)//自定义参保人数
            searchConditionArray.append(contentsOf: selectStatusArray)//上市状态
            searchConditionArray.append(contentsOf: selectBlockArray)//上市板块
            searchConditionArray.append(selectEmailStr)//邮箱
            
            let searchArray = searchConditionArray
                .filter { !$0.isEmpty && $0 != "开始日期-结束日期" && $0 != "-" }
            if searchArray.isEmpty {
                ToastViewConfig.showToast(message: "请至少选择一个筛选条件")
                return
            }
            let resultVc = HighSearchResultViewController()
            resultVc.searchConditionArray = searchArray
            //关键词
            if !keyword.isEmpty {
                resultVc.keyword = ["keyword": keyword]
            }else {
                resultVc.keyword = ["keyword": ""]
            }
            
            //精度
            resultVc.matchType = ["matchType": matchType as Any]
            //行业
            if !industryType.isEmpty {
                resultVc.industryType = ["INDUSTRY": industryType]
            }
            
            //地区
            if region != "" {
                resultVc.region = ["REGION": Int(region) as Any]
            }
            
            //登记状态
            if regStatusVec.count > 0 {
                resultVc.regStatusVec = ["ORG_REG_STATUS": regStatusVec]
            }
            
            //成立年限
            if incDateTypeVec.count > 0 {
                resultVc.incDateTypeVec = ["INC_DATE_LEVEL": incDateTypeVec]
            }
            
            //自定义年限
            if !incDateRange.isEmpty {
                resultVc.incDateRange = ["incDateRange": incDateRange]
            }
            
            //注册资本
            if regCapLevelVec.count > 0 {
                resultVc.regCapLevelVec = ["REG_CAP_LEVEL": regCapLevelVec]
            }
            
            //自定义资本
            if !regCapRange.isEmpty {
                resultVc.regCapRange = ["regCapRange": regCapRange]
            }
            
            //机构类型
            if econTypeVec.count > 0 {
                resultVc.econTypeVec = ["ORG_CATEGORY": econTypeVec]
            }
            
            //企业类型
            if categoryVec.count > 0 {
                resultVc.categoryVec = ["ORG_ECON": categoryVec]
            }
            
            //参保人数
            if sipCountLevelVec.count > 0 {
                resultVc.sipCountLevelVec = ["SIP_LEVEL": sipCountLevelVec]
            }
            
            //自定义参保人数
            if !sipCountRange.isEmpty {
                resultVc.sipCountRange = ["sipCountRange": sipCountRange]
            }
            
            //上市状态
            if listStatusVec.count > 0 {
                resultVc.listStatusVec = ["LIST_STATUS": listStatusVec]
            }
            
            //上市板块
            if listingSectorVec.count > 0 {
                resultVc.listingSectorVec = ["LIST_SECTOR": listingSectorVec]
            }
            
            //是否有邮箱
            if !selectEmailStr.isEmpty {
                resultVc.hasEmail = ["hasEmail": hasEmail]
            }
            
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
