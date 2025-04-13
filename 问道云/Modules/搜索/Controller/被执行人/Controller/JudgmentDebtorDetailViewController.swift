//
//  JudgmentDebtorDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import MJRefresh

class JudgmentDebtorDetailViewController: WDBaseViewController {
    
    var personId: String = ""
    var orgId: String = ""
    
    var nameTitle: String = ""
    var pageUrl: String = ""
    var reusmStr: String = ""
    var pageNum: Int = 1
    var dataModel: DataModel?
    var riskType: String = ""
    
    var modelArray: [rowsModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = nameTitle
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
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
        oneRiskView.isUserInteractionEnabled = true
        return oneRiskView
    }()
    
    lazy var twoRiskView: DetailRiskItemView = {
        let twoRiskView = DetailRiskItemView()
        twoRiskView.isUserInteractionEnabled = true
        return twoRiskView
    }()
    
    lazy var threeRiskView: DetailRiskItemView = {
        let threeRiskView = DetailRiskItemView()
        threeRiskView.isUserInteractionEnabled = true
        return threeRiskView
    }()
    
    lazy var fourRiskView: DetailRiskItemView = {
        let fourRiskView = DetailRiskItemView()
        fourRiskView.isUserInteractionEnabled = true
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
        nameLabel.isUserInteractionEnabled = true
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#9FA4AD")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.titleLabel?.font = .mediumFontOfSize(size: 12)
        moreButton.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        moreButton.setTitle("展开", for: .normal)
        moreButton.contentHorizontalAlignment = .right
        return moreButton
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
    
    //简介
    lazy var infoView: CompanyDescInfoView = {
        let infoView = CompanyDescInfoView()
        return infoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(nameLabel)
        view.addSubview(descLabel)
        view.addSubview(moreButton)
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
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(ctImageView.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-35)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(16.5)
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
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getDetailInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getDetailInfo()
        })
        getDetailInfo()
        
        oneRiskView.block = { [weak self] in
            guard let self = self, let model = self.dataModel else { return }
            goRiskInfoVc(from: model)
        }
        
        twoRiskView.block = { [weak self] in
            guard let self = self, let model = self.dataModel else { return }
            goRiskInfoVc(from: model)
        }
        
        threeRiskView.block = { [weak self] in
            guard let self = self, let model = self.dataModel else { return }
            goRiskInfoVc(from: model)
        }
        
        fourRiskView.block = { [weak self] in
            guard let self = self, let model = self.dataModel else { return }
            goRiskInfoVc(from: model)
        }
        
        moreButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            keyWindow?.addSubview(infoView)
            infoView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
                make.top.equalTo(self.descLabel.snp.top)
            }
            UIView.animate(withDuration: 0.25) {
                self.infoView.alpha = 1
                self.descLabel.alpha = 0
                self.moreButton.alpha = 0
            }
        }).disposed(by: disposeBag)
        
        infoView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25) {
                    self.infoView.alpha = 0
                    self.descLabel.alpha = 1
                    self.moreButton.alpha = 1
                }
        }).disposed(by: disposeBag)
        
        nameLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self, let model = self.dataModel  else { return }
            let entityCategory = model.entityCategory ?? ""
            if entityCategory == "1" {
                let detailVc = CompanyBothViewController()
                detailVc.companyName.accept(model.entityName ?? "")
                detailVc.enityId.accept(model.entityId ?? "")
                self.navigationController?.pushViewController(detailVc, animated: true)
            }else {
                let detailVc = PeopleBothViewController()
                detailVc.peopleName.accept(model.entityName ?? "")
                detailVc.personId.accept(model.entityId ?? "")
                self.navigationController?.pushViewController(detailVc, animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func goRiskInfoVc(from model: DataModel) {
        let entityCategory = model.entityCategory ?? ""
        if entityCategory == "1" {
            let companyRiskVc = CompanyRiskDetailViewController()
            companyRiskVc.name = model.entityName ?? ""
            companyRiskVc.enityId = model.entityId ?? ""
            self.navigationController?.pushViewController(companyRiskVc, animated: true)
        }else {
            let peopleRiskVc = PeopleRiskDetailViewController()
            peopleRiskVc.name = model.entityName ?? ""
            peopleRiskVc.personId = model.entityId ?? ""
            self.navigationController?.pushViewController(peopleRiskVc, animated: true)
        }
    }

}

extension JudgmentDebtorDetailViewController {
    
    private func getDetailInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["personId": personId,
                    "orgId": orgId,
                    "riskType": riskType,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: pageUrl,
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                guard let self = self, let model = success.data else { return }
                let total = model.tableInfo?.total ?? 0
                self.dataModel = model
                if success.code == 200 {
                    uiInfoWithModel(from: model)
                    if pageNum == 1 {
                        self.modelArray.removeAll()
                    }
                    pageNum += 1
                    let rows = model.tableInfo?.rows ?? []
                    self.modelArray.append(contentsOf: rows)
                    if self.modelArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func uiInfoWithModel(from model: DataModel) {
        let name = model.entityName ?? ""
        let logoColor = model.logoColor ?? ""
        ctImageView.image = UIImage.imageOfText(name, size: (45, 45), bgColor: UIColor.init(cssStr: logoColor) ?? .random())
        nameLabel.text = name
        let resume = model.resume ?? ""
        descLabel.attributedText = GetRedStrConfig.getRedStr(from: resume, fullText: "简介: \(resume)", colorStr: "#333333", font: .regularFontOfSize(size: 13))

        //风险数据
        self.oneRiskView.namelabel.text = "经营风险"
        if let model = model.riskTracking?.operationRisk  {
            let count = model.totalRiskCnt ?? ""
            let descStr = model.riskDetail ?? ""
            self.oneRiskView.numLabel.text = count
            self.oneRiskView.descLabel.text = descStr
        }
        
        self.twoRiskView.namelabel.text = "法律风险"
        if let model = model.riskTracking?.lawRisk {
            let count = model.totalRiskCnt ?? ""
            let descStr = model.riskDetail ?? ""
            self.twoRiskView.numLabel.text = count
            self.twoRiskView.descLabel.text = descStr
        }
        
        self.threeRiskView.namelabel.text = "财务风险"
        if let model = model.riskTracking?.financeRisk  {
            let count = model.totalRiskCnt ?? ""
            let descStr = model.riskDetail ?? ""
            self.threeRiskView.numLabel.text = count
            self.threeRiskView.descLabel.text = descStr
        }

        self.fourRiskView.namelabel.text = "舆情风险"
        if let model = model.riskTracking?.opinionRisk  {
            let count = model.totalRiskCnt ?? ""
            let descStr = model.riskDetail ?? ""
            self.fourRiskView.numLabel.text = count
            self.fourRiskView.descLabel.text = descStr
        }
        
        let attributedString = NSMutableAttributedString(string: "简介: \(resume)")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        infoView.desLabel.attributedText = attributedString
        
    }
    
}

extension JudgmentDebtorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let count = String(self.dataModel?.tableInfo?.total ?? 0)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条信息", font: .regularFontOfSize(size: 12))
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
        cell.namelabel.text = model.caseName ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelArray[indexPath.row]
        let pageUrl = base_url + (model.detailUrl ?? "")
        self.pushWebPage(from: pageUrl)
    }
}

