//
//  Global.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import MJRefresh

// MARK: - 应用默认颜色
extension UIColor {
    class var background: UIColor { // 类属性 返回一个UIColor
        return UIColor(r: 242, g: 242, b: 242)
    }
    
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 43)
    }
}

// MARK: - 扩展通知的name
extension NSNotification.Name {
    static let USexTypeDidChange = NSNotification.Name("USexTypeDidChange")
}
    
// MARK: - 扩展String 添加两个常量
extension String {
    static let searchHistoryKey = "searchHistoryKey"
    static let sexTypeKey = "sexTypeKey"
}

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height


var topVC: UIViewController? {
    var resultVC: UIViewController?
    resultVC = _topVC((UIApplication.shared.keyWindow?.rootViewController)!)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC((resultVC?.presentedViewController)!)
    }
    return resultVC
}

/// 判断是否是全面屏手机
var isIphoneX: Bool {
    return UI_USER_INTERFACE_IDIOM() == .phone
        && (max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 812
            || max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) == 896)
}

private func _topVC(_ vc: UIViewController) -> UIViewController? {
    if vc is UINavigationController {
        return _topVC(((vc as? UINavigationController)?.topViewController)!)
    } else if vc is UITabBarController {
        return _topVC(((vc as? UITabBarController)?.selectedViewController)!)
    } else {
        return vc
    }
}

// MARK: - print
func uLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}


//MARK: SnapKit
extension ConstraintView {
    
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}


// MARK: - kingfiser
extension Kingfisher where Base: ImageView {
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        placeholder: placeholder,
                        options:[.transition(.fade(0.5))])
    }
}

extension Kingfisher where Base: UIButton {
    @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
        return setImage(with: URL(string: urlString ?? ""),
                        for: state,
                        placeholder: placeholder,
                        options: [.transition(.fade(0.5))])
        
    }
}

extension UICollectionView {
    
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView.performWithoutAnimation {
                reloadData()
            }
        }
    }
}
