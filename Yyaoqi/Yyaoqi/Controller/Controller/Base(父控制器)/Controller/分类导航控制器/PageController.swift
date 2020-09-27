//
//  PageController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/26.
//

import UIKit
import HMSegmentedControl

enum PageStyle {
    case none
    case navgationBarSegment
    case topTabBar
}

class PageController: BaseController {
    
    var pageStyle: PageStyle!
    
    lazy var segement: HMSegmentedControl = {
        return HMSegmentedControl().then {
            $0.addTarget(self, action: #selector(changeIndex), for: .valueChanged)
        }
    }()
    
    lazy var pageVC: UIPageViewController = {
        return UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }()
    
    private(set) var vcs: [UIViewController]! // 不可读的数组
    private(set) var titles: [String]! // 不可读的数组
    private var currentSelectIndex: Int = 0
    
    /// 便捷初始化器
    convenience init(titles: [String] = [], vcs: [UIViewController] = [], pageStyle: PageStyle = .none) {
        self.init()
        self.titles = titles
        self.vcs = vcs
        self.pageStyle = pageStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc func changeIndex(segement: UISegmentedControl) {
        let index = segement.selectedSegmentIndex
        if currentSelectIndex != index {
            let target:[UIViewController] = [vcs[index]]
            let direction:UIPageViewController.NavigationDirection = currentSelectIndex > index ?
                .reverse :.forward
            pageVC.setViewControllers(target, direction: direction, animated: false) { [weak self] // 避免循环引用
                (finish) in
                self?.currentSelectIndex = index
            }
        }
    }
    
    override func setupLayout() {
        guard let vcs = vcs else { return }
        addChild(pageVC)
        view.addSubview(pageVC.view)
        
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)
        
        switch pageStyle {
        case .none:
            pageVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        case .navgationBarSegment?:
            segement.backgroundColor = UIColor.clear
            segement.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                UIColor.white.withAlphaComponent(0.5),
                                            NSAttributedString.Key.font:
                                                UIFont.systemFont(ofSize: 20)
            ]
            segement.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                        UIColor.white,
                                                    NSAttributedString.Key.font:
                                                        UIFont.systemFont(ofSize: 20)
            ]
            
            segement.selectionIndicatorLocation = .none
            navigationItem.titleView = segement
            segement.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 120, height: 40)
            
            pageVC.view.snp.makeConstraints{ $0.edges.equalToSuperview() }
        case .topTabBar?:
            segement.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            segement.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(r: 127, g: 221, b: 146),
                                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            segement.selectionIndicatorLocation = .down
            segement.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146)
            segement.selectionIndicatorHeight = 2
            segement.borderType = .bottom
            segement.borderColor = UIColor.lightGray
            segement.borderWidth = 0.5
            
            view.addSubview(segement)
            segement.snp.makeConstraints {
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(40)
            }
            
            pageVC.view.snp.makeConstraints {
                $0.top.equalTo(segement.snp.bottom)
                $0.left.right.bottom.equalToSuperview()
            }
        default: break
        }
        
        guard let titles = titles else { return }
        segement.sectionTitles = titles
        currentSelectIndex = 0
        segement.selectedSegmentIndex = UInt(currentSelectIndex)
    }
}


extension PageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else { return nil }
        return vcs[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else { return nil }
        let afterIndex = index + 1
        guard afterIndex <= vcs.count - 1 else { return nil }
        return vcs[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.last,
            let index = vcs.firstIndex(of: viewController) else {
                return
        }
        currentSelectIndex = index
        segement.setSelectedSegmentIndex(UInt(index), animated: true)
        guard titles != nil && pageStyle == .none else { return }
        navigationItem.title = titles[index]
    }
}
