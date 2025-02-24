//
//  PropertyTabBarController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class PropertyTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBar设置
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        let oneVc = PropertyOneViewController()
        let twoVc = PropertyTwoViewController()
        let threeVc = PropertyThreeViewController()
        let fourVc = PropertyFourViewController()
        
        oneVc.tabBarItem = UITabBarItem(
            title: "财产线索",
            image: UIImage(named: "checkone_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "checkone_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        twoVc.tabBarItem = UITabBarItem(
            title: "线索监控",
            image: UIImage(named: "checktwo_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "checktwo_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        threeVc.tabBarItem = UITabBarItem(
            title: "监控列表",
            image: UIImage(named: "checkthree_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "checkthree_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        fourVc.tabBarItem = UITabBarItem(
            title: "我的",
            image: UIImage(named: "checkfour_nor")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "checkfour_sel")?.withRenderingMode(.alwaysOriginal)
        )
        
        oneVc.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        twoVc.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        threeVc.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        fourVc.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewControllers = [
            WDNavigationController(rootViewController: oneVc),
            WDNavigationController(rootViewController: twoVc),
            WDNavigationController(rootViewController: threeVc),
            WDNavigationController(rootViewController: fourVc)
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
