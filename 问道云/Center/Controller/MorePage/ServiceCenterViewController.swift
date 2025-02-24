//
//  ServiceCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/14.
//

import UIKit

class ServiceCenterViewController: WDBaseViewController {
    
    var buttons: [UIButton] = []
    
    var modelArray: [itemsModel] = []
    
    var listArray: [itemsModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "客服中心"
        return headView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "自助服务"
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.textAlignment = .left
        oneLabel.font = .mediumFontOfSize(size: 14)
        return oneLabel
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "shujuimage")
        oneImageView.isUserInteractionEnabled = true
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "tianjiaqiyeimage")
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.image = UIImage(named: "shengqingkaipimge")
        threeImageView.isUserInteractionEnabled = true
        return threeImageView
    }()
    
    lazy var fourImageView: UIImageView = {
        let fourImageView = UIImageView()
        fourImageView.image = UIImage(named: "yijianfankuimge")
        fourImageView.isUserInteractionEnabled = true
        return fourImageView
    }()
    
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.backgroundColor = .white
        return threeView
    }()
    
    lazy var queLabel: UILabel = {
        let queLabel = UILabel()
        queLabel.text = "常见问题"
        queLabel.textColor = .init(cssStr: "#333333")
        queLabel.textAlignment = .left
        queLabel.font = .mediumFontOfSize(size: 14)
        return queLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ServiceCenterViewCell.self, forCellReuseIdentifier: "ServiceCenterViewCell")
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
        view.addSubview(oneView)
        oneView.addSubview(oneLabel)
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.height.equalTo(32)
        }
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        view.addSubview(twoView)
        twoView.addSubview(oneImageView)
        twoView.addSubview(twoImageView)
        twoView.addSubview(threeImageView)
        twoView.addSubview(fourImageView)
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(150.pix())
        }
        
        oneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(13.5)
            make.size.equalTo(CGSize(width: 170.pix(), height: 62.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-13.5)
            make.size.equalTo(CGSize(width: 170.pix(), height: 62.pix()))
        }
        threeImageView.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(13.5)
            make.size.equalTo(CGSize(width: 170.pix(), height: 62.pix()))
        }
        fourImageView.snp.makeConstraints { make in
            make.top.equalTo(twoImageView.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-13.5)
            make.size.equalTo(CGSize(width: 170.pix(), height: 62.pix()))
        }
        
        view.addSubview(threeView)
        threeView.addSubview(queLabel)
        threeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom).offset(5)
            make.height.equalTo(32)
        }
        queLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(threeView.snp.bottom).offset(1)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(1)
        }
        
        oneImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let dataVc = DataErrorCorrectionViewController()
                self?.navigationController?.pushViewController(dataVc, animated: true)
            }).disposed(by: disposeBag)
        
        twoImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let dataVc = AddCompanyViewController()
                self?.navigationController?.pushViewController(dataVc, animated: true)
            }).disposed(by: disposeBag)
        
        threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let ticketVc = MyTicketViewController()
                self?.navigationController?.pushViewController(ticketVc, animated: true)
            }).disposed(by: disposeBag)
        
        fourImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let opinionVc = OpinionCenterViewController()
                self?.navigationController?.pushViewController(opinionVc, animated: true)
            }).disposed(by: disposeBag)
        getMessageInfo()
    }
    
}

extension ServiceCenterViewController {
    
    private func getMessageInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/operationQuestion/grouplist",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let modelArray = success.data?.items ?? []
                    self?.modelArray = modelArray
                    self?.refreshUI(from: modelArray)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func refreshUI(from modelArray: [itemsModel]) {
        var previousButton: UIButton?
        for (index, model) in modelArray.enumerated() {
            // 创建按钮
            let button = UIButton(type: .custom)
            button.setTitle("\(model.title ?? "") \(model.total ?? 0)", for: .normal)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
            button.titleLabel?.font = .regularFontOfSize(size: 12)
            button.layer.cornerRadius = 2
            scrollView.addSubview(button)
            button.tag = index + 100 // 设置 tag 以便区分按钮
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // 添加点击事件
            buttons.append(button) // 将按钮添加到数组中
            // 设置按钮的约束
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(75)
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).offset(9)
                } else {
                    make.left.equalToSuperview().offset(9)
                }
            }
            previousButton = button
            if index == modelArray.count - 1 {
                button.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-5)
                }
            }
            buttonTapped(buttons.first ?? UIButton())
        }
    }
    
    //按钮点击方法
    @objc func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        // 设置被点击按钮的样式
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
        self.listArray = self.modelArray[sender.tag - 100].items ?? []
        self.tableView.reloadData()
    }
    
}

extension ServiceCenterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.listArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCenterViewCell", for: indexPath) as! ServiceCenterViewCell
        cell.selectionStyle = .none
        cell.model.accept(model)
        if indexPath.row <= 2 {
            cell.numLabel.textColor = .init(cssStr: "#FF7D00")
        }else {
            cell.numLabel.textColor = .init(cssStr: "#999999")
        }
        cell.numLabel.text = "\(indexPath.row + 1)."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.listArray[indexPath.row]
        let detailVc = ServiceCenterDetailViewController()
        detailVc.itemModel.accept(model)
        self.navigationController?.pushViewController(detailVc, animated: true)
    }

}
