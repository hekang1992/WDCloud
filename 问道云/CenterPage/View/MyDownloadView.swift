//
//  MyDownloadView.swift
//  问道云
//
//  Created by 何康 on 2024/12/12.
//

import UIKit
import RxRelay

class MyDownloadView: BaseView {

    lazy var searchView: MyDownloadSearchView = {
        let searchView = MyDownloadSearchView()
        return searchView
    }()
    
    lazy var filterView: UIView = {
        let filterView = UIView()
        filterView.backgroundColor = .white
        return filterView
    }()
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    let isDeleteMode = BehaviorRelay<Bool>(value: false) // 控制是否是删除模式
    
    var selectBlock: ((rowsModel) -> Void)?//选择
    
    var moreBtnBlock: ((rowsModel) -> Void)?//点击...
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MyDownloadViewNormalCell.self, forCellReuseIdentifier: "MyDownloadViewNormalCell")
        tableView.register(MyDownloadViewEditCell.self, forCellReuseIdentifier: "MyDownloadViewEditCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchView)
        addSubview(filterView)
        addSubview(tableView)
        searchView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(46)
        }
        filterView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(26)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(filterView.snp.bottom)
        }
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        modelArray.asObservable().bind(to: tableView.rx.items) { [weak self] tableView, index, model in
            guard let self = self else { return UITableViewCell() }
            let indexPath = IndexPath(row: index, section: 0)
            if !self.isDeleteMode.value {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyDownloadViewNormalCell", for: indexPath) as! MyDownloadViewNormalCell
                cell.model.accept(model)
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.block = { [weak self] model in
                    if let self = self {
                        self.moreBtnBlock?(model)
                    }
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyDownloadViewEditCell", for: indexPath) as! MyDownloadViewEditCell
                cell.model = model
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                return cell
            }
        }.disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(rowsModel.self).subscribe(onNext: { [weak self] model in
            guard let self = self else { return }
            self.selectBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyDownloadView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}
