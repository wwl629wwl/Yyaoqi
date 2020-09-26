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

