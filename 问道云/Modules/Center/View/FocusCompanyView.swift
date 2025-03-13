//
//  FocusCompanyView.swift
//  问道云
//
//  Created by Andrew on 2024/12/23.
//

import UIKit
import RxRelay
import RxDataSources

//struct SectionModel {
//    var header: String
//    var items: [customerFollowListModel]
//    var isExpanded: Bool  // 标记 Section 是否展开
//    init(header: String, items: [customerFollowListModel], isExpanded: Bool = false) {
//        self.header = header
//        self.items = items
//        self.isExpanded = isExpanded
//    }
//}

//extension SectionModel: SectionModelType {
//    typealias Item = customerFollowListModel
//    init(original: SectionModel, items: [customerFollowListModel]) {
//        self = original
//        self.items = items
//    }
//}

class FocusCompanyView: BaseView {
    
    var modelBlock: ((customerFollowListModel) -> Void)?
    
    var isSectionCollapsed: [Bool] = []
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    let isDeleteMode = BehaviorRelay<Bool>(value: false) // 控制是否是删除模式
    
    var selectedIndexPaths = [IndexPath]() // 存储选中的IndexPath
    
    var selectedDataIds = [String]() // 存储选中的id
    
    //    private var arrayRelay = BehaviorRelay<[SectionModel]>(value: [])
    
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
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitle("管理", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 12)
        nextBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return nextBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(FocusCompanyViewNormalCell.self, forCellReuseIdentifier: "FocusCompanyViewNormalCell")
        tableView.register(FocusCompanyEditViewCell.self, forCellReuseIdentifier: "FocusCompanyEditViewCell")
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
        addBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        addBtn.layoutButtonEdgeInsets(style: .left, space: 6)
        addBtn.backgroundColor = .white
        return addBtn
    }()
    
    lazy var footerView: FocusFooterView = {
        let footerView = FocusFooterView()
        return footerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(16.5)
        }
        
        addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.right).offset(4)
            make.centerY.equalTo(descLabel.snp.centerY)
            make.height.equalTo(16.5)
        }
        
        addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel.snp.centerY)
            make.right.equalToSuperview().offset(-19)
            make.size.equalTo(CGSize(width: 26, height: 18))
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 164)
        }
        
        addSubview(addBtn)
        addSubview(footerView)
        addBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
        
        dataModel.asObservable().subscribe(onNext: { [weak self] model in
            self?.modelArray.accept(model?.rows ?? [])
        }).disposed(by: disposeBag)
        
        modelArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            self.isSectionCollapsed = Array(repeating: true, count: modelArray.count)
        }).disposed(by: disposeBag)
        
        footerView.allBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let allCount = self.dataModel.value?.total
            let selectCount = self.selectedIndexPaths.count
            if selectCount == allCount {//全选了
                footerView.allBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
                self.selectedIndexPaths.removeAll()
                self.selectedDataIds.removeAll()
                self.footerView.cancellabel.text = ""
                self.footerView.movelabel.text = ""
            }else {
                //没有全选
                footerView.allBtn.setImage(UIImage(named: "Checkb_sel"), for: .normal)
                self.selectedIndexPaths.removeAll()
                self.selectedDataIds.removeAll()
                let numberOfSections = tableView.numberOfSections
                for section in 0..<numberOfSections {
                    let numberOfRows = tableView.numberOfRows(inSection: section)
                    let model = self.modelArray.value[section]
                    for row in 0..<numberOfRows {
                        let indexPath = IndexPath(row: row, section: section)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        let datasid = model.customerFollowList?[row].dataid
                        self.selectedDataIds.append(datasid ?? "")
                        self.selectedIndexPaths.append(indexPath)
                    }
                }
                let count = String(self.selectedIndexPaths.count)
                self.footerView.cancellabel.text = count
                self.footerView.movelabel.text = count
            }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        //        modelArray.subscribe(onNext: { [weak self] modelArray in
        //            let sections = modelArray.enumerated().map { index, model -> SectionModel in
        //                let numStr = String(format: "%@", "\(model.groupname ?? "")(\(model.customerFollowList?.count ?? 0))")
        //                return SectionModel(header: numStr, items: model.customerFollowList ?? [], isExpanded: false)
        //            }
        //            self?.arrayRelay.accept(sections)
        //        }).disposed(by: disposeBag)
        //
        //        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
        //            configureCell: { dataSource, tableView, indexPath, rowModel in
        //                let section = dataSource[indexPath.section]
        //                if section.isExpanded {
        //                    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        //                    cell.textLabel?.text = rowModel.followtargetname
        //                    return cell
        //                } else {
        //                    return UITableViewCell()
        //                }
        //            }
        //        )
        //
        //        arrayRelay.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        //
        //        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let currentMode = self.isDeleteMode.value
            self.isDeleteMode.accept(!currentMode)
            self.selectedIndexPaths.removeAll()//移除所有选中的cell
            self.selectedDataIds.removeAll()
            for section in 0..<isSectionCollapsed.count {
                isSectionCollapsed[section] = currentMode // 设置为展开
                tableView.reloadSections(IndexSet(integer: section), with: .none) // 刷新每个 section
            }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        self.isDeleteMode.subscribe(onNext: { [weak self] bool in
            self?.nextBtn.setTitle(bool ? "完成" : "管理", for: .normal)
            self?.addBtn.isHidden = bool
            self?.footerView.isHidden = !bool
            self?.footerView.cancellabel.text = ""
            self?.footerView.movelabel.text = ""
            self?.footerView.allBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FocusCompanyView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isDeleteMode.value {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FocusCompanyEditViewCell") as? FocusCompanyEditViewCell
            let model = self.modelArray.value[indexPath.section].customerFollowList?[indexPath.row]
            cell?.model.accept(model)
            cell?.selectionStyle = .none
            let isChecked = self.selectedIndexPaths.contains(indexPath)
            cell?.configureDeleteCell(isChecked: isChecked)
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FocusCompanyViewNormalCell") as? FocusCompanyViewNormalCell
            let model = self.modelArray.value[indexPath.section].customerFollowList?[indexPath.row]
            cell?.model.accept(model)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelArray.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSectionCollapsed[section] ? 0 : (self.modelArray.value[section].customerFollowList?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1 // Section 之间的间距
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F5F5F5")
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        let titleLabel = UILabel()
        //设置section组的标题
        let model = self.modelArray.value[section]
        let numStr = String(format: "%@", "\(model.groupname ?? "")(\(model.customerFollowList?.count ?? 0))")
        titleLabel.text = numStr
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
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "righticonimage")
        headerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        let isCollapsed = isSectionCollapsed[section]
        // 旋转动画
        UIView.animate(withDuration: 0.3, animations: {
            if !isCollapsed {
                iconImageView.transform = iconImageView.transform.rotated(by: .pi / 2)
            } else {
                iconImageView.transform = .identity
            }
        })
        headerView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            isSectionCollapsed[section].toggle()
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }).disposed(by: disposeBag)
        self.isDeleteMode.asObservable().subscribe(onNext: { bool in
            headerView.isUserInteractionEnabled = !bool
        }).disposed(by: disposeBag)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    //点击方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isDeleteMode.value {
            let cell = tableView.cellForRow(at: indexPath) as? FocusCompanyEditViewCell
            let model = self.modelArray.value[indexPath.section]
            //关注ID
            let dataId = model.customerFollowList?[indexPath.row].dataid ?? ""
            if let index = self.selectedIndexPaths.firstIndex(of: indexPath) {
                self.selectedIndexPaths.remove(at: index) //如果已经选中，则取消选中
                self.selectedDataIds.removeAll {
                    $0 == dataId
                }
                cell?.icon.image = UIImage(named: "Check_nor")
                self.footerView.allBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
            } else {
                self.selectedIndexPaths.append(indexPath) // 如果未选中，则添加到选中的数组
                self.selectedDataIds.append(dataId)
                cell?.icon.image = UIImage(named: "Checkb_sel")
            }
            let selectCount = self.selectedIndexPaths.count
            let count = String(selectCount)
            [self.footerView.cancellabel, self.footerView.movelabel].forEach { $0.text = count }
            let allCount = self.dataModel.value?.total
            if allCount != selectCount {
                self.footerView.allBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
            }else {
                self.footerView.allBtn.setImage(UIImage(named: "Checkb_sel"), for: .normal)
            }
        }else {
            if let model = self.modelArray.value[indexPath.section].customerFollowList?[indexPath.row] {
                self.modelBlock?(model)
            }
        }
    }
    
}


class FocusFooterView: BaseView {
    
    lazy var allBtn: UIButton = {
        let allBtn = UIButton(type: .custom)
        allBtn.setTitle("全选", for: .normal)
        allBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
        allBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        allBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
        allBtn.layoutButtonEdgeInsets(style: .left, space: 6)
        return allBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton()
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        cancelBtn.setTitle("取消关注", for: .normal)
        cancelBtn.contentHorizontalAlignment = .right
        cancelBtn.setTitleColor(.init(cssStr: "#FF7D00"), for: .normal)
        return cancelBtn
    }()
    
    lazy var cancellabel: UILabel = {
        let cancellabel = UILabel()
        cancellabel.textColor = UIColor.init(cssStr: "#FF0000")
        cancellabel.textAlignment = .left
        cancellabel.font = .regularFontOfSize(size: 13)
        return cancellabel
    }()
    
    lazy var movebtn: UIButton = {
        let movebtn = UIButton()
        movebtn.contentHorizontalAlignment = .right
        movebtn.titleLabel?.font = .regularFontOfSize(size: 13)
        movebtn.setTitle("移动到", for: .normal)
        movebtn.setTitleColor(.init(cssStr: "#FF7D00"), for: .normal)
        return movebtn
    }()
    
    lazy var movelabel: UILabel = {
        let movelabel = UILabel()
        movelabel.textColor = UIColor.init(cssStr: "#FF0000")
        movelabel.textAlignment = .left
        movelabel.font = .regularFontOfSize(size: 13)
        return movelabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(allBtn)
        addSubview(movelabel)
        addSubview(movebtn)
        addSubview(cancellabel)
        addSubview(cancelBtn)
        
        allBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 55, height: 22))
        }
        movelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(19)
        }
        movebtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(movelabel.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 55, height: 19))
        }
        cancellabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(movebtn.snp.left).offset(-10)
            make.height.equalTo(19)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalTo(cancellabel.snp.left).offset(-8)
            make.size.equalTo(CGSize(width: 65, height: 19))
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
