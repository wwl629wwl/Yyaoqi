//
//  UIColorExtension.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit


extension UIColor {
    /// 便捷初始化器
    convenience init(r: UInt32, g: UInt32, b: UInt32, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    /// 一个类属性 返回一个随机颜色
    class var random: UIColor {
        return UIColor(r: arc4random_uniform(256),
                       g: arc4random_uniform(256),
                       b: arc4random_uniform(256))
    }
    
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size) // 它会创建一个基于位图的上下文(context)（默认创建一个透明的位图上下文）,并将其设置为当前上下文。
        let context = UIGraphicsGetCurrentContext() // 获取上下文
        context?.setFillColor(self.cgColor) // 设置颜色
        context?.fill(rect) // 绘制
        let image = UIGraphicsGetImageFromCurrentImageContext() // 获取到这张图片
        UIGraphicsEndImageContext() // 关闭图形上下文
        return image!
    }
    
    class func hex(hexString: String) -> UIColor {
        // 返回一个新字符串，该字符串通过从两端删除 包含在给定字符集中的“字符串”字符。
        // 返回包含Unicode通用类别Z*、' U+000A ~ U+000D '和' U+0085 '中的字符的字符集。
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2 // 从 2 这个位置开始 向后截取两个2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4 // 从 4 这个位置开始 向后截取两个2
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: r, g: g, b: b)
    }
}

