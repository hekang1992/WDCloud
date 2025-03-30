//
//  AddPropertyCompanyUnioViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/28.
//

import UIKit

class AddPropertyCompanyUnioViewController: WDBaseViewController {
    
    var refreshBlock:(() -> Void)?
    
    var entityId: String = ""
    //名字
    var entityName: String = ""
    //参数
    var connectId: Int = 0
    var dataArray: [rowsModel]?
    
    var model: rowsModel?
    
    var buttons: [UIButton] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "自定义财产关联方"
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "添加自定义财产关联方"
        descLabel.textColor = .init(cssStr: "#333333")
        descLabel.font = .mediumFontOfSize(size: 14)
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView1
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业、人员名称等关键词", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        searchTx.attributedPlaceholder = attrString
        searchTx.font = UIFont.mediumFontOfSize(size: 14)
        searchTx.textColor = UIColor.init(cssStr: "#333333")
        searchTx.clearButtonMode = .whileEditing
        searchTx.layer.cornerRadius = 5
        searchTx.backgroundColor = .init(cssStr: "#F3F3F3")
        searchTx.leftView = UIView(frame: CGRectMake(0, 0, 15, 15))
        searchTx.leftViewMode = .always
        return searchTx
    }()
    
    lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView2
    }()
    
    lazy var descLabel1: UILabel = {
        let descLabel1 = UILabel()
        descLabel1.text = "关联关系"
        descLabel1.textColor = .init(cssStr: "#333333")
        descLabel1.font = .mediumFontOfSize(size: 14)
        return descLabel1
    }()
    
    lazy var lineView3: UIView = {
        let lineView3 = UIView()
        lineView3.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView3
    }()
    
    lazy var lineView4: UIView = {
        let lineView4 = UIView()
        lineView4.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView4
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(mlabel)
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.equalTo(headView.snp.bottom).offset(9.5)
            make.left.equalToSuperview().offset(10)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.height.equalTo(25)
        }
        ctImageView.image = UIImage.imageOfText(entityName, size: (35, 35))
        mlabel.text = entityName
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(ctImageView.snp.bottom).offset(9.5)
        }
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(14.5)
        }
        
        view.addSubview(lineView1)
        lineView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(descLabel.snp.bottom).offset(14)
        }
        
        view.addSubview(searchTx)
        searchTx.snp.makeConstraints { make in
            make.height.equalTo(40.pix())
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView1.snp.bottom).offset(10)
        }
        
        view.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(searchTx.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        view.addSubview(descLabel1)
        view.addSubview(lineView3)
        descLabel1.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.left)
            make.height.equalTo(25)
            make.top.equalTo(lineView2.snp.bottom).offset(14.5)
        }
        lineView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(descLabel1.snp.bottom).offset(14)
            make.height.equalTo(1)
        }
        
        self.searchTx.text = model?.entityName ?? ""
        getMessageInfo()
    }
    
    
}

extension AddPropertyCompanyUnioViewController {
    
    private func getMessageInfo() {
        let dict = ["connectType": 2]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/customer/connect/findConnectTypeList",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let data = success.datas ?? []
                    self?.dataArray = data
                    self?.refreshUI(from: data)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func refreshUI(from modelArray: [rowsModel]) {
        let buttonSpacing = 10
        let buttonHeight = 29
        let buttonWidth = (Int(SCREEN_WIDTH) - 4 * buttonSpacing) / 3
        var previousButton: UIButton?
        for (index, model) in modelArray.enumerated() {
            let button = UIButton()
            buttons.append(button)
            button.setTitle(model.connectName ?? "", for: .normal)
            button.backgroundColor = .init(cssStr: "#F3F3F3")
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            button.layer.cornerRadius = 2
            button.titleLabel?.font = .mediumFontOfSize(size: 13)
            button.tag = 1000 + index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
            
            // 使用 SnapKit 布局
            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                
                // 如果是第一行的第一个按钮（index == 0）
                if index == 0 {
                    make.top.equalTo(lineView3.snp.bottom).offset(12)
                    make.leading.equalToSuperview().offset(buttonSpacing)
                }
                // 如果是当前行的第一个按钮（index % 3 == 0）
                else if index % 3 == 0 {
                    make.top.equalTo(previousButton!.snp.bottom).offset(buttonSpacing)
                    make.leading.equalToSuperview().offset(buttonSpacing)
                }
                // 否则，同一行后续按钮
                else {
                    make.top.equalTo(previousButton!)
                    make.leading.equalTo(previousButton!.snp.trailing).offset(buttonSpacing)
                }
            }
            previousButton = button
        }
        
        if let previousButton = previousButton {
            view.addSubview(lineView4)
            lineView4.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(4)
                make.top.equalTo(previousButton.snp.bottom).offset(18 + buttonSpacing)
            }
        }
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("添加", for: .normal)
        sureBtn.backgroundColor = .init(cssStr: "#547AFF")
        sureBtn.layer.cornerRadius = 3
        view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView4.snp.bottom).offset(10)
            make.height.equalTo(40.pix())
        }
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.addInfo()
        }).disposed(by: disposeBag)
        
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#F3F3F3")
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.init(cssStr: "#FFFFFF"), for: .normal)
        let index = sender.tag - 1000
        let connectId = Int(self.dataArray?[index].eid ?? "0") ?? 0
        self.connectId = connectId
        
    }
    
    private func addInfo() {
        let dict = ["relationId": entityId,
                    "relationName": entityName,
                    "relationType": 1,
                    "beRelationId": model?.entityId ?? 0,
                    "connectId": connectId,
                    "beRelationName": self.searchTx.text ?? "",
                    "beRelationType": "1"] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/customer/relation/add",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.refreshBlock?()
                    ToastViewConfig.showToast(message: "关联成功")
                    self?.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
        
    }
}

