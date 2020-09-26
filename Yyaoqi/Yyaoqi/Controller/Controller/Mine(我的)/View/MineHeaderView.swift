//
//  MineHeaderView.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit

class MineHeaderView: UIView {
    
    private lazy var bgView: UIImageView = {
        let bw = UIImageView()
        bw.contentMode = .scaleAspectFill // 内容缩放以填充固定的方面。部分内容可能会被裁剪。
        return bw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout() // 初始化的时候调用布局函数
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 布局函数
    func setupLayout() {
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 添加通知
        NotificationCenter.default.addObserver(self, selector: #selector(sexTypeDidChange), name: .USexTypeDidChange, object: nil)
        sexTypeDidChange()
    }
    
    // 通知执行的方法
    @objc func sexTypeDidChange() {
        let sexType = UserDefaults.standard.integer(forKey: String.sexTypeKey)
        if sexType == 1 {
            bgView.image = UIImage(named: "mine_bg_for_boy")
        } else {
            bgView.image = UIImage(named: "mine_bg_for_girl")
        }
    }
}

