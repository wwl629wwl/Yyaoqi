//
//  HomeController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit

class HomeController: PageController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar() // 设置右边的按钮并添加点击事件
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(searchButtonClick))
    }
    
    @objc func searchButtonClick() {
        navigationController?.pushViewController(SearchController(), animated: true)
    }
}
