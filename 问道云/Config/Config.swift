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
    
    static var statusBarHeight:CGFloat {
        var height: CGFloat = 20.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            height = window.safeAreaInsets.top
        }
        return height
    }
    
    static var navigationBarHeight:CGFloat {
        var navBarHeight: CGFloat = 64.0;
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!!
            let safeTop = window.safeAreaInsets.top
            navBarHeight = safeTop > 0 ? (safeTop + 44) : 44
        }
        return navBarHeight
    }
    
    static var safeAreaBottomHeight:CGFloat {
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






