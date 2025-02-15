//
//  MyOpinioViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/14.
//

import UIKit
import RxRelay

class MyOpinioViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "我的反馈"
        return headView
    }()
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MyOpinionViewCell.self, forCellReuseIdentifier: "MyOpinionViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        addHeadView(from: headView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.modelArray.asObservable().compactMap { $0 }.bind(to: tableView.rx.items(cellIdentifier: "MyOpinionViewCell", cellType: MyOpinionViewCell.self)) { row, model, cell in
            cell.model.accept(model)
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        self.tableView
            .rx
            .modelSelected(rowsModel.self)
            .subscribe(onNext: { [weak self] model in
                let detailVc = MyOpinioDetailViewController()
                detailVc.rowsModel.accept(model)
                self?.navigationController?.pushViewController(detailVc, animated: true)
        }).disposed(by: disposeBag)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyOpinionInfo()
    }

}

extension MyOpinioViewController {
    
    private func getMyOpinionInfo() {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber, "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/operationFeedback/list",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.rows, !modelArray.isEmpty {
                        self.emptyView.removeFromSuperview()
                        self.modelArray.accept(modelArray)
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                }
                break
            case .failure(_):
                self.addNodataView(from: self.tableView)
                break
            }
        }
    }
    
}

extension MyOpinioViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}
