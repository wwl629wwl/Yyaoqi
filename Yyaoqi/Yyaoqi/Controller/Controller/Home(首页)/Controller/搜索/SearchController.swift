//
//  SearchController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/9/27.
//

import UIKit
import Moya

class SearchController: BaseController {
    
    private var currentRequest: Cancellable?
    private var hotItems: [SearchItemModel]?
    private var relative: [SearchItemModel]?
    private var comics: [ComicModel]?
    
    private lazy var searchHistory: [String]! = {
        return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    
    private lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.backgroundColor = UIColor.white
        searchBar.textColor = UIColor.gray
        searchBar.tintColor = UIColor.darkGray
        searchBar.font = UIFont.systemFont(ofSize: 15)
        searchBar.placeholder = "输入漫画名称/作者"
        searchBar.layer.cornerRadius = 15
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        searchBar.leftViewMode = .always
        searchBar.clearsOnBeginEditing = true
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var historyTableView: UITableView = {
        let historyTableView = UITableView(frame: CGRect.zero, style: .grouped)
        
        return historyTableView
    }()
}


extension SearchController: UITextFieldDelegate {
    
}
