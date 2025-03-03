//
//  HighSearchOneView.swift
//  问道云
//
//  Created by Andrew on 2025/2/21.
//

import UIKit
import RxSwift
import RxRelay
import TagListView
import DropMenuBar

class HighSearchKeyView: BaseView {
    
    var matchType: String?
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "关键词"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .justified
        mlabel.font = .regularFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        nameTx.font = .regularFontOfSize(size: 13)
        nameTx.placeholder = "请输入关键词(非必填)"
        return nameTx
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    private lazy var preciseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("精准", for: .normal)
        button.titleLabel?.font = .mediumFontOfSize(size: 13)
        button.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        button.setImage(UIImage(named: "iconselecthgiimge"), for: .normal)
        button.addTarget(self, action: #selector(selectPrecise), for: .touchUpInside)
        button.layoutButtonEdgeInsets(style: .left, space: 3)
        return button
    }()
    
    private lazy var fuzzyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("模糊", for: .normal)
        button.titleLabel?.font = .mediumFontOfSize(size: 13)
        button.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        button.setImage(UIImage(named: "iconselcehignor"), for: .normal)
        button.addTarget(self, action: #selector(selectFuzzy), for: .touchUpInside)
        button.layoutButtonEdgeInsets(style: .left, space: 3)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(mlabel)
        addSubview(nameTx)
        addSubview(preciseButton)
        addSubview(fuzzyButton)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        nameTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mlabel.snp.right).offset(30)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 210, height: 20))
        }
        fuzzyButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(SCREEN_WIDTH - 60)
            make.size.equalTo(CGSize(width: 55, height: 19))
        }
        preciseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(fuzzyButton.snp.left).offset(-5)
            make.size.equalTo(CGSize(width: 55, height: 19))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 选中“精准”按钮
    @objc private func selectPrecise() {
        updateButtonSelection(selectedButton: preciseButton, unselectedButton: fuzzyButton)
        self.matchType = "2"
    }
    
    // 选中“模糊”按钮
    @objc private func selectFuzzy() {
        updateButtonSelection(selectedButton: fuzzyButton, unselectedButton: preciseButton)
        self.matchType = "1"
    }
    
    private func updateButtonSelection(selectedButton: UIButton, unselectedButton: UIButton) {
        selectedButton.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        selectedButton.setImage(UIImage(named: "iconselecthgiimge"), for: .normal)
        
        unselectedButton.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        unselectedButton.setImage(UIImage(named: "iconselcehignor"), for: .normal)
    }
    
}

class HighTwoView: BaseView {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "行业"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .justified
        mlabel.font = .regularFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#ACACAC")
        descLabel.text = "非必填"
        descLabel.font = .regularFontOfSize(size: 13)
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "ent_detail_arrow_right")
        return ctImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(mlabel)
        addSubview(descLabel)
        addSubview(ctImageView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mlabel.snp.right).offset(30)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 40))
        }
        
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(SCREEN_WIDTH - 25)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HighThreeView: BaseView {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "地区"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .justified
        mlabel.font = .regularFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#ACACAC")
        descLabel.text = "全部"
        descLabel.font = .regularFontOfSize(size: 13)
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "ent_detail_arrow_right")
        return ctImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(mlabel)
        addSubview(descLabel)
        addSubview(ctImageView)
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(mlabel.snp.right).offset(30)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 40))
        }
        
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(SCREEN_WIDTH - 25)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HighFourView: UIView {
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "登记状态"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .justified
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var view0: CustomButtonView = {
        let view0 = CustomButtonView()
        return view0
    }()
    
    lazy var view1: CustomButtonView = {
        let view1 = CustomButtonView()
        return view1
    }()
    
    lazy var view2: CustomButtonView = {
        let view2 = CustomButtonView()
        return view2
    }()
    
    lazy var view3: CustomButtonView = {
        let view3 = CustomButtonView()
        return view3
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置UI
    private func setupUI() {
        addSubview(mlabel)
        addSubview(view0)
        addSubview(view1)
        addSubview(view2)
        addSubview(view3)
        addSubview(lineView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        view0.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.size.equalTo(CGSize(width: 260, height: 25))
        }
        view1.snp.makeConstraints { make in
            make.top.equalTo(view0.snp.bottom).offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.size.equalTo(CGSize(width: 260, height: 25))
        }
        view2.snp.makeConstraints { make in
            make.top.equalTo(view1.snp.bottom).offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.size.equalTo(CGSize(width: 260, height: 25))
        }
        view3.snp.makeConstraints { make in
            make.top.equalTo(view2.snp.bottom).offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.size.equalTo(CGSize(width: 260, height: 62))
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

class ModelButton: UIButton {
    var model: childrenModel?
}

class CustomButtonView: BaseView {
    
    var dengjiBinder = BehaviorRelay<[String]?>(value: nil)
    var dengjiStringBinder = BehaviorRelay<[String]?>(value: nil)
    
    lazy var allButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .regularFontOfSize(size: 12)
        button.setTitleColor(UIColor.init(cssStr: "#27344B"), for: .normal)
        button.setImage(UIImage(named: "agreenorimage"), for: .normal)
        button.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        button.layoutButtonEdgeInsets(style: .left, space: 8)
        return button
    }()
    
    // MARK: - 按钮数组
    private var buttons: [ModelButton] = []
//    titles: titles.map { $0.name ?? "" }
    // MARK: - 外部方法配置按钮
    func configureButtons(modelArray: [childrenModel]) {
        buttons = modelArray.map { model in
            let button = createButton(model: model)
            button.addTarget(self, action: #selector(singleButtonTapped(_:)), for: .touchUpInside)
            return button
        }
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置UI
    private func setupUI() {
        addSubview(allButton)
        allButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.5)
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 41.pix(), height: 17))
        }
        setNeedsLayout()
        layoutIfNeeded()
        // 设置按钮布局
        var currentX: CGFloat =  allButton.frame.maxX + 12 // 左边距
        var currentY: CGFloat = 0
        let buttonSpacing: CGFloat = 12
        let maxWidth: CGFloat = 250
        let buttonHeight: CGFloat = 25
        var rowHeight: CGFloat = 0
        
        for button in buttons {
            let buttonWidth = calculateButtonWidth(for: button)
            button.frame = CGRect(x: currentX, y: currentY, width: buttonWidth, height: buttonHeight)
            addSubview(button)
            
            rowHeight = max(rowHeight, button.frame.height)
            
            // 如果超出最大宽度则换行
            if currentX + buttonWidth + 12 > maxWidth {
                currentX = 12 + allButton.frame.maxX
                currentY += rowHeight + 12 // 换行，添加垂直间距
                rowHeight = 0
            } else {
                currentX += buttonWidth + buttonSpacing // 水平间距
            }
        }
        // 设置 contentSize 以支持滚动视图
        let totalHeight = currentY + rowHeight + 10
        self.frame.size.height = totalHeight
    }
    
    // MARK: - 创建按钮的工厂方法
    private func createButton(model: childrenModel) -> ModelButton {
        let button = ModelButton(type: .custom)
        button.model = model
        button.layer.cornerRadius = 5
        button.setTitle(model.name ?? "", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .init(cssStr: "#F1F1F1")
        button.titleLabel?.font = .regularFontOfSize(size: 12)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
        return button
    }
    
    // MARK: - 计算按钮宽度
    private func calculateButtonWidth(for button: UIButton) -> CGFloat {
        guard let title = button.title(for: .normal) else {
            return 0
        }
        let padding: CGFloat = 5
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        let width = label.frame.width + padding + 5
        return width
    }
    
    // MARK: - 按钮点击事件
    @objc func allButtonTapped() {
        if allButton.currentImage == UIImage(named: "agreeselimage") {
            allButton.setImage(UIImage(named: "agreenorimage"), for: .normal)
            buttons.forEach { deselectButton($0) }
        } else {
            // 选中 All 按钮并选中其他所有按钮
            allButton.setImage(UIImage(named: "agreeselimage"), for: .normal)
            buttons.forEach { selectButton($0) }
        }
    }
    
    func removeBtnConfig() {
        delAllButton(allButton)
        buttons.forEach { deselectButton($0) }
    }
    
    @objc private func singleButtonTapped(_ sender: ModelButton) {
        // 如果点击的按钮已选中，则取消选中
        if sender.backgroundColor == UIColor.init(cssStr: "#547AFF")!.withAlphaComponent(0.05) {
            deselectButton(sender)
            delAllButton(allButton)
        } else {
            selectButton(sender)
            // 检查是否所有按钮都已选中，如果是，则选中 All 按钮
            if buttons.allSatisfy({ $0.backgroundColor == UIColor.init(cssStr: "#547AFF")!.withAlphaComponent(0.05) }) {
                selectAllButton(allButton)
            }
        }
    }
    
    func selectAllButton(_ button: UIButton) {
        button.setImage(UIImage(named: "agreeselimage"), for: .normal)
    }
    
    func delAllButton(_ button: UIButton) {
        button.setImage(UIImage(named: "agreenorimage"), for: .normal)
    }
    
    // MARK: - 选中按钮的方法
    private func selectButton(_ button: ModelButton) {
        guard let title = button.titleLabel?.text else { return }
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        button.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        //ID
        var currentValues = self.dengjiBinder.value ?? []
        //文字
        var titles = self.dengjiStringBinder.value ?? []
        if !currentValues.contains(button.model?.code ?? "") {
            currentValues.append(button.model?.code ?? "") // 追加新的值
        }
        if !titles.contains(title) {
            titles.append(title) // 追加新的值
        }
        self.dengjiBinder.accept(currentValues)
        self.dengjiStringBinder.accept(titles)
    }
    
    private func deselectButton(_ button: ModelButton) {
        guard let title = button.titleLabel?.text else { return }
        // 修改按钮样式
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = UIColor(cssStr: "#F1F1F1")
        button.setTitleColor(UIColor(cssStr: "#27344B"), for: .normal)
        button.layer.borderWidth = 0.0
        button.layer.borderColor = UIColor(cssStr: "#547AFF")?.cgColor
        // 获取当前数组ID
        var currentValues = self.dengjiBinder.value ?? []
        // 获取当前数组文字
        var currentStringValues = self.dengjiStringBinder.value ?? []
        // 检查数组中是否包含按钮的 title，并将其移除
        if let index = currentValues.firstIndex(of: button.model?.code ?? "") {
            currentValues.remove(at: index)
        }
        if let index = currentStringValues.firstIndex(of: title) {
            currentStringValues.remove(at: index)
        }
        // 更新数组
        self.dengjiBinder.accept(currentValues)
        self.dengjiStringBinder.accept(currentStringValues)
    }
}

class HighFiveView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "成立年限"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F1F1F1")
        return grayView
    }()
    
    lazy var startBtn: UIButton = {
        let startBtn = UIButton(type: .custom)
        startBtn.layer.cornerRadius = 2
        startBtn.layer.masksToBounds = true
        startBtn.setTitle("开始日期", for: .normal)
        startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        startBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        return startBtn
    }()
    
    lazy var endBtn: UIButton = {
        let endBtn = UIButton(type: .custom)
        endBtn.layer.cornerRadius = 2
        endBtn.layer.masksToBounds = true
        endBtn.setTitle("结束日期", for: .normal)
        endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        endBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        return endBtn
    }()
    
    lazy var linegView: UIView = {
        let linegView = UIView()
        linegView.backgroundColor = .init(cssStr: "#9FA4AD")
        return linegView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        addSubview(grayView)
        grayView.addSubview(linegView)
        grayView.addSubview(startBtn)
        grayView.addSubview(endBtn)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.width.equalTo(280)
        }
        grayView.snp.makeConstraints { make in
            make.left.equalTo(tagListView.snp.left)
            make.top.equalTo(tagListView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 195, height: 25))
        }
        linegView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 1))
        }
        startBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(linegView.snp.left)
        }
        endBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(linegView.snp.right)
        }
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.getPopTimeDatePicker(completion: { time in
                self.startBtn.setTitle(time, for: .normal)
                self.startBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            })
        }).disposed(by: disposeBag)
        
        endBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.getPopTimeDatePicker(completion: { time in
                self.endBtn.setTitle(time, for: .normal)
                self.endBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            })
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension HighFiveView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            self.startBtn.setTitle("开始日期", for: .normal)
            self.endBtn.setTitle("结束日期", for: .normal)
            self.startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            self.endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        } else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}

class HighSixView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "注册资本"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F1F1F1")
        return grayView
    }()
    
    lazy var piLabel: UILabel = {
        let piLabel = UILabel()
        piLabel.text = "万"
        piLabel.textColor = .init(cssStr: "#333333")
        piLabel.font = .regularFontOfSize(size: 13)
        return piLabel
    }()
    
    lazy var startTx: UITextField = {
        let startTx = UITextField()
        startTx.keyboardType = .numberPad
        startTx.textAlignment = .center
        let attrString = NSMutableAttributedString(string: "最低资本", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        startTx.attributedPlaceholder = attrString
        startTx.font = .regularFontOfSize(size: 12)
        startTx.textColor = UIColor.init(cssStr: "#333333")
        return startTx
    }()
    
    lazy var endTx: UITextField = {
        let endTx = UITextField()
        endTx.keyboardType = .numberPad
        endTx.textAlignment = .center
        let attrString = NSMutableAttributedString(string: "最高资本", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        endTx.attributedPlaceholder = attrString
        endTx.font = .regularFontOfSize(size: 12)
        endTx.textColor = UIColor.init(cssStr: "#333333")
        return endTx
    }()
    
    lazy var linegView: UIView = {
        let linegView = UIView()
        linegView.backgroundColor = .init(cssStr: "#9FA4AD")
        return linegView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        addSubview(grayView)
        grayView.addSubview(linegView)
        grayView.addSubview(startTx)
        grayView.addSubview(endTx)
        addSubview(piLabel)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.width.equalTo(260)
        }
        grayView.snp.makeConstraints { make in
            make.left.equalTo(tagListView.snp.left)
            make.top.equalTo(tagListView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 195, height: 25))
        }
        piLabel.snp.makeConstraints { make in
            make.centerY.equalTo(grayView.snp.centerY)
            make.left.equalTo(grayView.snp.right).offset(4)
            make.height.equalTo(19)
        }
        linegView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 1))
        }
        startTx.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(linegView.snp.left)
        }
        endTx.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(linegView.snp.right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighSixView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            self.startTx.text = ""
            self.endTx.text = ""
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        } else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}

class HighAgentView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "机构类型"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighAgentView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        } else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}

class HighCompanyTypeView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "企业类型"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighCompanyTypeView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        } else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}

class HighPeopleView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "参保人数"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F1F1F1")
        return grayView
    }()
    
    lazy var piLabel: UILabel = {
        let piLabel = UILabel()
        piLabel.text = "人"
        piLabel.textColor = .init(cssStr: "#333333")
        piLabel.font = .regularFontOfSize(size: 13)
        return piLabel
    }()
    
    lazy var startTx: UITextField = {
        let startTx = UITextField()
        startTx.keyboardType = .numberPad
        startTx.textAlignment = .center
        let attrString = NSMutableAttributedString(string: "最低人数", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        startTx.attributedPlaceholder = attrString
        startTx.font = .regularFontOfSize(size: 12)
        startTx.textColor = UIColor.init(cssStr: "#333333")
        return startTx
    }()
    
    lazy var endTx: UITextField = {
        let endTx = UITextField()
        endTx.keyboardType = .numberPad
        endTx.textAlignment = .center
        let attrString = NSMutableAttributedString(string: "最高人数", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        endTx.attributedPlaceholder = attrString
        endTx.font = .regularFontOfSize(size: 12)
        endTx.textColor = UIColor.init(cssStr: "#333333")
        return endTx
    }()
    
    lazy var linegView: UIView = {
        let linegView = UIView()
        linegView.backgroundColor = .init(cssStr: "#9FA4AD")
        return linegView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        addSubview(grayView)
        grayView.addSubview(linegView)
        grayView.addSubview(startTx)
        grayView.addSubview(endTx)
        addSubview(piLabel)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
            make.right.equalToSuperview().offset(-20)
        }
        grayView.snp.makeConstraints { make in
            make.left.equalTo(tagListView.snp.left)
            make.top.equalTo(tagListView.snp.bottom).offset(15)
            make.size.equalTo(CGSize(width: 195, height: 25))
        }
        piLabel.snp.makeConstraints { make in
            make.centerY.equalTo(grayView.snp.centerY)
            make.left.equalTo(grayView.snp.right).offset(4)
            make.height.equalTo(19)
        }
        linegView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 1))
        }
        startTx.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(linegView.snp.left)
        }
        endTx.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(linegView.snp.right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighPeopleView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            self.startTx.text = ""
            self.endTx.text = ""
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        }else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}

class HighStatusView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "上市状态"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighStatusView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        }else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
}

class HighBlockView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "上市板块"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#27344B")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 12)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighBlockView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "不限" {
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        }else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "不限" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
}

class HighEmailView: BaseView {
    
    //选中的标签
    var selectArray: [String] = []
    
    var tagListViews: [TagView] = []
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "联系邮箱"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 13)
        return mlabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 5
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#666666")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 14)
        tagListView.borderWidth = 1
        tagListView.borderColor = UIColor.clear
        tagListView.selectedTextColor = UIColor.init(cssStr: "#547AFF")!
        tagListView.selectedBorderColor = UIColor.init(cssStr: "#547AFF")
        tagListView.tagSelectedBackgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mlabel)
        addSubview(lineView)
        addSubview(tagListView)
        mlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(19)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        tagListView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(mlabel.snp.right).offset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HighEmailView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected.toggle()
        tagListViews.append(tagView)
        if title == "有" {
            tagListViews.forEach { _ in /*$0.isSelected = $0.currentTitle == title*/ }
            selectArray.removeAll()
            if tagView.isSelected {
                selectArray.append(title)
            }else {
                selectArray.append("")
            }
        }else {
            selectArray.removeAll()
            tagListViews.first(where: { $0.currentTitle == "有" })?.isSelected = false
            selectArray.append(contentsOf: sender.selectedTags().compactMap { $0.currentTitle })
            print("selectArray=====\(selectArray)")
        }
    }
    
    func clearStateOfSelected() {
        selectedTags().forEach { [weak self] tagView in
            guard let self = self else { return }
            tagPressed(tagView.currentTitle ?? "", tagView: tagView, sender: tagListView)
        }
    }
    
    func selectedTags() -> [TagView] {
        return tagListView.tagViews.filter { $0.isSelected }
    }
    
}
