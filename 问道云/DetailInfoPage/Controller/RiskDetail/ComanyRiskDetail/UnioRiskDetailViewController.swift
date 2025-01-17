//
//  UnioRiskDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/17.
//  关联风险

import UIKit
import JXPagingView

class UnioRiskDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var name: String = ""
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //数据模型
    var model: DataModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RiskUnioViewCell.self, forCellReuseIdentifier: "RiskUnioViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //获取关联风险
        getUnioRiskInfo()
    }
}

extension UnioRiskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.rimRisk?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiskUnioViewCell", for: indexPath) as? RiskUnioViewCell
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        let model = self.model?.rimRisk?[indexPath.row]
        cell?.model.accept(model)
        return cell ?? UITableViewCell()
    }
    
}

extension UnioRiskDetailViewController {
    
    //获取关联风险
    private func getUnioRiskInfo() {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["entityid": enityId, "customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/rimRisk",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data, let modelArray = model.rimRisk,  !modelArray.isEmpty {
                    self.model = model
                    self.tableView.reloadData()
                }else {
                    self.addNodataView(from: self.tableView)
                }
                break
            case .failure(_):
                self.addNodataView(from: self.tableView)
                break
            }
        }
    }
    
}

extension UnioRiskDetailViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
