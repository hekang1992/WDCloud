//
//  FocusPeopleViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/23.
//

import UIKit
import DropMenuBar
import RxRelay

class FocusPeopleViewController: WDBaseViewController {
    
    var groupModel = BehaviorRelay<DataModel?>(value: nil)
    var regionModel = BehaviorRelay<DataModel?>(value: nil)
    var industryModel = BehaviorRelay<DataModel?>(value: nil)
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    var startTime: String = ""//开始时间
    var endTime: String = ""//结束时间
    
    var isChoiceDate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let groupMenu = MenuAction(title: "全部分组", style: .typeList)!
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        let timeMenu = MenuAction(title: "时间", style: .typeCustom)!
        let menuScreeningView = DropMenuBar(action: [groupMenu, regionMenu, industryMenu, timeMenu])!
        menuScreeningView.backgroundColor = .white
        view.addSubview(menuScreeningView)
        menuScreeningView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        self.groupModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            groupMenu.listDataSource = getGroupMenuInfo(from: modelArray)
        }).disposed(by: disposeBag)
        
        groupMenu.didSelectedMenuResult = { [weak self] index, model in
            print("index===model===\(index)===\(model?.currentID ?? "")")
        }
        
        self.regionModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            regionMenu.listDataSource = getRegionInfo(from: modelArray)
        }).disposed(by: disposeBag)
        
        self.industryModel.asObservable().compactMap { $0?.data }.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            industryMenu.listDataSource = getIndustryInfo(from: modelArray)
        }).disposed(by: disposeBag)
        
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
//                self?.pageNum = 1
//                self?.isChoiceDate = model.currentID ?? ""
//                self?.getPdfInfo()
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
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
//                self?.pageNum = 1
                let startTime = self?.startTime ?? ""
                let endTime = self?.endTime ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let startDate = dateFormatter.date(from: startTime),
                   let endDate = dateFormatter.date(from: endTime) {
                    if startDate > endDate {
                        ToastViewConfig.showToast(message: "时间格式不正确!")
                        return
                    }
                } else {
                    ToastViewConfig.showToast(message: "时间格式不正确!")
                    return
                }
                self?.startDateRelay.accept(self?.startTime)
                self?.endDateRelay.accept(self?.endTime)
                self?.isChoiceDate = startTime + "|" + endTime
                timeMenu.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
//                self?.getPdfInfo()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        
    }
    
}


extension FocusPeopleViewController {
    
    //获取所有分组
    func getAllGroup() {
        let man = RequestManager()
        let dict = ["followTargetType": "1"]
        man.requestAPI(params: dict, pageUrl: "/operation/followGroup/list", method: .get) { result in
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
        let dict = [String: Any]()
        man.requestAPI(params: dict, pageUrl: "/operation/follow/areaTree/1", method: .get) { result in
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
        let dict = [String: Any]()
        man.requestAPI(params: dict, pageUrl: "/operation/follow/industryTree/1", method: .get) { result in
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
    
    
}
