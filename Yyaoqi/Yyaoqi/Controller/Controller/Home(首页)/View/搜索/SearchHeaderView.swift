//
//  SearchHeaderView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/27.
//

import UIKit


typealias SearchHeadMoreActionClosure = () -> Void

protocol SearchHeadViewDelegate: class {
    func searchHeadView(_ searchHead: SearchHeadView, moreAction button: UIButton)
    
}

class SearchHeadView: BaseTableViewHeaderFooterView {
    
    weak var delegate: SearchHeadViewDelegate? // 代理
    
    private var moreActionClosure: SearchHeadMoreActionClosure? // 闭包函数
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton()
        moreButton.setTitleColor(UIColor.lightGray, for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside) // 按钮添加点击方法
        return moreButton
    }()
    
    @objc private func moreAction(button: UIButton) {
        delegate?.searchHeadView(self, moreAction: moreButton)
        
        guard let closure = moreActionClosure else { return }
        
        closure() // 执行闭包
    }
    
    func moreActionClosure(_ closure: @escaping SearchHeadMoreActionClosure) {
        moreActionClosure = closure
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        let line = UIView().then{ $0.backgroundColor = UIColor.background }
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
