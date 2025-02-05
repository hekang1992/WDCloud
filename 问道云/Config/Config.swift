//
//  Config.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import Lottie
import Toaster
import SAMKeychain

let ROOT_VC = "ROOT_VC"

let RISK_VC = "RISK_VC"

let DILI_VC = "DILI_VC"

let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

let SHOW_HOME_LAUNCH = "SHOW_HOME_LAUNCH"

//高德地图key
let ATUO_MAP_KEY = "be5c7fd08d404c308286ca0ce04629d0"

//颜色
extension UIColor {
    convenience init?(cssStr: String) {
        let hexString = cssStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard hexString.hasPrefix("#") else {
            return nil
        }
        let hexCode = hexString.dropFirst()
        guard hexCode.count == 6, let rgbValue = UInt64(hexCode, radix: 16) else {
            return nil
        }
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    class func random() -> UIColor {
        return UIColor(red: randomNumber(),
                       green: randomNumber(),
                       blue: randomNumber(),
                       alpha: 1.0)
    }
    
    private class func randomNumber() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
}

extension UIView {
    
    func removeAllSubviews() {
        while let subview = self.subviews.first {
            subview.removeFromSuperview()
        }
    }
    
    func setTopCorners(radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
}

//字体
extension UIFont {
    
    class func regularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func mediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    class func boldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    class func semiboldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
}

//按钮图片和文字的位置
enum ButtonEdgeInsetsStyle {
    case top // image in top，label in bottom
    case left  // image in left，label in right
    case bottom  // image in bottom，label in top
    case right // image in right，label in left
}

extension UIButton {
    func layoutButtonEdgeInsets(style: ButtonEdgeInsetsStyle, space: CGFloat) {
        setNeedsLayout()
        layoutIfNeeded()
        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsets.zero
        var labelEdgeInset = UIEdgeInsets.zero
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
        labelWidth = min(labelWidth, frame.width - space - imageWith!)
        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        
        switch style {
        case .top:
            if ((self.titleLabel?.intrinsicContentSize.width ?? 0) + (imageWith ?? 0)) > frame.width {
                let imageOffsetX = (frame.width - imageWith!) / 2
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: imageOffsetX, bottom: 0, right: -imageOffsetX)
            } else {
                imageEdgeInset = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            }
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith!, bottom: -imageHeight! - space / 2.0, right: 0)
        case .left:
            imageEdgeInset = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .bottom:
            imageEdgeInset = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInset = UIEdgeInsets(top: -imageHeight! - space / 2.0, left: -imageWith!, bottom: 0, right: 0)
        case .right:
            imageEdgeInset = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInset = UIEdgeInsets(top: 0, left: -imageWith! - space / 2.0, bottom: 0, right: imageWith! + space / 2.0)
        }
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
    }
}

//图片拓展
extension UIImage {
    class func imageOfText(_ text: String,
                           size: (CGFloat, CGFloat),
                           bgColor: UIColor = .random(),
                           textColor: UIColor = .white,
                           cornerRadius: CGFloat = 3) -> UIImage? {
        // 过滤空""
        if text.isEmpty { return nil }
        // 取第一个字符
        let letter = (text as NSString).substring(to: 1)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(sise, false, scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(bgColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        
        let attr = [
            NSAttributedString.Key.foregroundColor : textColor,
            NSAttributedString.Key.font : UIFont.boldFontOfSize(size: minSide * 0.5),
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.kern: 0
        ] as [NSAttributedString.Key : Any]
        
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.attributedText = .init(string: letter, attributes: attr)
        textLabel.sizeToFit()
        let textW = textLabel.frame.width
        let textH = textLabel.frame.height
        textLabel.drawText(in: .init(x: minSide / 2 - textW / 2, y: minSide / 2 - textH / 2, width: textW, height: textH))
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    //创建二维码
    class func qrImageForString(qrString: String?, qrImage: UIImage? = nil) -> UIImage? {
        if let sureQRString = qrString {
            let stringData = sureQRString.data(using: .utf8, allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            
            // 创建一个颜色滤镜,黑白色
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            // 返回二维码image
            //let codeImage = UIImage(ciImage: colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5)))
            let codeImage = UIImage(ciImage: colorFilter.outputImage!.transformed(by: CGAffineTransform(scaleX: 5, y: 5)))
            
            // 中间都会放想要表达意思的图片
            if let iconImage = qrImage {
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width,
                                  height: codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width * 0.25, height: rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }
}

extension String {
    var removingEmojis: String {
        return self.filter { !$0.isEmoji }
    }
}

extension Character {
    var isEmoji: Bool {
        // 判断是否为表情符号
        return (0x1F600...0x1F64F).contains(self.unicodeScalars.first!.value) ||  // Emoticons
        (0x1F300...0x1F5FF).contains(self.unicodeScalars.first!.value) ||  // Misc Symbols and Pictographs
        (0x1F680...0x1F6FF).contains(self.unicodeScalars.first!.value) ||  // Transport and Map
        (0x2600...0x26FF).contains(self.unicodeScalars.first!.value) ||   // Misc symbols
        (0x2700...0x27BF).contains(self.unicodeScalars.first!.value)      // Dingbats
    }
}

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
        if let window = UIApplication.shared.windows.first {
            let screenHeight = window.frame.size.height
            let toastHeight: CGFloat = 50
            let centerY = screenHeight / 2 - toastHeight / 2
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
        if phoneNumber.count == 11 {
            let start = phoneNumber.prefix(3)
            let end = phoneNumber.suffix(3)
            let masked = String(repeating: "*", count: phoneNumber.count - 6)
            return start + masked + end
        }
        return phoneNumber
    }
}

//无数据页面
class LLemptyView: UIView {
    
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
class NoNetView: UIView {
    
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
        refreshBtn.layoutButtonEdgeInsets(style: .left, space: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//获取当前控制器
extension UIViewController {
    class func getCurrentViewController() -> UIViewController {
        let rootVc = keyWindow?.rootViewController
        let currentVc = getCurrentViewController(rootVc!)
        return currentVc
    }
    
    class func getCurrentViewController(_ rootVc: UIViewController) -> UIViewController {
        var currentVc: UIViewController
        var rootCtr = rootVc
        if rootCtr.presentedViewController != nil {
            rootCtr = rootVc.presentedViewController!
        }
        if rootVc.isKind(of: UITabBarController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UITabBarController).selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
            currentVc = getCurrentViewController((rootVc as! UINavigationController).visibleViewController!)
        } else {
            currentVc = rootCtr
        }
        return currentVc
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
                          confirmTitle: String = "确认",
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
        let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cachePath, includingPropertiesForKeys: [.fileSizeKey], options: .skipsHiddenFiles)
            let totalSize = files.reduce(0) { total, fileURL in
                let fileSize = (try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
                return total + fileSize
            }
            return String(format: "%.2fMB", convertBytesToMB(totalSize))
        } catch {
            print("Error calculating cache size: \(error)")
            return "Error calculating size"
        }
    }
    
    /// 将字节转换为 MB
    static func convertBytesToMB(_ bytes: Int) -> Double {
        return Double(bytes) / 1024.0 / 1024.0
    }
    
    static func clearCache() {
        let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(at: cachePath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for file in files {
                try FileManager.default.removeItem(at: file)
            }
            print("Cache cleared")
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

//获取登录数据
class GetSaveLoginInfoConfig {
    
    static func getCustomerNumber() -> String {
        let customernumber = UserDefaults.standard.object(forKey: WDY_CUSTOMERNUMBER) as? String ?? ""
        return customernumber
    }
    
    static func getPhoneNumber() -> String {
        let phoneNum = UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
        return phoneNum
    }
    
    static func getSessionID() -> String {
        let token = UserDefaults.standard.object(forKey: WDY_SESSIONID) as? String ?? ""
        return token
    }
    
}

//获取手机号码
class GetPhoneNumberManager {
    static func getPhoneNum() -> String {
        return UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
    }
}

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
    
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
        return "ald.goods.\(comboNumber)"
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

//倒计时30分钟
class CountdownTimer {
    
    typealias CountdownUpdate = (String) -> Void
    // 定义倒计时完成后的回调
    typealias CountdownCompletion = () -> Void
    
    private var timer: Timer?
    private var remainingTime: Int
    
    // 初始化方法
    init(startTime: String, durationInMinutes: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let startDate = dateFormatter.date(from: startTime) else {
            fatalError("无效的起始时间格式")
        }
        
        let targetDate = startDate.addingTimeInterval(TimeInterval(durationInMinutes * 60))
        let currentTime = Date()
        self.remainingTime = Int(targetDate.timeIntervalSince(currentTime))
    }
    
    // 开始倒计时
    func startCountdown(update: @escaping CountdownUpdate, completion: @escaping CountdownCompletion) {
        // 如果倒计时已经结束，不启动定时器
        if remainingTime <= 0 {
            update("00:00") // 倒计时已结束
            completion()
            return
        }
        
        // 启动每秒触发的定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {  timer in
            //            guard let self = self else { return }
            
            // 更新剩余时间
            self.remainingTime -= 1
            
            // 计算分钟和秒数
            let minutes = self.remainingTime / 60
            let seconds = self.remainingTime % 60
            
            // 格式化为 "mm:ss" 格式
            let timeString = String(format: "00:%02d:%02d", minutes, seconds)
            
            // 每秒更新一次显示
            update(timeString)
            
            // 如果倒计时结束，停止定时器并执行完成回调
            if self.remainingTime <= 0 {
                timer.invalidate()
                update("00:00") // 倒计时结束时显示 00:00
                completion() // 执行完成回调
            }
        }
    }
    
    // 停止倒计时
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
}

class NoCopyTextField: WLUnitField {
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
    
    static func getRedStr(from count: String?, fullText: String, colorStr: String? = "#F55B5B") -> NSAttributedString {
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
                                          value: UIFont.regularFontOfSize(size: 14),
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
