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
        searchBar.placeholder = "输入漫画名称/作者" // 键盘上显示的文字
        searchBar.layer.cornerRadius = 15
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        searchBar.leftViewMode = .always
        searchBar.clearsOnBeginEditing = true
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(noti:)), name: UITextField.textDidChangeNotification, object: searchBar) // 添加通知
        return searchBar
    }()
    
    private lazy var historyTableView: UITableView = {
        let historyTableView = UITableView(frame: CGRect.zero, style: .grouped)
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(cellType: BaseTableViewCell.self) // 注册cell
        historyTableView.register(headerFooterViewType: SearchFootView.self) // 注册尾部
        historyTableView.register(headerFooterViewType: SearchHeadView.self) // 注册头部
        return historyTableView
    }()
    
    lazy var searchTableView: UITableView = {
        let searchTableView = UITableView(frame: CGRect.zero, style: .grouped)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(headerFooterViewType: SearchHeadView.self)
        searchTableView.register(cellType: BaseTableViewCell.self)
        return searchTableView
    }()
    
    private lazy var resultTableView: UITableView = {
        let resultTableView = UITableView()
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.register(cellType: ComicTVCell.self)
        return resultTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载历史数据
        setupLoadHistory()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // 移除通知
    }
    
    private func setupLoadHistory() {
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
        ApiLoadingProvider.request(Api.searchHot, model: HotItemsModel.self) { (resultData) in
            self.hotItems = resultData?.hotItems
            self.historyTableView.reloadData() // 页面刷新
        }
    }
    
    private func searchRelative(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
            currentRequest?.cancel()
            currentRequest = ApiLoadingProvider.request(Api.searchRelative(inputText: text), model: [SearchItemModel].self, completion: { (returnData) in
                self.relative = returnData
                self.searchTableView.reloadData() // 页面刷新
            })
        } else {
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    private func searchResult(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            searchBar.text = text
            ApiLoadingProvider.request(Api.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (returnData) in
                self.comics = returnData?.comics
                self.resultTableView.reloadData()
            }
            
            let defaults = UserDefaults.standard
            var histoary = defaults.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
            histoary.removeAll([text]) // 从历史中移除
            histoary.insertFirst(text) // 并添加到历史数组中的第一个
            
            searchHistory = histoary
            historyTableView.reloadData()
            
            defaults.set(searchHistory, forKey: String.searchHistoryKey)
            defaults.synchronize()
        } else {
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    override func setupLayout() {
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints { make in make.edges.equalTo(self.view.usnp.edges) }
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { make in make.edges.equalTo(self.view.usnp.edges) }
        
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { make in make.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(cancelAction))
    }
    
    @objc private func cancelAction() {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension SearchController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(noti: Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 0 ? (searchHistory.prefix(5).count ?? 0) : 0
        } else if tableView == searchTableView {
            return relative?.count ?? 0
        } else {
            return comics?.count ??  0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicTVCell.self)
            cell.model = comics?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            searchResult(searchHistory[indexPath.row])
        } else if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        } else if tableView == resultTableView {
            guard let model = comics?[indexPath.row] else { return }
            let vc = ComicController(comicid: model.comicId)
            navigationController?.pushViewController(vc, animated: true) // push到这个vc
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTableView {
            let head = tableView.dequeueReusableHeaderFooterView(SearchHeadView.self)
            head?.titleLabel.text = section == 0 ? "看看大家在搜什么" : "大家都在搜"
            head?.moreButton.setImage(section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh"), for: .normal)
            head?.moreButton.isHidden = section == 0 ? (searchHistory.count == 0) : false
            head?.moreActionClosure({ [weak self] in
                if section == 0 {
                    self?.searchHistory?.removeAll()
                    self?.historyTableView.reloadData()
                    UserDefaults.standard.removeObject(forKey: String.searchHistoryKey)
                    UserDefaults.standard.synchronize()
                } else {
                    self?.setupLoadHistory()
                }
                
            })
            return head
        } else if tableView == searchTableView {
            let head = tableView.dequeueReusableHeaderFooterView(SearchHeadView.self)
            head?.titleLabel.text = "找到相关的漫画 \(comics?.count ?? 0) 本"
            head?.moreButton.isHidden = true
            return head
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return section == 0 ? 10 : tableView.frame.height - 44
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { // 设置尾部
        if tableView == historyTableView && section == 1 {
            let foot = tableView.dequeueReusableHeaderFooterView(SearchFootView.self)
            foot?.data = hotItems ?? []
            foot?.didSelectIndexClosure({[weak self] (index, model) in
                let vc = ComicController(comicid: model.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            return foot
        } else {
            return nil
        }
    }
}

