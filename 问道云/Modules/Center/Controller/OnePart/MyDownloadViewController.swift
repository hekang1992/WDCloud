//
//  MyDownloadViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/12.
//  我的下载

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import DropMenuBar
import TYAlertController

class MyDownloadViewController: WDBaseViewController {
    
    var downloadtype: String = ""
    var downloadfilename: String = ""
    var isChoiceDate: String = ""
    var pageNum: Int = 1
    
    var downloadModel = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var deleteArray: [String] = []
    
    var allArray: [rowsModel] = []//加载更多
    
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    
    var startTime: String = ""//开始时间
    
    var endTime: String = ""//结束时间
    
    let isDeleteMode = BehaviorRelay<Bool>(value: false) // 控制是否是删除模式
        
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "我的下载"
        headView.oneBtn.setImage(UIImage(named: "delete_icon"), for: .normal)
        return headView
    }()
    
    lazy var downloadView: MyDownloadView = {
        let downloadView = MyDownloadView()
        return downloadView
    }()
    
    lazy var morePopView: PopMoreBtnView = {
        let morePopView = PopMoreBtnView(frame: self.view.bounds)
        return morePopView
    }()
    
    lazy var cmmView: CMMView = {
        let cmmView = CMMView(frame: self.view.bounds)
        return cmmView
    }()
    
    lazy var sendView: SendEmailView = {
        let sendView = SendEmailView(frame: self.view.bounds)
        return sendView
    }()
    
    lazy var diView: DIBUView = {
        let diView = DIBUView()
        diView.isHidden = true
        return diView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            let currentMode = self?.isDeleteMode.value ?? false
            self?.isDeleteMode.accept(!currentMode)
            self?.downloadView.isDeleteMode.accept(!currentMode)
            self?.downloadView.modelArray.accept(self?.allArray ?? [])
            self?.diView.isHidden = currentMode
            self?.downloadView.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        
        downloadView.totalBlock = { [weak self] total in
            let modelArray = self?.allArray ?? []
            if modelArray.count == total {
                self?.diView.quanxianBtn.isSelected = true
            }else {
                self?.diView.quanxianBtn.isSelected = false
            }
        }
        
        diView.quanxuanblock = { [weak self] in
            if let btn = self?.diView.quanxianBtn {
                if btn.isSelected {
                    self?.downloadView.selectedIndexPaths.removeAll()
                    btn.isSelected = false
                }else {
                    self?.downloadView.selectedIndexPaths = self?.allArray.enumerated().map({
                        IndexPath(row: $0.offset, section: 0)
                    }) ?? []
                    btn.isSelected = true
                }
                self?.downloadView.tableView.reloadData()
            }
        }
        
        diView.shanchublock = { [weak self] in
            guard let self = self else { return }
            if self.downloadView.selectedIndexPaths.count > 0 {
                ShowAlertManager.showAlert(title: "提示", message: "确定要删除选中的文件?", confirmAction: {
                    self.deleteArray.removeAll()
                    for indexPath in self.downloadView.selectedIndexPaths {
                        self.deleteArray.append(self.allArray[indexPath.row].dataid ?? "")
                    }
                    self.deletePdf(from: self.deleteArray)
                    
                    print("deleteArray>>>>>>>:\(self.deleteArray.count)")
                })
            }else {
                ToastViewConfig.showToast(message: "请选择您需要删除的文件")
            }
        }
        
        view.addSubview(diView)
        diView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(66)
        }
        
        //添加下拉刷新
        self.downloadView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getPdfInfo()
        })
        //加载更多
        self.downloadView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getPdfInfo()
        })
        //点击cell
        self.downloadView.selectBlock = { [weak self] model in
            let isdeleteGrand = self?.isDeleteMode.value ?? true
            if !isdeleteGrand {
                let filepathH5 = model.filepathH5 ?? ""
                self?.pushWebPage(from: filepathH5)
            }
        }
        //点击更多按钮
        self.downloadView.moreBtnBlock = { [weak self] model in
            guard let self = self else { return }
            let alertVc = TYAlertController(alert: morePopView, preferredStyle: .actionSheet)
            morePopView.model.accept(model)
            self.present(alertVc!, animated: true)
            
            morePopView.block = { [weak self] in
                self?.dismiss(animated: true)
            }
            morePopView.block1 = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    let alertVc = TYAlertController(alert: self?.cmmView, preferredStyle: .actionSheet)
                    self?.present(alertVc!, animated: true)
                    self?.cmmView.model = model
                    self?.cmmView.cblock = {
                        self?.dismiss(animated: true)
                    }
                    self?.cmmView.sblock = {
                        self?.changeName(form: model)
                    }
                })
            }
            morePopView.block2 = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    let alertVc = TYAlertController(alert: self?.sendView, preferredStyle: .actionSheet)
                    self?.present(alertVc!, animated: true)
                    self?.sendView.model = model
                    self?.sendView.cblock = {
                        self?.dismiss(animated: true)
                    }
                    self?.sendView.sblock = {
                        self?.sendEmailInfo(form: model)
                    }
                })
            }
            morePopView.block3 = { [weak self] in
                self?.dismiss(animated: true) {
                    ShowAlertManager.showAlert(title: "提示", message: "确定要删除选中的文件?", confirmAction: {
                        self?.deleteArray.append(model.dataid ?? "")
                        self?.deletePdf(from: self?.deleteArray ?? [])
                    }, cancelAction: {
                        
                    })
                }
            }
            morePopView.block4 = { model in
                self.dismiss(animated: true) {
                    self.shareButtonTapped(from: model)
                }
            }
        }
        //搜索数据
        self.downloadView.searchView.serachTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.downloadView.searchView.serachTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.pageNum = 1
                self?.downloadfilename = text
                self?.getPdfInfo()
            }).disposed(by: disposeBag)
        
        addDownList()
        getDownloadTypeList()
        getPdfInfo()
    }
    
}

extension MyDownloadViewController {
    
    //添加时间下拉筛选
    func addDownList() {
        let leixing1 = MenuAction(title: "类型", style: .typeList)!
        self.downloadModel.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            leixing1.listDataSource = getDownloadListType(from: modelArray)
        }).disposed(by: disposeBag)
        leixing1.didSelectedMenuResult = { [weak self] index, model, granted in
            guard let self = self else { return }
            downloadtype = model?.currentID ?? ""
            pageNum = 1
            getPdfInfo()
        }
        
        let leixing2 = MenuAction(title: "时间", style: .typeCustom)!
        var modelArray = getListTime(from: true)
        leixing2.displayCustomWithMenu = { [weak self] in
            let timeView = TimeDownView()
            if ((self?.startDateRelay.value?.isEmpty) != nil) && ((self?.endDateRelay.value?.isEmpty) != nil) {
                timeView.startDateRelay.accept(self?.startDateRelay.value)
                timeView.endDateRelay.accept(self?.endDateRelay.value)
            }
            timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 315)
            //点击全部,今天,近一周等
            timeView.block = { model in
                self?.pageNum = 1
                self?.isChoiceDate = model.currentID ?? ""
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
                self?.getPdfInfo()
                if model.displayText != "全部" {
                    leixing2.adjustTitle(model.displayText ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    leixing2.adjustTitle("时间", textColor: UIColor.init(cssStr: "#666666"))
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
                self?.pageNum = 1
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
                leixing2.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
                self?.getPdfInfo()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        
        let menuView = DropMenuBar(action: [leixing1, leixing2])!
        self.downloadView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(46)
            make.height.equalTo(26)
        }
    }
    
    func shareButtonTapped(from model: rowsModel) {
        if let pdfURL = URL(string: model.filepathH5 ?? "") {
            let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = .down
            }
            present(activityViewController, animated: true, completion: nil)
        } else {
            ToastViewConfig.showToast(message: "无效的PDF链接")
        }
    }
}

/** 网络数据请求 */
extension MyDownloadViewController {
    
    //获取下拉筛选列表
    func getDownloadTypeList() {
        let man = RequestManager()
        man.requestAPI(params: ["param": "downloadFileType"],
                       pageUrl: "/operation/ajax/querySelect",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                let model = success.data
                self?.downloadModel.accept(model?.data)
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取下载文件
    func getPdfInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["downloadtype": downloadtype,
                    "downloadfilename": downloadfilename,
                    "isChoiceDate": isChoiceDate,
                    "pageNum": pageNum,
                    "pageSize": 10] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/mydownload/customerDownload",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            self.downloadView.tableView.mj_header?.endRefreshing()
            self.downloadView.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data,
                    let total = success.data?.total {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.downloadView.whiteView)
                    }
                    self.downloadView.modelArray.accept(self.allArray)
                    if self.allArray.count != total {
                        self.downloadView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.downloadView.tableView.mj_footer?.isHidden = true
                    }
                }else {
                    self.addNodataView(from: self.downloadView.whiteView)
                    self.downloadView.tableView.mj_footer?.isHidden = true
                    self.noNetView.refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
                        self?.getDownloadTypeList()
                        self?.getPdfInfo()
                    }).disposed(by: disposeBag)
                }
                self.downloadView.tableView.reloadData()
                break
            case .failure(_):
                self.addNodataView(from: self.downloadView.whiteView)
                self.downloadView.tableView.mj_footer?.isHidden = true
                break
            }
        }
    }
    
    //删除文件
    func deletePdf(from dataid: [String]) {
        let dict = ["ids": dataid]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/mydownload/customerDownload",
                       method: .put) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.dismiss(animated: true, completion: {
                        self?.diView.quanxianBtn.isSelected = false
                        self?.diView.isHidden = true
                        self?.pageNum = 1
                        self?.getPdfInfo()
                    })
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //重命名
    func changeName(form model: rowsModel) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["dataId": model.dataid ?? "",
                    "downLoadFileName": self.cmmView.tf.text ?? ""]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/mydownload/updateCustomerDownload",
                       method: .put) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.dismiss(animated: true, completion: {
                        self?.pageNum = 1
                        self?.getPdfInfo()
                    })
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //发送邮箱
    func sendEmailInfo(form model: rowsModel) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["dataid": model.dataid ?? "",
                    "emailnumber": self.sendView.tf.text ?? "",
                    "type": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/mydownload/sendingMailbox",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.dismiss(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
