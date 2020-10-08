//
//  BaseTableViewHeaderFooterView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/28.
//

import Reusable

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView, Reusable {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 公开给子类重写的设置layout的方法
    open func setupLayout() {}
}
