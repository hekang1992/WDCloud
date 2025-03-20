//
//  FadeTransition.swift
//  问道云
//
//  Created by Andrew on 2025/3/18.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    // 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // 动画时长 0.5 秒
    }

    // 动画实现
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取目标视图控制器
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        // 获取容器视图
        let containerView = transitionContext.containerView

        // 设置目标视图的初始状态（完全透明）
        toViewController.view.alpha = 0

        // 将目标视图添加到容器视图中
        containerView.addSubview(toViewController.view)

        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // 当前视图淡出
            fromViewController.view.alpha = 0
            // 目标视图淡入
            toViewController.view.alpha = 1
        }, completion: { _ in
            // 动画完成后通知系统
            fromViewController.view.alpha = 1 // 恢复原始状态
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
