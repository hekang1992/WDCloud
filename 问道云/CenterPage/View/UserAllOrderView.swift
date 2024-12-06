//
//  UserAllOrderView.swift
//  问道云
//
//  Created by 何康 on 2024/12/5.
//

import UIKit
import RxRelay
import RxDataSources

class UserAllOrderView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OrderListViewCell.self, forCellReuseIdentifier: "OrderListViewCell")
        return tableView
    }()
    
    lazy var filterView: UIView = {
        let filterView = UIView()
        filterView.backgroundColor = .random()
        return filterView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filterView)
        addSubview(tableView)
        filterView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(41.5)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        
        model.asObservable().compactMap { $0?.rows }.asObservable().bind(to: tableView.rx.items(cellIdentifier: "OrderListViewCell", cellType: OrderListViewCell.self)) { row, model, cell in
            cell.model.accept(model)
            cell.backgroundColor = .white
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserAllOrderView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}
