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
    
    private lazy var bannerView: LLCycleScrollView = {
        let cycleScrollView = LLCycleScrollView()
        cycleScrollView.backgroundColor = UIColor.background
        cycleScrollView.autoScrollTimeInterval = 6
        cycleScrollView.placeHolderImage = UIImage(named: "normal_placeholder")
        cycleScrollView.coverImage = UIImage()
        cycleScrollView.pageControlPosition = .center
        cycleScrollView.pageControlBottom = 20
        cycleScrollView.titleBackgroundColor = UIColor.clear
        // 点击 item 回调
        cycleScrollView.lldidSelectItemAtIndex = didSelectBanner(index:)
        return cycleScrollView
    }()
    
    private func didSelectBanner(index: NSInteger) {
        let item = galleryItems[index]
        if item.linkType == 2 {
            guard let url = item.ext?.compactMap({
                return $0.key == "url" ? $0.val : nil
            }).joined() else {
                return
            }
            let vc = WebController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let comicIdString = item.ext?.compactMap({
                return $0.key == "comicId" ? $0.val : nil
            }).joined(),
                
                let comicId = Int(comicIdString) else { return }
            let vc = ComicController(comicid: comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
