//
//  FocusSearchViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/26.
//

import UIKit
import RxRelay
import RxSwift

class SearchFocusCell: BaseViewCell {
    
    var block: ((rowsModel, UIButton) -> Void)?
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .regularFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#666666")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        return focusBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(focusBtn)
        contentView.addSubview(lineView)
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.left.equalToSuperview().offset(11)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(8)
            make.height.equalTo(20)
        }
        
        focusBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 46, height: 15))
        }
        
        lineView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        model.subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model  else { return }
            self.icon.image = UIImage.imageOfText(model.entityName ?? "", size: (20, 20), bgColor: .random(), textColor: .white, cornerRadius: 2)
            self.nameLabel.text = model.entityName
            if model.follow == false {
                self.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }else {
                self.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }
        }).disposed(by: disposeBag)
       
        focusBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let mode1 = self.model.value {
                self.block?(mode1, self.focusBtn)
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FocusSearchViewController: WDBaseViewController {
    
    var keyWords: String = ""
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "添加关注"
        return headView
    }()
    
    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView()
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.image = UIImage(named: "home_header_search")
        return searchIcon
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton()
        clickBtn.setTitle("取消", for: .normal)
        clickBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        clickBtn.setTitleColor(UIColor.init(cssStr: "#242424"), for: .normal)
        return clickBtn
    }()
    
    lazy var leftView: UIView = {
        let leftView = UIView(frame: CGRectMake(0, 0, 33, 33))
        let icon = UIImageView()
        icon.frame = CGRectMake(9, 9, 15, 15)
        icon.image = UIImage(named: "searchiconf")
        leftView.addSubview(icon)
        return leftView
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        searchTx.backgroundColor = .init(cssStr: "#F5F5F5")
        searchTx.font = .regularFontOfSize(size: 13)
        searchTx.textColor = .init(cssStr: "#666666")
        searchTx.clearButtonMode = .whileEditing
        searchTx.returnKeyType = .search
        searchTx.placeholder = "请输入企业名称"
        searchTx.layer.cornerRadius = 3
        searchTx.layer.borderWidth = 0.5
        searchTx.layer.borderColor = UIColor.init(cssStr: "#E2E2E2")?.cgColor
        searchTx.leftView = leftView
        searchTx.leftViewMode = .always
        searchTx.becomeFirstResponder()
        return searchTx
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        return coverView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(SearchFocusCell.self, forCellReuseIdentifier: "SearchFocusCell")
        return tableView
    }()
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(searchView)
        view.addSubview(coverView)
        searchView.addSubview(searchTx)
        coverView.addSubview(tableView)
        searchView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(51)
            make.top.equalTo(headView.snp.bottom).offset(1)
        }
        searchTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.center.equalToSuperview()
            make.height.equalTo(33)
        }
        coverView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(4)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                self?.keyWords = keywords
                self?.searchInfo()
        }).disposed(by: disposeBag)
        
        modelArray.compactMap { $0 }.asObservable().bind(to: tableView.rx.items(cellIdentifier: "SearchFocusCell", cellType: SearchFocusCell.self)) { row, model, cell in
            cell.model.accept(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            let follow = model.follow ?? false
            cell.block = { [weak self] model, btn in
                if follow {
                    self?.deleteFocusInfo(from: btn, model: model)
                }else {
                    self?.addFocusInfo(from: btn, model: model)
                }
            }
        }.disposed(by: disposeBag)
        
        self.addNodataView(from: coverView)
        
    }

}

extension FocusSearchViewController {
    
    private func searchInfo() {
        let dict = ["keywords": self.keyWords]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/follow/searchEntity", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let model = success.data, let modelArray = model.data, modelArray.count > 0 {
                    self?.modelArray.accept(modelArray)
                    self?.emptyView.isHidden = true
                }else {
                    self?.modelArray.accept([])
                    self?.emptyView.isHidden = false
                }
                break
            case .failure(_):
                self?.modelArray.accept([])
                self?.emptyView.isHidden = false
                break
            }
        }
    }
    
    //添加关注
    func addFocusInfo(from btn: UIButton, model: rowsModel) {
        let man = RequestManager()
        let dict = ["entityId": model.entityId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict, pageUrl: "/operation/follow/save", method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                model.follow = true
                btn.setImage(UIImage(named: "havefocusimage"), for: .normal)
//                self.searchInfo()
                ToastViewConfig.showToast(message: "关注成功")
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    func deleteFocusInfo(from btn: UIButton, model: rowsModel) {
        ToastViewConfig.showToast(message: "暂不支持!")
    }
    
}
