//
//  CompanyActivityViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//  企业动态详情

import UIKit

class CompanyActivityViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var pageIndex: Int = 1
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //获取动态数据
        getActivityInfo()
    }
    
}

extension CompanyActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
}

extension CompanyActivityViewController {
    
    private func getActivityInfo() {
        let man = RequestManager()
        let dict = ["entityId": enityId,
                    "pageNum": pageIndex,
                    "pageSize": "20"] as [String : Any]
        man.requestAPI(params: dict, pageUrl: "/riskmonitor/generate/dynamicRiskData", method: .get) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
}
