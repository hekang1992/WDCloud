//
//  Utilities.swift
//  问道云
//
//  Created by Andrew on 2025/3/10.
//  工具类

import Foundation
import Lottie
import Toaster
import SAMKeychain
import RxSwift
import TYAlertController

// 定义一个类或扩展来封装振动反馈
class HapticFeedbackManager {
    
    // 通用的振动反馈方法
    static func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.impactOccurred()  // 触发振动
    }
    
    // 通知反馈（成功、错误、警告）
    static func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.notificationOccurred(type)  // 触发振动
    }
    
    // 选择反馈（例如滚动选择器）
    static func triggerSelectionFeedback() {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.prepare()  // 可选：提前准备
        feedbackGenerator.selectionChanged()  // 触发振动
    }
}

//获取导航栏高度
class StatusHeightManager {
    
    static var statusBarHeight: CGFloat {
        var height: CGFloat = 20.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            height = window.safeAreaInsets.top
        }
        return height
    }
    
    static var navigationBarHeight: CGFloat {
        var navBarHeight: CGFloat = 64.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            let safeTop = window.safeAreaInsets.top
            navBarHeight = safeTop > 0 ? (safeTop + 44) : 44
        }
        return navBarHeight
    }
    
    static var allHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }
    
    static var safeAreaBottomHeight: CGFloat {
        var safeHeight: CGFloat = 0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            safeHeight = window.safeAreaInsets.bottom
        }
        return safeHeight
    }
    
    static var tabBarHeight: CGFloat {
        return 49 + safeAreaBottomHeight
    }
}

//hud
class PlaHudView: UIView {
    
    lazy var hudView: LottieAnimationView = {
        let hudView = LottieAnimationView(name: "loading.json", bundle: Bundle.main)
        hudView.layer.cornerRadius = 12
        hudView.animationSpeed = 1.2
        hudView.loopMode = .loop
        hudView.play()
        hudView.backgroundColor = .white.withAlphaComponent(0.85)
        return hudView
    }()
    
    lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(grayView)
        grayView.addSubview(hudView)
        hudView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class ViewHud {
    
    static let loadView = PlaHudView()
    
    static func hideLoadView() {
        DispatchQueue.main.async {
            loadView.removeFromSuperview()
        }
    }
    
    static func addLoadView() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first {
                DispatchQueue.main.async {
                    loadView.frame = keyWindow.bounds
                    keyWindow.addSubview(loadView)
                }
            }
        }
    }
    
}

//showmessage
class ToastViewConfig {
    static func showToast(message: String) {
        ToastView.appearance().font = UIFont.boldSystemFont(ofSize: 20)
        let toast = Toast(text: message, duration: 1.0)
        if UIApplication.shared.windows.first != nil {
            let centerY = SCREEN_HEIGHT * 0.5
            ToastView.appearance().bottomOffsetPortrait = centerY
            ToastView.appearance().bottomOffsetLandscape = centerY
        }
        toast.show()
    }
}

class PushLoginConfig {
    static func popLogin(from viewController: UIViewController) {
        let loginVc = WDLoginViewController()
        let rootVc = WDNavigationController(rootViewController: loginVc)
        rootVc.modalPresentationStyle = .overFullScreen
        viewController.present(rootVc, animated: true, completion: nil)
    }
}

//电话号码*******
class PhoneNumberFormatter {
    static func formatPhoneNumber(phoneNumber: String) -> String {
        if phoneNumber.count > 10 {
            let start = phoneNumber.prefix(3)
            let end = phoneNumber.suffix(3)
            let masked = String(repeating: "*", count: phoneNumber.count - 6)
            return start + masked + end
        }
        return phoneNumber
    }
}

class PercentageConfig {
    static func formatToPercentage(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent // 设置为百分比样式
        // 检查小数部分是否为 0
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            formatter.minimumFractionDigits = 0 // 如果是整数，不显示小数部分
            formatter.maximumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 1 // 否则显示 1 位小数
            formatter.maximumFractionDigits = 1
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value * 100)%"
    }
}

//无数据页面
class LLemptyView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "wushujuimage")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 15)
        mlabel.textColor = UIColor.init(cssStr: "#999999")
        mlabel.textAlignment = .center
        mlabel.text = "暂无相关数据"
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bgImageView)
        addSubview(mlabel)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.bottom.left.right.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.left.equalTo((SCREEN_WIDTH - 163) * 0.5)
            make.top.equalToSuperview().offset(150)
            make.size.equalTo(CGSize(width: 163, height: 163))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalTo(bgImageView.snp.centerX)
            make.top.equalTo(bgImageView.snp.bottom).offset(10)
            make.height.equalTo(21)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//无网络页面
class NoNetView: BaseView {
    
    var refreshBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "duanwangimge")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 20)
        mlabel.textColor = UIColor.init(cssStr: "#666666")
        mlabel.textAlignment = .center
        mlabel.text = "加载失败"
        return mlabel
    }()
    
    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setImage(UIImage(named: "shuaxinimage"), for: .normal)
        refreshBtn.setTitle("点击刷新", for: .normal)
        refreshBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        refreshBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return refreshBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bgImageView)
        addSubview(mlabel)
        addSubview(refreshBtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(230)
            make.size.equalTo(CGSize(width: 110, height: 110))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(10)
            make.height.equalTo(28)
        }
        refreshBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mlabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 88, height: 21))
        }
        refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.refreshBlock?()
        }).disposed(by: disposeBag)
        refreshBtn.layoutButtonEdgeInsets(style: .left, space: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// 弹窗
class ShowAlertManager {
    
    /// 获取当前的视图控制器
    static func getTopViewController() -> UIViewController? {
        // 获取应用的所有窗口
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        // 获取最顶部的视图控制器
        var topController = windows.first?.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
    
    /// 通用的Alert封装方法
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - message: 弹窗内容
    ///   - confirmTitle: 确认按钮标题
    ///   - cancelTitle: 取消按钮标题（默认为nil，即没有取消按钮）
    ///   - confirmAction: 点击确认按钮的回调
    ///   - cancelAction: 点击取消按钮的回调（默认为nil）
    static func showAlert(title: String?,
                          message: String?,
                          confirmTitle: String? = "确认",
                          cancelTitle: String? = "取消",
                          confirmAction: (() -> Void)? = nil,
                          cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 添加确认按钮
        let confirmButton = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmAction?() // 点击确认按钮时执行的操作
        }
        alert.addAction(confirmButton)
        
        // 如果有取消按钮，则添加
        if let cancelTitle = cancelTitle {
            let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction?()
            }
            alert.addAction(cancelButton)
            cancelButton.setValue(UIColor.init(cssStr: "#9FA4AD"), forKey: "titleTextColor")
        }
        
        // 获取当前视图控制器并呈现提示框
        if let topController = getTopViewController() {
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

//获取缓存方法
class GetCacheConfig {
    /// 获取缓存大小，单位为 MB
    static func getCacheSizeInMB() -> String {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        var totalSize: UInt64 = 0
        
        if let enumerator = FileManager.default.enumerator(at: cacheURL, includingPropertiesForKeys: [.totalFileAllocatedSizeKey], options: [], errorHandler: nil) {
            for case let fileURL as URL in enumerator {
                do {
                    let resourceValues = try fileURL.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                    if let fileSize = resourceValues.totalFileAllocatedSize {
                        totalSize += UInt64(fileSize)
                    }
                } catch {
                    print("Error getting file size: \(error)")
                }
            }
        }
        
        // 将字节转换为 MB
        let sizeInMB = Double(totalSize) / (1024 * 1024)
        return String(format: "%.2f MB", sizeInMB)
    }
    
    static func clearCache() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil, options: [])
            for fileURL in contents {
                try FileManager.default.removeItem(at: fileURL)
            }
            print("Cache cleared successfully.")
        } catch {
            print("Error clearing cache: \(error)")
        }
    }
    
}

//密码验证
class PasswordConfig {
    static  func isPasswordValid(_ password: String) -> Bool {
        // 检查长度是否符合
        guard password.count >= 8 && password.count <= 20 else {
            return false
        }
        
        // 定义正则表达式模式
        let letterPattern = ".*[A-Za-z]+.*" // 至少一个字母
        let digitPattern = ".*[0-9]+.*"     // 至少一个数字
        let specialCharPattern = ".*[^A-Za-z0-9]+.*" // 至少一个特殊字符（不包括空格）
        
        // 创建正则表达式
        let letterRegex = try! NSRegularExpression(pattern: letterPattern)
        let digitRegex = try! NSRegularExpression(pattern: digitPattern)
        let specialCharRegex = try! NSRegularExpression(pattern: specialCharPattern)
        
        // 检查各类字符是否存在
        let hasLetter = letterRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        let hasDigit = digitRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        let hasSpecialChar = specialCharRegex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.utf16.count)) != nil
        
        // 至少两种类型组合
        let validCount = [hasLetter, hasDigit, hasSpecialChar].filter { $0 }.count
        return validCount >= 2
    }
    
}

//获取手机号码
class GetPhoneNumberManager {
    static func getPhoneNum() -> String {
        return UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
    }
}

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

//标签颜色
class TypeColorConfig {
    static func labelTextColor(form label: PaddedLabel) {
        let text = label.text ?? ""
        if text.contains("注销") {
            label.textColor = UIColor.init(cssStr: "#FF7D00")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#FF7D00")?.cgColor
        }else if text.contains("吊销") {
            label.textColor = UIColor.init(cssStr: "#F55B5B")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#F55B5B")?.cgColor
        }else {
            label.textColor = UIColor.init(cssStr: "#4DC929")
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 2
            label.layer.borderColor = UIColor.init(cssStr: "#4DC929")?.cgColor
        }
    }
}

//获取支付ID
class GetStoreIDManager {
    static func storeID(with comboNumber: Any) -> String {
        return "wdy.goods.\(comboNumber)"
    }
}

//数字滚动动画
class NumberAnimator {
    static func animateNumber(on label: UILabel, from startValue: Int, to endValue: Int, duration: TimeInterval) {
        let animationDuration = duration
        let stepCount = 100
        let stepDuration = animationDuration / Double(stepCount)
        DispatchQueue.global(qos: .userInteractive).async {
            for step in 0...stepCount {
                let progress = Double(step) / Double(stepCount)
                let newValue = Int(Double(startValue) + progress * Double(endValue - startValue))
                
                DispatchQueue.main.async {
                    label.text = "\(newValue)"
                }
                Thread.sleep(forTimeInterval: stepDuration)
            }
        }
    }
}

class NoCopyTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // 如果是复制操作，直接返回false来禁止执行
        if action == #selector(UIResponder.copy(_:)) {
            return false
        }
        // 对于其他操作，继续执行默认行为
        return super.canPerformAction(action, withSender: sender)
    }
}

//获取IDFV
let WDY_ONE = "WDY_ONE"
let WDY_TWO = "WDY_TWO"
class GetIDFVConfig {
    static func getIDFV() -> String {
        if let uuid = SAMKeychain.password(forService: WDY_ONE, account: WDY_TWO), !uuid.isEmpty {
            return uuid
        }
        guard let deviceIDFV = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        let isSuccess = SAMKeychain.setPassword(deviceIDFV, forService: WDY_ONE, account: WDY_TWO)
        return isSuccess ? deviceIDFV : ""
    }
    
}

//红色文字
class GetRedStrConfig: NSObject {
    
    static func getRedStr(from count: String?, fullText: String, colorStr: String? = "#F55B5B", font: UIFont? = UIFont.mediumFontOfSize(size: 15)) -> NSAttributedString {
        // 确保 count 有效，默认为 0
        let countValue = count ?? ""
        // 创建可变富文本字符串
        let attributedString = NSMutableAttributedString(string: fullText)
        // 查找 count 的范围
        if let range = fullText.range(of: "\(countValue)") {
            // 转换为 NSRange
            let nsRange = NSRange(range, in: fullText)
            // 设置指定范围内的文字颜色
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor(cssStr: colorStr ?? "") ?? UIColor.black,
                                          range: nsRange)
            attributedString.addAttribute(.font,
                                          value: font as Any,
                                          range: nsRange)
        }
        
        return attributedString
    }
    
}

class ViewControllerUtils {
    /// 通过当前视图获取所在的控制器
    static func findViewController(from view: UIView) -> WDBaseViewController? {
        var responder: UIResponder? = view
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? WDBaseViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
    
    /// 通过当前视图获取导航控制器
    static func findNavigationController(from view: UIView) -> UINavigationController? {
        guard let viewController = findViewController(from: view) else {
            return nil
        }
        return viewController.navigationController
    }
    
    /// 通过当前视图 Push 到新的控制器
    static func pushViewController(from view: UIView, to targetViewController: UIViewController, animated: Bool = true) {
        guard let navigationController = findNavigationController(from: view) else {
            print("Current view is not embedded in a navigation controller")
            return
        }
        navigationController.pushViewController(targetViewController, animated: animated)
    }
}

class TagsLabelColorConfig {
    
    static func nameLabelColor(from tagView: UILabel) {
        let currentTitle = tagView.text ?? ""
        if currentTitle.contains("经营异常") || currentTitle.contains("被执行人") || currentTitle.contains("失信被执行人") || currentTitle.contains("限制高消费") || currentTitle.contains("票据违约") || currentTitle.contains("债券违约") {
            tagView.backgroundColor = .init(cssStr: "#F55B5B")?.withAlphaComponent(0.1)
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }else if currentTitle.contains("存续") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#4DC929")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("注销") {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#FF7D00")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("吊销")  {
            tagView.backgroundColor = .clear
            tagView.textColor = .init(cssStr: "#F55B5B")
            tagView.layer.borderColor = tagView.textColor.cgColor
            tagView.layer.borderWidth = 1
        }else if currentTitle.contains("小微企业") || currentTitle.contains("高新技术企业") || currentTitle.contains("国有控股") || currentTitle.contains("国有独资") || currentTitle.contains("国有全资") || currentTitle.contains("深主板") || currentTitle.contains("沪主板") || currentTitle.contains("港交所") || currentTitle.contains("北交所") || currentTitle.contains("发债"){
            tagView.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#547AFF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        } else {
            tagView.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            tagView.textColor = .init(cssStr: "#547AFF")
            tagView.layer.borderColor = UIColor.clear.cgColor
        }
        
    }
    
}

class ShowAgainLoginConfig {
    
    static var grand: Bool = true
    
    static let disposeBag = DisposeBag()
    
    static func againLoginView() {
        if grand {
            grand = false
            let againLoginView = PopAgainLoginView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
            let alertVc = TYAlertController(alert: againLoginView, preferredStyle: .alert)!
            let vc = ShowAlertManager.getTopViewController()
            vc?.present(alertVc, animated: true)
            
            againLoginView.cancelBtn.rx.tap.subscribe(onNext: {
                grand = true
                vc?.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                })
            }).disposed(by: disposeBag)
            
            againLoginView.sureBtn.rx.tap.subscribe(onNext: {
                grand = true
                vc?.dismiss(animated: true, completion: {
                    let loginVc = WDLoginViewController()
                    let rootVc = WDNavigationController(rootViewController: loginVc)
                    rootVc.modalPresentationStyle = .overFullScreen
                    vc?.present(rootVc, animated: true)
                    WDLoginConfig.removeLoginInfo()
                    loginVc.loginView.backBtn.rx.tap.subscribe(onNext: {
                        loginVc.loginView.phoneTx.resignFirstResponder()
                        NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                    }).disposed(by: disposeBag)
                })
            }).disposed(by: disposeBag)
        }
    }
    
}

class URLQueryAppender {
    static func appendQueryParameters(to url: String, parameters: [String: String]) -> String? {
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url?.absoluteString
    }
}

/** 电话,银行卡,税号校验 */
enum PhoneNumberType {
    case mobile      // 手机号
    case landline    // 座机号
    case international // 国际号码
    case invalid     // 无效号码
}

struct Validator {
    
    // MARK: - 银行卡验证
    /// 验证银行卡号（16-19位数字）
    static func isValidBankCardNumber(_ cardNumber: String) -> Bool {
        let pattern = #"^\d{15,19}$"#
        return cardNumber.range(of: pattern, options: .regularExpression) != nil
    }
    
    // MARK: - 税号验证
    /// 验证税号（中国15位或18位数字/字母）
    static func isValidTaxNumber(_ taxNumber: String) -> Bool {
        let pattern = #"^[A-Z0-9]{15}$|^[A-Z0-9]{18}$"#
        return taxNumber.range(of: pattern, options: .regularExpression) != nil
    }
    
    // MARK: - 电话号码验证
    // MARK: - 中国手机号验证
        /// 验证中国手机号（精确到当前所有运营商号段）
        static func isValidChineseMobile(_ number: String) -> Bool {
            // 清理号码（去除空格、横线、+86等前缀）
            let cleaned = number
                .replacingOccurrences(of: "^\\+86", with: "", options: .regularExpression)
                .replacingOccurrences(of: "[\\s-]", with: "", options: .regularExpression)
            
            // 2023年中国大陆手机号最新号段
            let pattern = #"^(1[3-9]\d{9})$"#
            return cleaned.range(of: pattern, options: .regularExpression) != nil
        }
        
        // MARK: - 中国座机号验证
        /// 验证中国座机号（严格格式）
        static func isValidChineseLandline(_ number: String) -> Bool {
            // 标准格式：区号-号码 或 区号号码
            let pattern = #"^(0[1-9]\d{1,2}-?[1-9]\d{6,7})(-\d{1,5})?$"#
            return number.range(of: pattern, options: .regularExpression) != nil
        }
        
        // MARK: - 综合电话号码验证
        /// 综合验证电话号码（自动识别类型）
    static func validatePhoneNumber(_ number: String) -> Bool {
            // 先清理号码
            let cleaned = number
                .replacingOccurrences(of: "^\\+86", with: "", options: .regularExpression)
                .replacingOccurrences(of: "[\\s-]", with: "", options: .regularExpression)
            
            // 1. 检查中国手机号
            if isValidChineseMobile(cleaned) {
                return true
            }
            
            // 2. 检查中国座机号
            if isValidChineseLandline(number) {  // 注意这里使用原始号码，因为横线对座机号很重要
                return true
            }
            
            // 3. 检查国际号码
            if isValidInternationalNumber(number) {
                return true
            }
            
        return false
        }
        
        // MARK: - 国际号码验证
        /// 验证国际电话号码（相对宽松的验证）
        private static func isValidInternationalNumber(_ number: String) -> Bool {
            // 国际号码基本格式：+国家代码 号码
            let pattern = #"^\+\d{1,4}[\s-]?\d{5,14}$"#
            return number.range(of: pattern, options: .regularExpression) != nil
        }
    
}
