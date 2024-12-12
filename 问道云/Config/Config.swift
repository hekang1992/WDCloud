//
//  Config.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import Lottie
import Toaster

let ROOT_VC = "ROOT_VC"

let SCREEN_WIDTH = UIScreen.main.bounds.size.width

let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

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
            let end = phoneNumber.suffix(2)
            let masked = String(repeating: "*", count: phoneNumber.count - 5)
            return start + masked + end
        }
        return phoneNumber
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

//无数据页面
class LLemptyView: UIView {
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
        addSubview(bgImageView)
        addSubview(mlabel)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 163, height: 163))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(10)
            make.height.equalTo(21)
        }
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
                          confirmTitle: String = "确定",
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
