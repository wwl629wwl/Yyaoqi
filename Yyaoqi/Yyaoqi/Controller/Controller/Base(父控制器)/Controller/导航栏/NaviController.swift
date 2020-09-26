//
//  NaviController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit

class NaviController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 调用布局函数
        setupLayout()
    }
    
    /// 布局函数
    func setupLayout() {
        
        // 右滑推出页面的手势
        guard let interactiveGes = interactivePopGestureRecognizer else { return }
        guard let targetView = interactiveGes.view else { return } // 该手势附加到的视图。通过使用addGestureRecognizer:方法向UIView添加识别器来设置
        guard let internalTargets = interactiveGes.value(forKeyPath: "targets") as? [NSObject] else { return } // 返回一个数组
        guard let internalTarget = internalTargets.first?.value(forKey: "target") else { return }
        let action = Selector(("handleNavigationTransition:")) // 一个方法
        
        let fullScreenGesture = UIPanGestureRecognizer(target: internalTarget, action: action) //处理用户拖动手势的手势处理器
        fullScreenGesture.delegate = self // 设置代理
        targetView.addGestureRecognizer(fullScreenGesture) // 添加手势
        interactiveGes.isEnabled = false //默认是肯定的。禁用的手势识别器将不会接收触摸。当更改为NO时，手势识别器将被取消，如果它目前正在识别一个手势
    }
    
    // push 隐藏标签栏
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 { viewController.hidesBottomBarWhenPushed = true }
        super.pushViewController(viewController, animated: animated)
    }
}

extension NaviController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRight ? 1 : -1) <= 0 || disablePopGesture {
            return false
        }
        return viewControllers.count != 1
    }
}

extension NaviController {
    // 设置状态栏的状态
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = topViewController else { return .lightContent }
        return topVC.preferredStatusBarStyle
    }
}

/// 枚举
enum NavigationBarStyle {
    case theme
    case clear
    case white
}

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var disablePopGesture: Void?
    }
    
    // 设置关联值
    var disablePopGesture: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.disablePopGesture) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func barStyle(_ style: NavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
    }
}

