//
//  ComicController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/8.
//

import UIKit

protocol ComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class ComicController: BaseController {
    
    private var comicid: Int = 0
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
}
