//
//  OneReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit

class OneReportViewController: WDBaseViewController {
    
    var dataModel: DataModel?
    
    var modelArray: [rowsModel]?

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "一键报告"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "myreportimage"), for: .normal)
        return headView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HomeOneReportCell.self, forCellReuseIdentifier: "HomeOneReportCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(5)
        }
        
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let downVc = MyDownloadViewController()
            self.navigationController?.pushViewController(downVc, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    
}

extension OneReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        let model = self.modelArray?[section]
        let headView = UIView()
        headView.backgroundColor = .white
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        headView.addSubview(nameLabel)
        headView.addSubview(lineView)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(21)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        nameLabel.text = model?.name ?? ""
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = self.modelArray?[indexPath.section].name ?? ""
        let model = self.modelArray?[indexPath.section].items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOneReportCell", for: indexPath) as! HomeOneReportCell
        cell.selectionStyle = .none
        cell.model.accept(model)
        cell.name = name
        cell.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let pageUrl = model?.templatepath ?? ""
            self.pushWebPage(from: pageUrl)
        }).disposed(by: disposeBag)
        return cell
    }
}

extension OneReportViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOneReportInfo()
    }
    
    //获取一键报告信息
    private func getOneReportInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["entityid": dataModel?.firmInfo?.entityId ?? ""]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerreport/reportlist",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let datas = success.datas {
                    self.modelArray = datas
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
