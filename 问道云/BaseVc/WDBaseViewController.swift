//
//  WDBaseViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import RxSwift
import DropMenuBar

class WDBaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var emptyView: LLemptyView = {
        let emptyView = LLemptyView()
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(cssStr: "#F4F6FC")
    }

}


extension WDBaseViewController {
    
    func popLogin() {
        let loginVc = WDLoginViewController()
        let rootVc = WDNavigationController(rootViewController: loginVc)
        rootVc.modalPresentationStyle = .overFullScreen
        self.present(rootVc, animated: true)
        
        loginVc.loginView.backBtn.rx.tap.subscribe(onNext: {
            WDLoginConfig.removeLoginInfo()
            NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
        }).disposed(by: disposeBag)
    }
    
    func pushWebPage(from pageUrl: String) {
        let webVc = WebPageViewController()
        var webUrl: String = ""
        if !pageUrl.contains(base_url) {
            webUrl = base_url + pageUrl
        }else {
            webUrl = pageUrl
        }
        webVc.pageUrl.accept(webUrl)
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func addNodataView(form view: UIView) {
        view.addSubview(self.emptyView)
        self.emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 163) * 0.5)
            make.size.equalTo(CGSize(width: 163, height: 163))
        }
    }
    
    //添加状态
    func getListType(form modelArray: [rowsModel]) -> [ItemModel]{
        var allArray = [ItemModel]()
        let model1 = ItemModel(text: "全部", currentID: "0", isSelect: true)!
        for rowmodel in modelArray {
            let model = ItemModel(text: rowmodel.descprtion, currentID: String(rowmodel.combotypenumber ?? 0), isSelect: false)!
            allArray.append(model)
        }
        allArray.insert(model1, at: 0)
        return allArray
    }
    
    //我的下载筛选状态
    func getDownloadListType(form modelArray: [rowsModel]) -> [ItemModel]{
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
}

