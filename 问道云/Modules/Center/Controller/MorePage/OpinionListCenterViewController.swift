//
//  OpinionListCenterViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/14.
//

import UIKit
import RxRelay

class OpinionListCenterViewController: WDBaseViewController {
    
    var feedbacktype = BehaviorRelay<String>(value: "")
    
    var titles: [String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "意见反馈"
        return headView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.text = "请选择具体功能异常问题"
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
        view.addSubview(desclabel)
        view.addSubview(tableView)
        desclabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12.5)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(desclabel.snp.bottom).offset(5)
        }
    }


}

extension OpinionListCenterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = titles?[indexPath.row]
        cell.textLabel?.font = .regularFontOfSize(size: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles?[indexPath.row] ?? ""
        let uploadVc = OpinioUpLoadViewController()
        uploadVc.questionTitle = "问题类型:\(title) "
        uploadVc.feedbacktype.accept(feedbacktype.value)
        uploadVc.feedbacksubtype.accept(title)
        self.navigationController?.pushViewController(uploadVc, animated: true)
    }
}
