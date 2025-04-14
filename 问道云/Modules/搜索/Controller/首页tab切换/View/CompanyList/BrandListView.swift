//
//  BrandListView.swift
//  问道云
//
//  Created by 何康 on 2025/4/14.
//

import UIKit

class BrandListView: BaseView {
    
    var lastPhoneView: PhoneListView? = nil
    
    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            let name = model.name ?? ""
            let logoUrl = model.logoUrl ?? ""
            self.logoImageView.kf.setImage(with: URL(string: logoUrl), placeholder: UIImage.imageOfText(name, size: (30, 30)))
            self.nameLabel.text = name
            self.tagLabel.text = model.tags ?? ""
            self.descLabel.setText(model.desc ?? "", width: SCREEN_WIDTH - 20)
            self.webSiteLabel.text = model.weburl ?? ""
            // --- 新增：清除所有已存在的电话视图 ---
            scrollView.subviews.forEach { subview in
                if subview is PhoneListView {
                    subview.removeFromSuperview()
                }
            }
            lastPhoneView = nil // 重置指针
            // --- 新增结束 ---
            let phoneList = model.phoneList ?? []
            for model in phoneList {
                let phoneView = PhoneListView()
                phoneView.phoneBtn.setTitle(model.phone ?? "", for: .normal)
                scrollView.addSubview(phoneView)
                phoneView.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.height.equalTo(40)
                    if let last = lastPhoneView {
                        make.left.equalTo(last.snp.right).offset(10)
                    } else {
                        make.left.equalTo(scrollView.snp.left).offset(10)
                    }
                }
                lastPhoneView = phoneView
            }
            if let last = lastPhoneView {
                last.snp.makeConstraints { make in
                    make.right.equalTo(scrollView.snp.right).offset(-10)
                }
            }
        }
    }
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "brandImages")
        return ctImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 18)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.textColor = .init(cssStr: "#666666")
        tagLabel.font = .mediumFontOfSize(size: 12)
        tagLabel.textAlignment = .left
        return tagLabel
    }()
    
    lazy var brandLabel: UILabel = {
        let brandLabel = UILabel()
        brandLabel.text = "品牌"
        brandLabel.textColor = .white
        brandLabel.backgroundColor = .init(cssStr: "#547AFF")
        brandLabel.layer.cornerRadius = 2.5
        brandLabel.layer.masksToBounds = true
        brandLabel.textAlignment = .center
        brandLabel.font = .regularFontOfSize(size: 11)
        return brandLabel
    }()
    
    lazy var descLabel: ExpandableTextView = {
        let descLabel = ExpandableTextView()
        return descLabel
    }()
    
    lazy var webSiteLabel: UILabel = {
        let webSiteLabel = UILabel()
        webSiteLabel.textColor = .init(cssStr: "#3F96FF")
        webSiteLabel.font = .mediumFontOfSize(size: 12)
        webSiteLabel.textAlignment = .left
        webSiteLabel.isUserInteractionEnabled = true
        return webSiteLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(logoImageView)
        ctImageView.addSubview(nameLabel)
        ctImageView.addSubview(tagLabel)
        ctImageView.addSubview(brandLabel)
        ctImageView.addSubview(descLabel)
        ctImageView.addSubview(webSiteLabel)
        ctImageView.addSubview(scrollView)
        ctImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.height.equalTo(25)
            make.width.lessThanOrEqualTo(200)
        }
        tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.height.equalTo(17)
        }
        brandLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.right.equalToSuperview().offset(-9.5)
            make.size.equalTo(CGSize(width: 30.pix(), height: 16.pix()))
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
        }
        webSiteLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(webSiteLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        webSiteLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let pageUrl = webSiteLabel.text ?? ""
            let vc = ViewControllerUtils.findViewController(from: self)
            if let vc = vc {
                let webVc = WebPageViewController()
                webVc.pageUrl.accept(pageUrl)
                vc.navigationController?.pushViewController(webVc, animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makePhoneCall(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            print("无效的电话号码")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("设备不支持拨打电话")
        }
    }
    
}

class ExpandableTextView: UIView {
    
    var isExpandedBlock: ((Bool) -> Void)?
    
    private let label = UILabel()
    var isExpanded = false
    private var fullText: String = ""
    private let maxLines = 3
    private let font = UIFont.systemFont(ofSize: 15)
    private var widthLimit: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        label.numberOfLines = 0
        label.font = font
        label.textColor = .gray
        label.isUserInteractionEnabled = true
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        label.addGestureRecognizer(tap)
    }
    
    func setText(_ text: String, width: CGFloat) {
        self.fullText = text
        self.widthLimit = width
        updateLabel()
    }
    
    private func updateLabel() {
        if isExpanded {
            label.attributedText = NSAttributedString(string: fullText, attributes: [.font: font, .foregroundColor: UIColor.gray])
            return
        }
        
        // 构造 "... 展开"
        let expandText = "... 展开"
        let expandAttr = NSAttributedString(string: expandText, attributes: [
            .font: font,
            .foregroundColor: UIColor.systemBlue
        ])
        
        // 裁剪文本到三行以内能放下的位置
        let visibleText = truncatedText(for: fullText, expandText: expandText)
        
        let visibleAttr = NSMutableAttributedString(string: visibleText, attributes: [
            .font: font,
            .foregroundColor: UIColor.gray
        ])
        visibleAttr.append(expandAttr)
        
        label.attributedText = visibleAttr
    }
    
    // 截断文本到可以放下 "... 展开" 的最大范围（3行以内）
    private func truncatedText(for text: String, expandText: String) -> String {
        let nsText = text as NSString
        var low = 0
        var high = text.count
        
        while low < high {
            let mid = (low + high) / 2
            let sub = nsText.substring(to: mid) + expandText
            let height = sub.boundingRect(
                with: CGSize(width: widthLimit, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: [.font: font],
                context: nil
            ).height
            
            let lineHeight = font.lineHeight
            if height > CGFloat(maxLines) * lineHeight {
                high = mid
                
            } else {
                low = mid + 1
            }
        }
        
        let final = nsText.substring(to: max(0, low - 1))
        return final
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard !isExpanded else { return }
        
        let touchPoint = gesture.location(in: label)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString())
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = maxLines
        textContainer.lineBreakMode = .byTruncatingTail
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let index = layoutManager.characterIndex(for: touchPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if index >= (label.attributedText?.length ?? 0) - 4 {
            // 点击了「展开」
            isExpanded = true
            updateLabel()
            self.isExpandedBlock?(isExpanded)
        }
    }
    
    func calculateLineCount(for text: String) -> Int {
        let textStorage = NSTextStorage(string: text, attributes: [.font: UIFont.regularFontOfSize(size: 15)])
        let textContainer = NSTextContainer(size: CGSize(width: SCREEN_WIDTH - 20, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.glyphRange(for: textContainer)
        
        return layoutManager.numberOfLines(in: textContainer)
    }
    
}

extension NSLayoutManager {
    func numberOfLines(in textContainer: NSTextContainer) -> Int {
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while index < numberOfGlyphs {
            lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
}

class PhoneListView: BaseView {
    
    var block: (() -> Void)?
    
    lazy var phoneBtn: UIButton = {
        let phoneBtn = UIButton()
        phoneBtn.setTitleColor(.init(cssStr: "#3F96FF"), for: .normal)
        phoneBtn.titleLabel?.font = UIFont.mediumFontOfSize(size: 12)
        phoneBtn.contentHorizontalAlignment = .left
        return phoneBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(phoneBtn)
        addSubview(lineView)
        phoneBtn.snp.makeConstraints { make in
            make.height.equalTo(17.pix())
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(120.pix())
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(phoneBtn.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 1, height: 14))
        }
        
        phoneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.block?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
