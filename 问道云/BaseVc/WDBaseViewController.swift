//
//  WDBaseViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import RxSwift
import DropMenuBar
import BRPickerView
import Kingfisher

class WDBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var emptyView: LLemptyView = {
        let emptyView = LLemptyView()
        return emptyView
    }()
    
    lazy var noNetView: NoNetView = {
        let noNetView = NoNetView()
        return noNetView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(cssStr: "#F4F6FC")
    }
    
}


extension WDBaseViewController {
    
    func addHeadView(from headView: HeadView) {
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func popLogin() {
        let loginVc = WDLoginViewController()
        let rootVc = WDNavigationController(rootViewController: loginVc)
        rootVc.modalPresentationStyle = .overFullScreen
        self.present(rootVc, animated: true)
        WDLoginConfig.removeLoginInfo()
        loginVc.loginView.backBtn.rx.tap.subscribe(onNext: {
            NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
        }).disposed(by: disposeBag)
    }
    
    func pushWebPage(from pageUrl: String) {
        let webVc = WebPageViewController()
        var webUrl: String = pageUrl
        if pageUrl.contains("wintaocloud.com") {
            webVc.pageUrl.accept(webUrl)
        }else {
            webUrl = "http://" + pageUrl
            webVc.pageUrl.accept(webUrl)
        }
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func isValidWebURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return url.scheme == "http" || url.scheme == "https"
    }
    
    func addNodataView(from view: UIView) {
        view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT)
            make.width.equalTo(SCREEN_WIDTH)
        }
    }
    
    func addNoNetView(from view: UIView) {
        view.addSubview(self.noNetView)
        self.noNetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //获取分组状态
    func getGroupMenuInfo(from modelArray: [rowsModel]) -> [ItemModel]{
        var allArray = [ItemModel]()
        let model1 = ItemModel(text: "全部分组", currentID: "", isSelect: true)!
        for rowmodel in modelArray {
            let model = ItemModel(text: rowmodel.groupname, currentID: rowmodel.groupnumber ?? "", isSelect: false)!
            allArray.append(model)
        }
        allArray.insert(model1, at: 0)
        return allArray
    }
    
    //获取地区
    func getRegionInfo(from modelArray: [rowsModel]) -> [ItemModel] {
        var twoList: [ItemModel] = []
        let regionModel = ItemModel(text: "全国", currentID: "", isSelect: true)!
        let noModel = ItemModel(text: "不限", currentID: "", isSelect: true)!
        twoList.append(regionModel)
        for (_, rowModel) in modelArray.enumerated() {
            var model: ItemModel
            model = ItemModel(text: rowModel.name, currentID: rowModel.code, isSelect: false)
            var temp: [ItemModel] = []
            if let children = rowModel.children {
                temp.append(noModel)
                for (_, chModel) in children.enumerated() {
                    let layerModel = ItemModel(
                        text: chModel.name,
                        currentID: chModel.code,
                        isSelect: false
                    )
                    temp.append(layerModel!)
                }
            }
            model.dataSource = temp
            twoList.append(model)
        }
        return twoList
    }
    
    //获取三级地区列表
    func getThreeRegionInfo(from modelArray: [rowsModel]) -> [ItemModel] {
        var threeList: [ItemModel] = []
        let regionModel = ItemModel(text: "全国", currentID: "", isSelect: true)!
        threeList.append(regionModel)
        for (_, rowModel) in modelArray.enumerated() {
            let levelOneModel = ItemModel(text: rowModel.name, currentID: rowModel.code, isSelect: false)!
            if let secondLevelChildren = rowModel.children {
                var secondLevelList: [ItemModel] = []
                let hanyeModel = ItemModel(text: "不限", currentID: "", isSelect: true)!
                secondLevelList.append(hanyeModel)
                for (_, secondLevelModel) in secondLevelChildren.enumerated() {
                    let levelTwoModel = ItemModel(text: secondLevelModel.name, currentID: secondLevelModel.code, isSelect: false)!
                    if let thirdLevelChildren = secondLevelModel.children {
                        var thirdLevelList: [ItemModel] = []
                        let hanyeModelThirdLevel = ItemModel(text: "不限", currentID: "", isSelect: true)!
                        thirdLevelList.append(hanyeModelThirdLevel)
                        for (_, thirdLevelModel) in thirdLevelChildren.enumerated() {
                            let levelThreeModel = ItemModel(text: thirdLevelModel.name, currentID: thirdLevelModel.code, isSelect: false)!
                            thirdLevelList.append(levelThreeModel)
                        }
                        levelTwoModel.dataSource = thirdLevelList
                    }
                    secondLevelList.append(levelTwoModel)
                }
                levelOneModel.dataSource = secondLevelList
            }
            threeList.append(levelOneModel)
        }
        return threeList
    }
    
    //获取三级行业列表
    func getThreeIndustryInfo(from modelArray: [rowsModel]) -> [ItemModel] {
        var threeList: [ItemModel] = []
        let regionModel = ItemModel(text: "全部", currentID: "", isSelect: true)!
        threeList.append(regionModel)
        for (_, rowModel) in modelArray.enumerated() {
            let levelOneModel = ItemModel(text: rowModel.name, currentID: rowModel.code, isSelect: false)!
            if let secondLevelChildren = rowModel.children {
                var secondLevelList: [ItemModel] = []
                let hanyeModel = ItemModel(text: "不限", currentID: "", isSelect: true)!
                secondLevelList.append(hanyeModel)
                for (_, secondLevelModel) in secondLevelChildren.enumerated() {
                    let levelTwoModel = ItemModel(text: secondLevelModel.name, currentID: secondLevelModel.code, isSelect: false)!
                    if let thirdLevelChildren = secondLevelModel.children {
                        var thirdLevelList: [ItemModel] = []
                        let hanyeModelThirdLevel = ItemModel(text: "不限", currentID: "", isSelect: true)!
                        thirdLevelList.append(hanyeModelThirdLevel)
                        for (_, thirdLevelModel) in thirdLevelChildren.enumerated() {
                            let levelThreeModel = ItemModel(text: thirdLevelModel.name, currentID: thirdLevelModel.code, isSelect: false)!
                            thirdLevelList.append(levelThreeModel)
                        }
                        levelTwoModel.dataSource = thirdLevelList
                    }
                    secondLevelList.append(levelTwoModel)
                }
                levelOneModel.dataSource = secondLevelList
            }
            threeList.append(levelOneModel)
        }
        return threeList
    }
    
    //获取行业
    func getIndustryInfo(from modelArray: [rowsModel]) -> [ItemModel] {
        var twoList: [ItemModel] = []
        let allModel = ItemModel(text: "全部", currentID: "", isSelect: true)!
        let noModel = ItemModel(text: "不限", currentID: "", isSelect: true)!
        twoList.append(allModel)
        for (_, rowModel) in modelArray.enumerated() {
            var model: ItemModel
            model = ItemModel(text: rowModel.name, currentID: rowModel.code, isSelect: false)
            var temp: [ItemModel] = []
            if let children = rowModel.children {
                temp.append(noModel)
                for (_, chModel) in children.enumerated() {
                    let layerModel = ItemModel(
                        text: chModel.name,
                        currentID: chModel.code,
                        isSelect: false
                    )
                    temp.append(layerModel!)
                }
            }
            model.dataSource = temp
            twoList.append(model)
        }
        return twoList
    }
    
    //添加状态
    func getListType(from modelArray: [rowsModel]) -> [ItemModel]{
        var allArray = [ItemModel]()
        let model1 = ItemModel(text: "全部", currentID: "0", isSelect: true)!
        for rowmodel in modelArray {
            let model = ItemModel(text: rowmodel.combotypename, currentID: String(rowmodel.combotypenumber ?? 0), isSelect: false)!
            allArray.append(model)
        }
        allArray.insert(model1, at: 0)
        return allArray
    }
    
    //我的下载筛选状态
    func getDownloadListType(from modelArray: [rowsModel]) -> [ItemModel]{
        var allArray = [ItemModel]()
        var isFirst = true // 用来判断是否是第一个元素
        for rowmodel in modelArray {
            let model = ItemModel(text: rowmodel.value, currentID: rowmodel.code, isSelect: isFirst)!
            allArray.append(model)
            isFirst = false // 之后的元素都设置为 false
        }
        return allArray
    }
    
    //下拉订单状态选择
    func getListOrderType(from isSelect: Bool) -> [ItemModel]{
        let model1 = ItemModel(text: "全部", currentID: "", isSelect: isSelect)!
        let model2 = ItemModel(text: "已支付", currentID: "1", isSelect: false)!
        let model3 = ItemModel(text: "未支付", currentID: "2", isSelect: false)!
        let model4 = ItemModel(text: "已取消", currentID: "3", isSelect: false)!
        let modelArray = [model1, model2, model3, model4]
        return modelArray
    }
    
    //下拉时间选择
    func getListTime(from isSelect: Bool) -> [ItemModel]{
        let model1 = ItemModel(text: "全部", currentID: "", isSelect: isSelect)!
        let model2 = ItemModel(text: "今天", currentID: "today", isSelect: false)!
        let model3 = ItemModel(text: "近一周", currentID: "week", isSelect: false)!
        let model4 = ItemModel(text: "近一月", currentID: "month", isSelect: false)!
        let model5 = ItemModel(text: "近一年", currentID: "year", isSelect: false)!
        let modelArray = [model1, model2, model3, model4, model5]
        return modelArray
    }
    
    //自定义时间选择
    func getPopTimeDatePicker(completion: @escaping (String?) -> Void) {
        let datePickerView = BRDatePickerView()
        datePickerView.pickerMode = .YMD
        datePickerView.title = "自定义时间"
        datePickerView.minDate = NSDate.br_setYear(1900, month: 01, day: 01)
        datePickerView.maxDate = Date()
        datePickerView.resultBlock = { selectDate, selectValue in
            guard let selectValue = selectValue else {
                completion(nil)
                return
            }
            let selectedArray = selectValue.components(separatedBy: "-")
            if selectedArray.count == 3 {
                let selectedDay = selectedArray[2]
                let selectedMonth = selectedArray[1]
                let selectedYear = selectedArray[0]
                let timeStr = "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
                completion(timeStr)
            } else {
                completion(nil)
            }
        }
        let customStyle = BRPickerStyle()
        customStyle.pickerColor = .white
        customStyle.pickerTextFont = .mediumFontOfSize(size: 16)
        customStyle.selectRowTextColor = UIColor.init(cssStr: "#547AFF")
        datePickerView.pickerStyle = customStyle
        datePickerView.show()
    }
    
    
}


extension WDBaseViewController {
    
    //购买会员
    func payMemberInfo(from combonumber: String,//store ID
                       ordertype: Int,//订单类型 1自购 2赠送
                       friendphone: String,//好友电话
                       pushmsflag: Int,//是否发送短信
                       complete: (() -> Void)? = nil) {
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let phonenumber = GetSaveLoginInfoConfig.getPhoneNumber()
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["customernumber": customernumber,
                    "combonumber": combonumber,
                    "phonenumber": phonenumber,
                    "ordertype": ordertype,
                    "friendphone": friendphone,
                    "pushmsflag": pushmsflag,
                    "usertype": 1,
                    "accountcount": 1,
                    "quantity": 1] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerorder/addorder",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    //唤醒苹果支付
                    let combonumber = String(success.data?.combonumber ?? 0)
                    let orderNumberID = success.data?.ordernumber ?? ""
                    self?.toApplePay(form: combonumber, orderNumberID: orderNumberID, complete: {
                        complete?()
                    })
                }else {
                    ToastViewConfig.showToast(message: success.msg ?? "")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //支付
    func toApplePay(form combonumber: String,
                    orderNumberID: String,
                    complete: (() -> Void)? = nil) {
        ApplePayConfig.buy(with: GetStoreIDManager.storeID(with: combonumber)) {
            self.paySuccess(from: orderNumberID) {
                complete?()
            }
        }
    }
    
    //支付成功回调
    private func paySuccess(from orderNumberID:
                            String, complete: (() -> Void)? = nil) {
        let man = RequestManager()
        let dict = ["ordernumber": orderNumberID,
                    "payway": "3"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerorder/callback",
                       method: .post) { result in
            complete?()
        }
    }
    
}
