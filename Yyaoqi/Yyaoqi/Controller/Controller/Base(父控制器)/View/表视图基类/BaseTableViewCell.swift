//
//  BaseTableViewCell.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell, Reusable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none // 选择时的状态为none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 公开给子类重写的设置UI的方法
    open func setupUI() {}
}

