//
//  FocusCompanyView.swift
//  问道云
//
//  Created by 何康 on 2024/12/23.
//

import UIKit
import RxRelay
import RxDataSources

struct SectionModel {
    var header: String
    var items: [customerFollowListModel]
    var isExpanded: Bool  // 标记 Section 是否展开
    init(header: String, items: [customerFollowListModel], isExpanded: Bool = false) {
        self.header = header
        self.items = items
        self.isExpanded = isExpanded
    }
}

extension SectionModel: SectionModelType {
    typealias Item = customerFollowListModel
    init(original: SectionModel, items: [customerFollowListModel]) {
        self = original
        self.items = items
    }
}

class FocusCompanyView: BaseView {
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    private var arrayRelay = BehaviorRelay<[SectionModel]>(value: [])
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "已关注"
        descLabel.textColor = .init(cssStr: "#666666")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 12)
        return descLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = "0"
        numLabel.textColor = .init(cssStr: "#FF7D00")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        return numLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        //        tableView.register(ALDFocusEditQiyeViewCell.self, forCellReuseIdentifier: "ALDFocusEditQiyeViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "plus-circle"), for: .normal)
        addBtn.setTitle("新建分组", for: .normal)
        addBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        addBtn.titleLabel?.font = .mediumFontOfSize(size: 13)
        addBtn.layoutButtonEdgeInsets(style: .left, space: 6)
        addBtn.backgroundColor = .white
        return addBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(6.5)
            make.height.equalTo(16.5)
        }
        
        addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.right).offset(4)
            make.top.equalToSuperview().offset(6.5)
            make.height.equalTo(16.5)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 164)
        }
        
        addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
        
        modelArray.subscribe(onNext: { [weak self] modelArray in
            let sections = modelArray.enumerated().map { index, model -> SectionModel in
                let numStr = String(format: "%@", "\(model.groupname ?? "")(\(model.customerFollowList?.count ?? 0))")
                return SectionModel(header: numStr, items: model.customerFollowList ?? [], isExpanded: false)
            }
            self?.arrayRelay.accept(sections)
        }).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { dataSource, tableView, indexPath, rowModel in
                let section = dataSource[indexPath.section]
                if section.isExpanded {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
                    cell.textLabel?.text = rowModel.followtargetname
                    return cell
                } else {
                    return UITableViewCell()
                }
            }
        )
        
        arrayRelay.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FocusCompanyView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Section 之间的间距
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        let titleLabel = UILabel()
        //设置section组的标题
        titleLabel.text = arrayRelay.value[section].header
        titleLabel.textAlignment = .left
        titleLabel.font = .mediumFontOfSize(size: 14)
        titleLabel.textColor = .init(cssStr: "#333333")
        headerView.addSubview(titleLabel)
        headerView.addSubview(lineView)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        headerView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            var updatedSections = arrayRelay.value
            updatedSections[section].isExpanded.toggle()
            arrayRelay.accept(updatedSections)
        }).disposed(by: disposeBag)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}
