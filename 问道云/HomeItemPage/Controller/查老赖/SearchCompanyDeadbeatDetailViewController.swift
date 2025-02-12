//
//  SearchCompanyDeadbeatDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/12.
//

import UIKit

class SearchCompanyDeadbeatDetailViewController: WDBaseViewController {
    
    var model: itemsModel? {
        didSet {
            
        }
    }
    
    var modelArray: [minutesListModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "失信记录列表"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var riskView: UIView = {
        let riskView = UIView()
        riskView.backgroundColor = .white
        return riskView
    }()
    
    lazy var riskImageView: UIImageView = {
        let riskImageView = UIImageView()
        riskImageView.image = UIImage(named: "detailriskicon")
        return riskImageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var oneRiskView: DetailRiskItemView = {
        let oneRiskView = DetailRiskItemView()
        return oneRiskView
    }()
    
    lazy var twoRiskView: DetailRiskItemView = {
        let twoRiskView = DetailRiskItemView()
        return twoRiskView
    }()
    
    lazy var threeRiskView: DetailRiskItemView = {
        let threeRiskView = DetailRiskItemView()
        return threeRiskView
    }()
    
    lazy var fourRiskView: DetailRiskItemView = {
        let fourRiskView = DetailRiskItemView()
        return fourRiskView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        return nameLabel
    }()
    
    lazy var cImageView: UIImageView = {
        let cImageView = UIImageView()
        cImageView.image = UIImage(named: "lailaiimage")
        return cImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#9FA4AD")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchPeopleDeadbeatDetailTableViewCell.self, forCellReuseIdentifier: "SearchPeopleDeadbeatDetailTableViewCell")
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
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(nameLabel)
        view.addSubview(cImageView)
        view.addSubview(descLabel)
        view.addSubview(lineView)
        view.addSubview(riskView)
        riskView.addSubview(riskImageView)
        riskView.addSubview(scrollView)
        scrollView.addSubview(oneRiskView)
        scrollView.addSubview(twoRiskView)
        scrollView.addSubview(threeRiskView)
        scrollView.addSubview(fourRiskView)
        view.addSubview(tableView)
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(headView.snp.bottom).offset(13)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(25)
        }
        cImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(13)
            make.size.equalTo(CGSize(width: 26, height: 15))
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(ctImageView.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(descLabel.snp.bottom).offset(7)
        }
        riskView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(72)
        }
        riskImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 60))
            make.left.equalToSuperview().offset(12)
        }
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(riskImageView.snp.right).offset(4)
            make.right.top.bottom.equalToSuperview()
        }
        oneRiskView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105, height: 56))
            make.left.equalToSuperview()
        }
        twoRiskView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105, height: 56))
            make.left.equalTo(oneRiskView.snp.right).offset(4)
        }
        threeRiskView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105, height: 56))
            make.left.equalTo(twoRiskView.snp.right).offset(4)
        }
        fourRiskView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 105, height: 56))
            make.left.equalTo(threeRiskView.snp.right).offset(4)
            make.right.equalToSuperview().offset(-5)
        }
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(riskView.snp.bottom).offset(1)
        }
        //获取详情信息
        getDetailInfo()
    }
}

extension SearchCompanyDeadbeatDetailViewController {
    
    private func getDetailInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["entityId": self.model?.entityId ?? "",
                    "type": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/cooperation/getDeadBeatDetail",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data {
                    let name = model.entityName ?? ""
                    ctImageView.image = UIImage.imageOfText(name, size: (45, 45))
                    nameLabel.text = name
                    descLabel.text = "简介: --"
                    self.oneRiskView.namelabel.text = model.riskList?.map1?.name ?? ""
                    self.oneRiskView.numLabel.text = model.riskList?.map1?.sumTotal ?? ""
                    
                    self.twoRiskView.namelabel.text = model.riskList?.map2?.name ?? ""
                    self.twoRiskView.numLabel.text = model.riskList?.map2?.sumTotal ?? ""
                    
                    self.threeRiskView.namelabel.text = model.riskList?.map3?.name ?? ""
                    self.threeRiskView.numLabel.text = model.riskList?.map3?.sumTotal ?? ""
                    
                    self.fourRiskView.namelabel.text = model.riskList?.map4?.name ?? ""
                    self.fourRiskView.numLabel.text = model.riskList?.map4?.sumTotal ?? ""
                    
                    if let modelArray = model.minutesList {
                        self.modelArray = modelArray
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchCompanyDeadbeatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F8F8")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(32)
        }
        let count = String(self.modelArray.count)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条失信信息", font: .regularFontOfSize(size: 12))
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPeopleDeadbeatDetailTableViewCell", for: indexPath) as! SearchPeopleDeadbeatDetailTableViewCell
        cell.selectionStyle = .none
        cell.namelabel.text = model.caseTitle ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelArray[indexPath.row]
        let dict = ["dataId": model.dataId ?? "",
                    "caseNumber": model.caseNumber ?? "",
                    "entityId": self.model?.entityId ?? ""]
        let pageUrl = "\(base_url)/litigation-risk/lose-trust-detail"
        let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
        self.pushWebPage(from: webUrl)
    }
}
