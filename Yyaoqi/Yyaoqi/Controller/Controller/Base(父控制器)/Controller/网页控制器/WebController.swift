//
//  WebController.swift
//  Yyaoqi
//
//  Created by 凑巧 on 2020/10/15.
//

import UIKit
import WebKit

class WebController: BaseController {
    
    var request: URLRequest!
    
    lazy var webview: WKWebView = {
        let webview = WKWebView()
        webview.allowsBackForwardNavigationGestures = true // 允许使用navigation的手势
        webview.navigationDelegate = self
        webview.uiDelegate = self
        return webview
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView  = UIProgressView()
        progressView.trackImage = UIImage(named: "nav_bg")
        progressView.progressTintColor = UIColor.white
        return progressView
    }()
    
    // 便捷构造器
    convenience init(url: String) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "" )!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil) // 添加观察者
        
        webview.load(request)
    }
    
    override func setupLayout() {
        view.addSubview(webview)
        webview.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(reload))
    }
    
    override func pressBack() {
        if webview.canGoBack {
            webview.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    /// 按钮的点击方法
    @objc func reload() {
        webview.reload()
    }
}

extension WebController: WKNavigationDelegate, WKUIDelegate {
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webview.estimatedProgress >= 1
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
