//
//  MyDownloadViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/12.
//  我的下载

import UIKit
import RxRelay
import DropMenuBar
import MJRefresh
import TYAlertController

class MyDownloadViewController: WDBaseViewController {
    
    var downloadtype: String = ""
    var downloadfilename: String = ""
    var isChoiceDate: String = ""
    var pageNum: Int = 1
    
    var allArray: [rowsModel] = []//加载更多
    
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
    
    var downloadModel = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var deleteArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        view.addSubview(downloadView)
        downloadView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(0.5)
        }
        
        //添加下拉刷新
        self.downloadView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
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
            self?.pushWebPage(from: model.filepathH5 ?? "")
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
                    let alertVc = TYAlertController(alert: self?.cmmView, preferredStyle: .alert)
                    self?.present(alertVc!, animated: true)
                    self?.cmmView.model = model
                    self?.cmmView.cblock = {
                        self?.dismiss(animated: true)
                    }
                })
            }
            morePopView.block2 = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    let alertVc = TYAlertController(alert: self?.sendView, preferredStyle: .alert)
                    self?.present(alertVc!, animated: true)
                    self?.sendView.model = model
                    self?.sendView.cblock = {
                        self?.dismiss(animated: true)
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
        }
        
        addDownList()
        getDownloadTypeList()
        getPdfInfo()
    }
    
}

extension MyDownloadViewController {
    
    //添加下拉筛选
    func addDownList() {
        let leixing1 = MenuAction(title: "类型", style: .typeList)!
        self.downloadModel.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            leixing1.listDataSource = getDownloadListType(form: modelArray)
        }).disposed(by: disposeBag)
        leixing1.didSelectedMenuResult = { [weak self] index, model in
            guard let self = self else { return }
            downloadtype = model?.currentID ?? ""
            pageNum = 1
            getPdfInfo()
        }
        
        
        let leixing2 = MenuAction(title: "时间", style: .typeList)!
        let menuView = DropMenuBar(action: [leixing1, leixing2])!
        self.downloadView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(46)
            make.height.equalTo(26)
        }
    }
    
    //获取下拉筛选列表
    func getDownloadTypeList() {
        let man = RequestManager()
        man.requestAPI(params: ["param": "downloadFileType"], pageUrl: "/operation/ajax/querySelect", method: .get) { [weak self] result in
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
        let man = RequestManager()
        let dict = ["downloadtype": downloadtype, "downloadfilename": downloadfilename, "isChoiceDate": isChoiceDate, "pageNum": pageNum, "pageSize": 5] as [String : Any]
        man.requestAPI(params: dict, pageUrl: customerDownload_list, method: .get) { [weak self] result in
            guard let self = self else { return }
            self.downloadView.tableView.mj_header?.endRefreshing()
            self.downloadView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data, let total = success.data?.total {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(form: self.downloadView)
                    }
                    self.downloadView.modelArray.accept(self.allArray)
                    if self.allArray.count != total {
                        self.downloadView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.downloadView.tableView.mj_footer?.isHidden = true
                    }
                }else {
                    self.addNodataView(form: self.downloadView)
                }
                break
            case .failure(_):
                self.addNodataView(form: self.downloadView)
                break
            }
        }
    }
    
    //删除文件
    func deletePdf(from dataid: [String]) {
        let dict = ["ids": dataid]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/mydownload/customerDownload", method: .put) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
    
}
