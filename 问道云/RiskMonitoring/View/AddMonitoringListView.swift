//
//  AddMonitoringListView.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//

import UIKit
import RxRelay

class AddMonitoringListView: BaseView {
    
    var block: ((riskMonitorPersonDtoListModel, MonitoringListView) -> Void)?
    
    var modelArray: [riskMonitorPersonDtoListModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for model in modelArray {
                let listView = MonitoringListView()
                listView.nameLabel.text = model.personName ?? ""
                listView.tagsLabel.text = model.positions?.joined(separator: ",")
                listView.checkButton.isSelected = model.isClickMonitoring
                listView.setContentHuggingPriority(.defaultLow, for: .vertical)
                stackView.addArrangedSubview(listView)
                listView.checkButton.rx.tap.subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.block?(model, listView)
                }).disposed(by: disposeBag)
            }
        }
    }
    
    //标题
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .init(cssStr: "#547AFF")
        titleLabel.font = .mediumFontOfSize(size: 13)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.backgroundColor = .clear
        view.spacing = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(stackView)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(-12)
            make.top.equalTo(0)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MonitoringListView: UIView {
    
    //名字
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 13)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    //标签
    lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.textColor = .init(cssStr: "#666666")
        tagsLabel.font = .mediumFontOfSize(size: 13)
        tagsLabel.textAlignment = .left
        return tagsLabel
    }()
    
    lazy var checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setImage(UIImage(named: "addjiankongqiye"), for: .selected)
        checkButton.setImage(UIImage(named: "agreenorimage"), for: .normal)
        checkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        checkButton.contentEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        return checkButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(tagsLabel)
        addSubview(checkButton)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        checkButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.right.equalTo(checkButton.snp.left).offset(-6)
            make.centerY.equalToSuperview()
        }
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
