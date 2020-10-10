//
//  BaseCollectionReusableView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/10.
//

import Reusable

class BaseCollectionReusableView: UICollectionReusableView,Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupLayout() {}
}
