//
//  BaseController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

// 倒入需要用的包 后面这个类用于继承
import UIKit
import SnapKit
import Then
import Reusable
import Kingfisher


class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        if #available(iOS 11.0, *) { //配置调整dcontentinset的行为 默认是UIScrollViewContentInsetAdjustmentAutomatic
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        setupLayout()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    /// 提供给子类继承重写的设置布局的方法
    func setupLayout() {}
    
    /// 设置NavigationBar的方法
    func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self { // 如果存在，返回模态视图控制器。否则就是顶视图控制器。
            navi.barStyle(.theme)
            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(pressBack))
            }
        }
    }
    
    // 左边按钮的点击事件
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }
}


extension BaseController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // 设置 Bar的Style
    }
}

