//
//  CommonHotsView.swift
//  问道云
//
//  Created by 何康 on 2025/3/31.
//

import UIKit
import SkeletonView

class CommonHotsView: BaseView {
    
    var tagArray: [String] = []
    
    var companyModel = CompanyModel(isOpenTag: false)
    
    var tagClickBlock: ((UILabel) -> Void)?
    
    var cellBlock: ((Int, rowsModel) -> Void)?
    
    //删除最近搜索
    var deleteBlock: (() -> Void)?
    //删除浏览历史
    var deleteHistoryBlock: (() -> Void)?
    
    var modelArray: [[rowsModel]]? {
        didSet {
            DispatchQueue.main.asyncAfter(delay: 0.25) {
                self.tableView.hideSkeleton()
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.isHidden = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "最近搜索"
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textColor = UIColor.init(cssStr: "#333333")
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        return lineView1
    }()
    
    lazy var tagScrollView: UIScrollView = {
        let tagScrollView = UIScrollView()
        tagScrollView.backgroundColor = .white
        return tagScrollView
    }()
    
    lazy var headlineView: UIView = {
        let headlineView = UIView()
        headlineView.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        return headlineView
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(UIImage(named: "delete_icon"), for: .normal)
        return deleteBtn
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CommonHotsViewCell.self, forCellReuseIdentifier: "CommonHotsViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(descLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(tagScrollView)
        bgView.addSubview(lineView1)
        bgView.addSubview(deleteBtn)
        addSubview(tableView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
        tagScrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.height.equalTo(25)
            make.bottom.equalToSuperview().offset(-5)
        }
        lineView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(tagScrollView.snp.bottom).offset(5)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel.snp.centerY)
            make.right.equalToSuperview().offset(-2)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        //删除最近搜索
        deleteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.deleteBlock?()
        }).disposed(by: disposeBag)
        
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - SkeletonTableViewDataSource
extension CommonHotsView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CommonHotsViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

extension CommonHotsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .init(cssStr: "#F5F5F5")
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        let emptyIndices = self.modelArray?.enumerated()
            .filter { $0.element.isEmpty }
            .map { $0.offset } ?? []
        if emptyIndices.count == 2 {
            return nil
        }else if emptyIndices.count == 1 {
            if emptyIndices.contains(1) {
                title = "浏览历史"
            }else {
                title = "热门搜索"
            }
        }else {
            if section == 0 {
                title = "浏览历史"
            }else {
                title = "热门搜索"
            }
        }
        
        let headView = UIView()
        headView.backgroundColor = .white
        let label = UILabel()
        label.text = title
        label.textColor = .init(cssStr: "#333333")
        label.font = .regularFontOfSize(size: 13)
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(25)
        }
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        headView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        if title == "浏览历史" {
            let deleteBtn = UIButton(type: .custom)
            deleteBtn.setImage(UIImage(named: "delete_icon"), for: .normal)
            headView.addSubview(deleteBtn)
            deleteBtn.snp.makeConstraints { make in
                make.centerY.equalTo(label.snp.centerY)
                make.right.equalToSuperview().offset(-2)
                make.size.equalTo(CGSize(width: 30, height: 30))
            }
            deleteBtn.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.deleteHistoryBlock?()
            }).disposed(by: disposeBag)
        }
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let filteredArray = self.modelArray?.filter { !$0.isEmpty }
        return filteredArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredArray = self.modelArray?.filter { !$0.isEmpty }
        return filteredArray?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredArray = self.modelArray?.filter { !$0.isEmpty }
        let model = filteredArray?[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonHotsViewCell", for: indexPath) as! CommonHotsViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.model = model
        return cell
    }
    
    //点击tableviewcell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredArray = self.modelArray?.filter { !$0.isEmpty }
        if let model = filteredArray?[indexPath.section][indexPath.row] {
            self.cellBlock?(indexPath.section, model)
        }
    }
    
}

extension CommonHotsView {
    
    func setupScrollView() {
        // 清理子视图
        for view in tagScrollView.subviews {
            view.removeFromSuperview()
        }
        
        let maxWidth = SCREEN_WIDTH - 20 // 标签展示最大宽度（左右各 20 的边距）
        let openButtonWidth: CGFloat = 45 // 展开按钮宽度
        let buttonHeight: CGFloat = 25 // 标签高度
        let buttonSpacing: CGFloat = 10 // 标签之间的间距
        var numberOfLine: CGFloat = 1 // 标签总行数
        var lastRight: CGFloat = 0 // 标签的左边距
        let isOpen = companyModel.isOpenTag // 标签展开或者收起
        
        // 创建展开/收起按钮
        let openButton = UIButton(type: .custom)
        openButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        openButton.backgroundColor = UIColor(cssStr: "#5491FF")
        openButton.setTitle("展开", for: .normal)
        openButton.setTitleColor(UIColor(cssStr: "#ECF2FF"), for: .normal)
        openButton.layer.masksToBounds = true
        openButton.layer.cornerRadius = 4
        openButton.layer.borderWidth = 0.5
        openButton.layer.borderColor = UIColor(cssStr: "#5491FF")?.cgColor
        openButton.addTarget(self, action: #selector(didOpenTags), for: .touchUpInside)
        if isOpen {
            openButton.setTitle("收起", for: .normal)
        }
        
        // 计算需要多少行显示所有标签（不考虑展开按钮）
        var testNumberOfLine: CGFloat = 1
        var testLastRight: CGFloat = 0
        for tags in tagArray {
            let tag = "\(tags)"
            let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
            let width = titleSize.width + 10
            if width + testLastRight > maxWidth {
                testNumberOfLine += 1
                testLastRight = 0
            }
            testLastRight += width + buttonSpacing
        }
        
        // 判断是否需要展开/收起功能（超过2行才需要）
        let needsExpandCollapse = testNumberOfLine > 2
        
        var tagArrayToShow = [String]()
        if needsExpandCollapse {
            if !isOpen {
                // 收起状态，只显示前两行的内容
                var currentLine: CGFloat = 1
                var currentRight: CGFloat = 0
                var p = 0
                
                for tags in tagArray {
                    let tag = "\(tags)"
                    let titleSize = (tag as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
                    let width = titleSize.width + 10
                    
                    if width + currentRight > maxWidth {
                        currentLine += 1
                        currentRight = 0
                        if currentLine > 2 {
                            break
                        }
                    }
                    
                    currentRight += width + buttonSpacing
                    p += 1
                }
                
                for i in 0..<p - 1 {
                    tagArrayToShow.append(tagArray[i])
                }
                tagArrayToShow.append("展开")
            } else {
                // 展开状态，显示全部
                tagArrayToShow.append(contentsOf: tagArray)
                tagArrayToShow.append("收起")
            }
        } else {
            // 不超过2行，直接显示全部
            tagArrayToShow.append(contentsOf: tagArray)
        }
        
        // 插入标签和展开按钮
        for tags in tagArrayToShow {
            if tags == "展开" || tags == "收起" {
                // 检查当前行剩余宽度是否足够放下收起按钮
                if lastRight + openButtonWidth > maxWidth {
                    // 另起一行
                    numberOfLine += 1
                    lastRight = 0
                }
                
                tagScrollView.addSubview(openButton)
                openButton.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing) + 3)
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(openButtonWidth)
                }
                lastRight += openButtonWidth + buttonSpacing
            } else {
                let lab = UILabel()
                lab.isUserInteractionEnabled = true
                lab.font = UIFont.systemFont(ofSize: 14)
                lab.textColor = UIColor(cssStr: "#666666")
                lab.backgroundColor = UIColor(cssStr: "#F3F3F3")
                lab.layer.masksToBounds = true
                lab.layer.cornerRadius = 4
                lab.textAlignment = .center
                lab.text = "\(tags)"
                lab.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.tagClickBlock?(lab)
                }).disposed(by: disposeBag)
                tagScrollView.addSubview(lab)
                
                let titleSize = (lab.text! as NSString).size(withAttributes: [.font: lab.font!])
                let width = titleSize.width + 10  // 增加左右 padding
                
                if width + lastRight > maxWidth {
                    numberOfLine += 1
                    lastRight = 0
                }
                
                lab.snp.remakeConstraints { make in
                    make.left.equalTo(lastRight)
                    make.top.equalTo((numberOfLine - 1) * (buttonHeight + buttonSpacing) + 3)
                    make.height.equalTo(buttonHeight)
                    make.width.equalTo(width)
                }
                
                lastRight += width + buttonSpacing
            }
        }
        
        // 设置 tagScrollView 的约束
        tagScrollView.snp.updateConstraints { make in
            make.height.equalTo(numberOfLine * (buttonHeight + buttonSpacing))
        }
    }
    
    // 按钮点击事件
    @objc func didOpenTags() {
        companyModel.isOpenTag.toggle() // 切换展开/收起状态
        setupScrollView() // 重新设置标签
    }
    
}
