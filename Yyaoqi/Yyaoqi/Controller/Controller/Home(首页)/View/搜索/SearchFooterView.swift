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
        let layout = UCollectionViewAlignedLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.horizontalAlignment = .left
        layout.estimatedItemSize = CGSize(width: 100, height: 40) // 设置 item的大小 默认是 cgsizezero
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: SearchCollectionViewCell.self)
        return collectionView
    }()
    
    var data: [SearchItemModel] = [] {
        didSet {
            collectionView.reloadData() // 这个属性被设置的时候 collectionView 刷新
        }
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in make.edges.equalToSuperview() }
    }
}

extension SearchFootView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchCollectionViewCell.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5 // 给cell设置圆角
        cell.titleLabel.text = data[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchFootViewDelegate(self, didSelectItemAt: indexPath.row, data[indexPath.row])
        
        guard let closure = didSelectIndexClosure else { return }
        closure(indexPath.row, data[indexPath.row]) // 调用闭包
    }
    
    func didSelectIndexClosure(_ closure: @escaping SearchTFootDidSelectIndexClosure) {
        didSelectIndexClosure = closure // 闭包调用函数给闭包赋值
    }
}

