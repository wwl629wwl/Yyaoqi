//
//  HomeCommentController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/10.
//

import UIKit
import LLCycleScrollView

class HomeCommentController: BaseController {
    
    
    // 性别
    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    // 模型
    private var galleryItems = [GalleryItemModel]()
    private var textItems = [TextItemModel]()
    private var comicLists = [ComicListModel]()
    
    
}
