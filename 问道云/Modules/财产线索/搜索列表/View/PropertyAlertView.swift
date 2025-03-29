//
//  PropertyAlertView.swift
//  问道云
//
//  Created by Andrew on 2025/3/24.
//

import UIKit

class PropertyAlertView: BaseView {
    
    var selectedIndexPaths = [IndexPath]()
    var selectedModels = [[String: Any]]()
    var modelArray: [monitorRelationVOListModel]?
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.isUserInteractionEnabled = true
        grayView.backgroundColor = .black.withAlphaComponent(0.45)
        return grayView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        return nameLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PropertyAlertViewTableViewCell.self, forCellReuseIdentifier: "PropertyAlertViewTableViewCell")
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
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        cancelBtn.setTitle("取 消", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        cancelBtn.layer.cornerRadius = 3
        return cancelBtn
    }()
    
    lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(type: .custom)
        saveBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        saveBtn.setTitle("监 控", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        saveBtn.layer.cornerRadius = 3
        return saveBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(grayView)
        addSubview(bgView)
        bgView.addSubview(ctImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(tableView)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(saveBtn)
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(450)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.height.equalTo(22)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-55.pix())
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5.pix())
            make.size.equalTo(CGSize(width: 173.pix(), height: 48.pix()))
        }
        saveBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5.pix())
            make.size.equalTo(CGSize(width: 173.pix(), height: 48.pix()))
        }
        grayView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        saveBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let man = RequestManager()
            let newDictArray = selectedModels.map { dict in
                var newDict = dict
                return newDict
            }
            man.requestArrayAPI(array: newDictArray,
                                pageUrl: "/entity/monitor/relation",
                                method: .post) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "监控成功")
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PropertyAlertView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textAlignment = .left
        
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(selectedIndexPaths.count)", fullText: "同时监控财产关联方\(selectedIndexPaths.count)", font: UIFont.regularFontOfSize(size: 12))
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(20)
        }
        
        let qBtn = UIButton(type: .custom)
        qBtn.setTitle("全选\(self.selectedIndexPaths.count)", for: .normal)
        qBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        qBtn.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        qBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        qBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        headView.addSubview(qBtn)
        qBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 60.pix(), height: 20.pix()))
        }
        qBtn.layoutButtonEdgeInsets(style: .right, space: 10)
        
        let selectCount = self.selectedIndexPaths.count
        if selectCount == self.modelArray?.count {
            qBtn.isSelected = true
        }else {
            qBtn.isSelected = false
        }
        
        qBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if qBtn.isSelected {
                if let modelArray = self.modelArray {
                    for (index, model) in modelArray.enumerated() {
                        model.select = false
                    }
                    self.selectedModels.removeAll()
                    self.selectedIndexPaths.removeAll()
                }
                self.tableView.reloadData()
            }else {
                if let modelArray = self.modelArray {
                    self.selectedModels.removeAll()
                    self.selectedIndexPaths.removeAll()
                    for (index, model) in modelArray.enumerated() {
                        model.select = true
                        let indexPath = NSIndexPath(row: index, section: 0)
                        self.selectedIndexPaths.append(indexPath as IndexPath)
                        self.selectedModels.append(model.toDictionary())
                    }
                }
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyAlertViewTableViewCell", for: indexPath) as! PropertyAlertViewTableViewCell
        cell.selectionStyle = .none
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = modelArray?[indexPath.row] {
            if let index = self.selectedIndexPaths.firstIndex(of: indexPath) {
                self.selectedIndexPaths.remove(at: index) //如果已经选中，则取消选中
                self.selectedModels.remove(at: index)
                model.select = false
            } else {
                self.selectedModels.append(model.toDictionary())
                self.selectedIndexPaths.append(indexPath)
                model.select = true
            }
            tableView.reloadData()
        }
    }
    
}
