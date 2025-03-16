//
//  HistoryListView.swift
//  问道云
//
//  Created by Andrew on 2024/12/27.
//

import UIKit
import RxRelay
import Differentiator
import RxDataSources

struct SectionModel {
    var header: String
    var items: [rowsModel]
}

extension SectionModel: SectionModelType {
    typealias Item = rowsModel
    
    init(original: SectionModel, items: [rowsModel]) {
        self = original
        self.items = items
    }
}

class HistoryListView: BaseView {
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var sectionArray = BehaviorRelay<[SectionModel]?>(value: nil)
    
    var modelBlock: ((rowsModel) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HistoryListViewCell.self, forCellReuseIdentifier: "HistoryListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
            configureCell: { (dataSource, tableView, indexPath, model) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryListViewCell", for: indexPath) as? HistoryListViewCell
                cell?.backgroundColor = .clear
                cell?.selectionStyle = .none
                cell?.model.accept(model)
                return cell ?? UITableViewCell()
            },titleForHeaderInSection: { model, int in
                return model.sectionModels[int].header
            }
        )
        
        modelArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self,
                  let models = modelArray,
                  !models.isEmpty else { return }
            let sections = groupRowsByOrderState(rows: models)
            self.sectionArray.accept(sections)
        }).disposed(by: disposeBag)
        
        sectionArray.compactMap{ $0 }.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(rowsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.modelBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HistoryListView {
    
    func groupRowsByOrderState(rows: [rowsModel]) -> [SectionModel] {
        var groupedDict: [String: [rowsModel]] = [:]
        for row in rows {
            guard let state = row.createtime else { continue }
            if groupedDict[state] != nil {
                groupedDict[state]?.append(row)
            } else {
                groupedDict[state] = [row]
            }
        }
        
        // 转换为 SectionModel 数组
        let sections = groupedDict.map { key, value in
            SectionModel(header: key, items: value)
        }
        
        // 根据 header 排序（可选）
        return sections.sorted { $0.header > $1.header }
    }
    
    
}

extension HistoryListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
