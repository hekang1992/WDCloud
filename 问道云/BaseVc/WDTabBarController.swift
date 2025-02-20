//
//  WDTabBarController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class WDTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBar设置
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        let homeVC = WDHomeViewController()
        let riskVc = WDRiskViewController()
        var diligenceVc = WDBaseViewController()
        let centerVC = WDCenterViewController()
        if IS_LOGIN {
            diligenceVc = DueDiligenceViewController()
        }else {
            diligenceVc = WDDiligenceViewController()
        }
        
        homeVC.tabBarItem = UITabBarItem(
            title: "首页",
            image: UIImage(named: "home_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "home_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        riskVc.tabBarItem = UITabBarItem(
            title: "风控",
            image: UIImage(named: "risk_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "risk_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        diligenceVc.tabBarItem = UITabBarItem(
            title: "尽调",
            image: UIImage(named: "dili_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "dili_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        centerVC.tabBarItem = UITabBarItem(
            title: "我的",
            image: UIImage(named: "center_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "center_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        viewControllers = [
            WDNavigationController(rootViewController: homeVC),
            WDNavigationController(rootViewController: riskVc),
            WDNavigationController(rootViewController: diligenceVc),
            WDNavigationController(rootViewController: centerVC)
        ]
        
        // 设置字体样式
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.mediumFontOfSize(size: 12),
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD")!
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.mediumFontOfSize(size: 12),
            .foregroundColor: UIColor.init(cssStr: "#27344B")!
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // 设置代理
        self.delegate = self
    }
    
    // 监听 TabBarItem 被点击时触发的事件
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 获取选中的 TabBarItem
        HapticFeedbackManager.triggerImpactFeedback(style: .medium)
        guard let selectedItem = tabBarController.tabBar.selectedItem else { return }
        // 获取被点击 TabBarItem 对应的视图
        if let selectedView = selectedItem.value(forKey: "view") as? UIView {
            // 获取 TabBar 图标的 ImageView
            if let imageView = selectedView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                // 创建缩放动画
                let scaleUp = CABasicAnimation(keyPath: "transform.scale")
                scaleUp.fromValue = 1.0
                scaleUp.toValue = 1.1
                scaleUp.duration = 0.1
                scaleUp.autoreverses = true // 动画完成后回到原来的大小
                scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                // 将动画应用到选中的 TabBarItem 图标上
                imageView.layer.add(scaleUp, forKey: nil)
            }
        }
    }
    
}
