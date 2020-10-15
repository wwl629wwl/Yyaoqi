//
//  StringExtension.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/15.
//

import Foundation


extension String {
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
}
