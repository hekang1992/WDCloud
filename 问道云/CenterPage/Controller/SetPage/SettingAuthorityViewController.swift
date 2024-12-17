//
//  SettingAuthorityViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//  设置权限页面

import UIKit
import RxRelay
import RxSwift

struct DescModel {
    var title: String
    var descTitle: String
    var text = BehaviorRelay(value: "")
    init(title: String = "", descTitle: String = "") {
        self.title = title
        self.descTitle = descTitle
    }
}

class SettingAuthorityViewController: WDBaseViewController {
    
    let model1 = DescModel(title: "相机权限", descTitle: "用于扫名片、扫码登录等服务")
    let model2 = DescModel(title: "通讯录读取权限", descTitle: "用于人脉雷达识别通讯录访问等服务")
    let model3 = DescModel(title: "通讯录写入权限", descTitle: "用于拨打企业联系电话快速加入通讯录等服务")
    let model4 = DescModel(title: "麦克风权限", descTitle: "用于使用语音搜索等功能")
    let model5 = DescModel(title: "位置权限", descTitle: "用于通过您的当前位置信息政策使用附近企业等功能")
    let model6 = DescModel(title: "文件储存权限", descTitle: "用于保存、上传图片等功能")
    
    var array: [DescModel] = []
    
    var modelArray = BehaviorRelay<[DescModel]>(value: [])
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "隐私权限设置"
        return headView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(AuthViewCell.self, forCellReuseIdentifier: "AuthViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.left.bottom.right.equalToSuperview()
        }
        array.append(model1)
        array.append(model2)
        array.append(model3)
        array.append(model4)
        array.append(model5)
        array.append(model6)
        self.modelArray.accept(array)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        modelArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "AuthViewCell", cellType: AuthViewCell.self)) { row, model, cell in
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.model.accept(model)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DescModel.self).subscribe(onNext: { [weak self] _ in
            self?.openSettings()
        }).disposed(by: disposeBag)
        
    }
    
    
}

extension SettingAuthorityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                    if success {
                        print("成功跳转到设置页面")
                    } else {
                        print("跳转失败")
                    }
                })
            } else {
                print("无法打开设置页面")
            }
        }
    }
    
}


class AuthViewCell: BaseViewCell {
    
    var model = BehaviorRelay<DescModel?>(value: nil)
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 14)
        return namelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#999999")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("去设置", for: .normal)
        btn.titleLabel?.font = .regularFontOfSize(size: 14)
        btn.setTitleColor(UIColor.init(cssStr: "#999999"), for: .normal)
        btn.setImage(UIImage(named: "righticonimage"), for: .normal)
        return btn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(namelabel)
        contentView.addSubview(desclabel)
        contentView.addSubview(btn)
        contentView.addSubview(lineView)
        namelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalToSuperview().offset(12.5)
            make.height.equalTo(20)
        }
        desclabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(namelabel.snp.bottom).offset(3)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-12.5)
        }
        btn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.size.equalTo(CGSize(width: 60, height: 20))
        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            namelabel.text = model.title
            desclabel.text = model.descTitle
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn.layoutButtonEdgeInsets(style: .right, space: 1.5)
    }
    
}

