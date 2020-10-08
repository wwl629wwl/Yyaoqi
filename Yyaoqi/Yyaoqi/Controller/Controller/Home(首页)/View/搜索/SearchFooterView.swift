//
//  SearchFooterView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/28.
//

import UIKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkGray
        return titleLabel
    }()
    
    override func setNeedsLayout() {
        layer.borderWidth = 1 // 设置边框宽度
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
}

typealias SearchTFootDidSelectIndexClosure = (_ index: Int, _ model: SearchItemModel) -> Void // 自定义闭包类型

protocol SearchFootViewDelegate: class {
    func searchFootViewDelegate(_ searchFootView: SearchFootView, didSelectItemAt index: Int, _ model: SearchItemModel) // 协议方法
}


class SearchFootView: BaseTableViewHeaderFooterView {
    
    weak var delegate: SearchFootViewDelegate? // 代理
    
    private var didSelectIndexClosure: SearchTFootDidSelectIndexClosure? // 闭包函数
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()
}

extension SearchFootView {
    
}

