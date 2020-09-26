//
//  TabBarController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false // 通过将属性设置为NO，可以强制设置不透明背景。
        
        setupLayout()
    }
    
    /// 布局函数
    func setupLayout() {
        //1.首页
        let onePageVC = UIViewController()
        addChildController(onePageVC, title: "首页",
                           image: UIImage(named: "tab_home"),
                           selectdImage: UIImage(named: "tab_home_S"))
        
        //2.分类
        let classVC = UIViewController()
        addChildController(classVC, title: "分类",
                           image: UIImage(named: "tab_class"),
                           selectdImage: UIImage(named: "tab_class_S"))
        
        //3.书架
        let bookVC = UIViewController()
        addChildController(bookVC, title: "书架",
                           image: UIImage(named: "tab_book"),
                           selectdImage: UIImage(named: "tab_book_S"))
        
        // 4.我的
        let mineVC = MineController()
        addChildController(mineVC,
                               title: "我的",
                               image: UIImage(named: "tab_mine"),
                               selectdImage: UIImage(named: "tab_mine_S"))
    }
    
    
    func addChildController(_ childController: UIViewController, title: String?, image: UIImage?, selectdImage: UIImage?) {
        
        // 始终绘制图片原始状态，不使用Tint Color。 withRenderingMode(.alwaysOriginal)
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectdImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) // 设置Insets
        }
        addChild(NaviController(rootViewController: childController)) //把控制器添加到NaviController 在加到Tabbarcontroller
    }
}

extension TabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent } // 如果不是被选中 返回lightContent
        return select.preferredStatusBarStyle // 否则返回选中的style
    }
}

