//
//  PropertyLineOneViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/21.
//

import UIKit

class PropertyLineOneViewController: WDBaseViewController {
    
    //ID
    var entityId: String = ""
    //名字
    var entityName: String = ""
    //是否被监控
    var monitor: Bool = false
    //logourl
    var logoUrl: String = ""
    //参数
    var subjectId: String = ""
    var subjectType: String = ""
    var pageIndex: Int = 1
    
    
    var leftTitles: [String] = []
    var rightTitles: [String] = []
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.text = entityName
        return nameLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "scbaogaimge"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "jianknogiamge"), for: .normal)
        twoBtn.setImage(UIImage(named: "yijingjiagnkongimagea"), for: .selected)
        return twoBtn
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#ECF5FF")
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.isSelected = true
        leftBtn.setImage(UIImage(named: "leftiamge_nor"), for: .normal)
        leftBtn.setImage(UIImage(named: "leftimge_sel"), for: .selected)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage(UIImage(named: "rightimge_nor"), for: .normal)
        rightBtn.setImage(UIImage(named: "rightigmge_sel"), for: .selected)
        return rightBtn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(nameLabel)
        logoImageView.kf.setImage(with: URL(string: self.logoUrl), placeholder: UIImage.imageOfText(self.entityName, size: (29, 29)))
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        twoBtn.isSelected = monitor
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 175.pix(), height: 23.pix()))
        }
        
        twoBtn.snp.makeConstraints { make in
            make.left.equalTo(SCREEN_WIDTH - 175.pix() - 10)
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 175.pix(), height: 23.pix()))
        }
        
        view.addSubview(bgView)
        bgView.addSubview(leftBtn)
        bgView.addSubview(rightBtn)
        bgView.addSubview(stackView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(oneBtn.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalToSuperview().offset(8.5)
            make.width.equalTo(84)
            make.height.equalTo(27.5)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.left.equalTo(leftBtn.snp.right).offset(10)
            make.top.equalToSuperview().offset(8.5)
            make.width.equalTo(84)
            make.height.equalTo(27.5)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(leftBtn.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(3.5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        
        getPropertyInfo()
        getZhuiZongInfo()
        
        leftBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            leftBtn.isSelected = true
            rightBtn.isSelected = false
            configure(with: leftTitles)
        }).disposed(by: disposeBag)
        
        rightBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            leftBtn.isSelected = false
            rightBtn.isSelected = true
            configure(with: rightTitles)
        }).disposed(by: disposeBag)
        
        //获取列表数据信息
        getListInfo()
    }
    
}

extension PropertyLineOneViewController {
    
    func configure(with dynamiccontent: [String]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for name in dynamiccontent {
            let infoView = PropertyLineInfoView()
            if let attributedText = name.htmlToAttributedString {
                infoView.nameLabel.attributedText = attributedText
            } else {
                infoView.nameLabel.text = "Failed to parse HTML."
            }
            infoView.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(infoView)
        }
    }
    
}

/** 网络数据请求 */
extension PropertyLineOneViewController {
    
    //获取财产评估信息
    private func getPropertyInfo() {
        let man = RequestManager()
        let dict = ["subjectId": entityId]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findPropertyAssessmentData",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let modelArray = success.datasss {
                        let titles = modelArray.joined(separator: ",").components(separatedBy: ",")
                        configure(with: titles)
                        self.leftTitles = titles
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取财产追踪
    private func getZhuiZongInfo() {
        let man = RequestManager()
        let dict = ["subjectId": entityId,
                    "type": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findDebtCluesDiscoveredData",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let modelArray = success.datasss {
                        let titles = modelArray.joined(separator: ",").components(separatedBy: ",")
                        self.rightTitles = titles
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取财产线索列表信息
    private func getListInfo() {
        let subjectId = entityId
        let subjectType = "1"
        let dict = ["subjectId": subjectId,
                    "subjectType": subjectType,
                    "pageIndex": pageIndex,
                    "pageSize": 10] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findCluePageList",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
