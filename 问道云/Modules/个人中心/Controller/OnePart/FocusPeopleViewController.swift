//
//  FocusCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/21.
//

import UIKit
import DropMenuBar
import RxRelay
import TYAlertController

class FocusPeopleViewController: WDBaseViewController {
    
    weak var navController: UINavigationController?
    
    var groupModel = BehaviorRelay<DataModel?>(value: nil)
    var regionModel = BehaviorRelay<DataModel?>(value: nil)
    var industryModel = BehaviorRelay<DataModel?>(value: nil)
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    var startTime: String = ""//开始时间
    var endTime: String = ""//结束时间
    //请求参数
    var groupNumber: String = ""
    var followTargetType: String = "2"
    var followTargetName: String = "1"
    var isChoiceDate: String = ""
    var firstAreaCode: String = ""
    var secondAreaCode: String = ""
    var firstIndustryCode: String = ""
    var secondIndustryCode: String = ""
    
    lazy var companyView: FocusCompanyView = {
        let companyView = FocusCompanyView()
        return companyView
    }()
    
    lazy var cmmView: CMMView = {
        let cmmView = CMMView(frame: self.view.bounds)
        return cmmView
    }()
    
    weak var nav: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let groupMenu = MenuAction(title: "全部分组", style: .typeList)!
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        let timeMenu = MenuAction(title: "时间", style: .typeCustom)!
        let menuView = DropMenuBar(action: [groupMenu, regionMenu, industryMenu, timeMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        self.groupModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let modelArray = getGroupMenuInfo(from: modelArray)
            groupMenu.listDataSource = modelArray
        }).disposed(by: disposeBag)
        //分组点击
        groupMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.groupNumber = model?.currentID ?? ""
            self?.getFocusPeopleList()
        }
        
        self.regionModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getRegionInfo(from: modelArray)
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        //地区点击
        regionMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            if granted {
                self?.firstAreaCode = model?.currentID ?? ""
                self?.secondAreaCode = ""
            }else {
                self?.firstAreaCode = ""
                self?.secondAreaCode = model?.currentID ?? ""
            }
            self?.getFocusPeopleList()
        }
        
        self.industryModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            industryMenu.listDataSource = getIndustryInfo(from: modelArray)
        }).disposed(by: disposeBag)
        //行业点击
        industryMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            if granted {
                self?.firstIndustryCode = model?.currentID ?? ""
                self?.secondIndustryCode = ""
            }else {
                self?.firstIndustryCode = ""
                self?.secondIndustryCode = model?.currentID ?? ""
            }
            self?.getFocusPeopleList()
        }
        
        var modelArray = getListTime(from: true)
        timeMenu.displayCustomWithMenu = { [weak self] in
            let timeView = TimeDownView()
            if ((self?.startDateRelay.value?.isEmpty) != nil) && ((self?.endDateRelay.value?.isEmpty) != nil) {
                timeView.startDateRelay.accept(self?.startDateRelay.value)
                timeView.endDateRelay.accept(self?.endDateRelay.value)
            }
            timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 315)
            //点击全部,今天,近一周等
            timeView.block = { model in
                self?.isChoiceDate = model.currentID ?? ""
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
                self?.getFocusPeopleList()
                if model.displayText != "全部" {
                    timeMenu.adjustTitle(model.displayText ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    timeMenu.adjustTitle("时间", textColor: UIColor.init(cssStr: "#666666"))
                }
            }
            //点击开始时间
            timeView.startTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.startTime = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.startTime.isEmpty) != nil) && ((self?.endTime.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击结束时间
            timeView.endTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.endTime = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.startTime.isEmpty) != nil) && ((self?.endTime.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击确认
            timeView.sureTimeBlock = { [weak self] btn in
                let startTime = self?.startTime ?? ""
                let endTime = self?.endTime ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let startDate = dateFormatter.date(from: startTime),
                   let endDate = dateFormatter.date(from: endTime) {
                    if startDate > endDate {
                        ToastViewConfig.showToast(message: "时间格式不正确")
                        return
                    }
                } else {
                    ToastViewConfig.showToast(message: "时间格式不正确")
                    return
                }
                self?.startDateRelay.accept(self?.startTime)
                self?.endDateRelay.accept(self?.endTime)
                self?.isChoiceDate = startTime + "|" + endTime
                timeMenu.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
                self?.getFocusPeopleList()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        
        view.addSubview(companyView)
        companyView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(menuView.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview()
        }
    
        companyView.addBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.addNewGroup()
        }).disposed(by: disposeBag)
        
        companyView.footerView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let selectedDataids = companyView.selectedDataIds
            if selectedDataids.count > 0 {
                ShowAlertManager.showAlert(title: "提示", message: "确认要取消关注吗? 取消后你仍可以随时再次关注.", confirmAction: {
                    self.cancelFocusInfo(from: selectedDataids)
                })
            }else {
                ToastViewConfig.showToast(message: "请先选择需要取消关注的对象")
            }
        }).disposed(by: disposeBag)
        
        companyView.footerView.movebtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let selectedDataids = companyView.selectedDataIds
            if selectedDataids.count > 0 {
                self.movePopFocus(from: selectedDataids)
            }else {
                ToastViewConfig.showToast(message: "请先选择需要移动的对象")
            }
        }).disposed(by: disposeBag)
        
        companyView.modelBlock = { [weak self] model in
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.personId.accept(model.personnumber ?? "")
            peopleDetailVc.peopleName.accept(model.followtargetname ?? "")
            self?.nav?.pushViewController(peopleDetailVc, animated: true)
        }
        
        companyView.modelMoveBlock = { [weak self] model in
            let selectedDataids = [model.dataid ?? ""]
            self?.movePopFocus(from: selectedDataids)
        }
        
        companyView.modelDeleteBlock = { [weak self] model in
            let selectedDataids = [model.dataid ?? ""]
            self?.cancelFocusInfo(from: selectedDataids)
        }
        
    }
    
    //获取所有人员信息
    func getPeopleAllInfo() {
        getAllGroup()
        getRegion()
        getIndustry()
        getFocusPeopleList()
    }
    
}

extension FocusPeopleViewController {
    
    //获取所有分组
    func getAllGroup() {
        let man = RequestManager()
        let dict = ["followTargetType": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/followGroup/list",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.groupModel.accept(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取地区
    func getRegion() {
        let man = RequestManager()
        man.requestAPI(params: [String: String](),
                       pageUrl: "/operation/follow/areaTree/2",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.regionModel.accept(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取行业
    func getIndustry() {
        let man = RequestManager()
        man.requestAPI(params: [String: String](),
                       pageUrl: "/operation/follow/industryTree/2",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.industryModel.accept(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取分组人员信息
    func getFocusPeopleList() {
        ViewHud.addLoadView()
        self.companyView.selectedIndexPaths.removeAll()
        self.companyView.isDeleteMode.accept(false)
        let dict = ["groupNumber": groupNumber,
                    "followTargetType": followTargetType,
                    "isChoiceDate": isChoiceDate,
                    "firstAreaCode": firstAreaCode,
                    "secondAreaCode": secondAreaCode,
                    "firstIndustryCode": firstIndustryCode,
                    "secondIndustryCode": secondIndustryCode] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/list",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.companyView.numLabel.text = String(model.total ?? 0)
                    self.companyView.dataModel.accept(model)
                    self.companyView.tableView.reloadData()
                    self.emptyView.removeFromSuperview()
                }
                break
            case .failure(_):
                break
            }
        }
        
    }
    
}

extension FocusPeopleViewController: UITableViewDelegate {
    
    func addNewGroup() {
        let alertVc = TYAlertController(alert: self.cmmView, preferredStyle: .actionSheet)!
        self.cmmView.nameLabel.text = "添加分组"
        self.cmmView.tf.placeholder = "请输入分组名称"
        self.present(alertVc, animated: true)
        self.cmmView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.cmmView.sblock = { [weak self] in
            self?.addNewInfo()
        }
    }
    
    private func addNewInfo() {
        let man = RequestManager()
        let dict = ["groupName": self.cmmView.tf.text ?? "".removingEmojis,
                    "followTargetType": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/followGroup",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.dismiss(animated: true, completion: {
                        self?.getFocusPeopleList()
                    })
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    func cancelFocusInfo(from dataIds: [String]) {
        let man = RequestManager()
        let dict = ["ids": dataIds,
                    "followTargetType": "2"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/batchCancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self.getFocusPeopleList()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //弹窗
    func movePopFocus(from ids: [String]) {
        let groupView = FocusCompanyPopGroupView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 350))
        if let model = self.groupModel.value {
            groupView.model.accept(model.data ?? [])
        }
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .alert)!
        self.present(alertVc, animated: true)
        groupView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        groupView.sblock = { [weak self] model in
            self?.moveFocusInfo(from: model, ids: ids)
        }
    }
    
    //接口调用
    func moveFocusInfo(from model: rowsModel, ids: [String]) {
        let man = RequestManager()
        let dict = ["groupNumber": model.groupnumber ?? "",
                    "ids": ids,
                    "followTargetType": "2"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/moveGroup",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.dismiss(animated: true, completion: {
                        self?.getFocusPeopleList()
                    })
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
