//
//  ComicCollectionHeaderView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/10.
//

import UIKit

// 自定义闭包函数
typealias ComicCollectionHeaderMoreActionBlock = () -> Void

// 代理
protocol ComicCollecHeaderViewDelegate: class {
    func comicCollectionHeaderView(_ comicCHead: ComicCollectionHeaderView, moreAction button: UIButton)
}

class ComicCollectionHeaderView: BaseCollectionReusableView {
    
    // 代理声明 弱引用
    weak var delegate: ComicCollecHeaderViewDelegate?
    // 回调声明 相当于 oc中的 block
    private var moreActionClosure: ComicCollectionHeaderMoreActionBlock?
    
    lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("•••", for: .normal)
        mn.setTitleColor(UIColor.lightGray, for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        mn.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
        return mn
    }()
    
    @objc func moreActionClick(button: UIButton) {
        delegate?.comicCollectionHeaderView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: ComicCollectionHeaderMoreActionBlock?) {
        moreActionClosure = closure
    }
    
    // 继承父类方法 布局
    override func setupLayout() {
        
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(5)
            make.centerY.height.equalTo(iconView)
            make.width.equalTo(200)
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
    }
    
}
