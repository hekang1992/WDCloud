//
//  WebPageViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/4.
//

import UIKit
import RxRelay
@preconcurrency import WebKit
import UniformTypeIdentifiers

class WebPageViewController: WDBaseViewController {
    
    var completionHandler: (([URL]?) -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    lazy var webView: WKWebView = {
        // 1. 创建 WKWebView 配置
        let config = WKWebViewConfiguration()
        // 2. 注入 JavaScript 代码
        let scriptStr = "window.ALDClient = {};ALDClient.callNative = function(method, arg) { return prompt(method, arg)};"
        let cookieScript = WKUserScript(
            source: scriptStr,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        config.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        config.userContentController.addUserScript(cookieScript)
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }()
    
    var pageUrl = BehaviorRelay<String>(value: "")
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = UIColor.init(cssStr: "#5AD7F6")
        progressView.trackTintColor = UIColor.init(cssStr: "#F7F7F6")
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(StatusHeightManager.statusBarHeight + 56)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        
        webView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        webView.rx.observe(String.self, "title")
            .subscribe(onNext: { [weak self] title in
                DispatchQueue.main.async {
                    self?.headView.titlelabel.text = title ?? ""
                }
            }).disposed(by: disposeBag)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .map { Float($0) }
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .compactMap { $0 }
            .filter { $0 == 1.0 }
            .subscribe(onNext: { [weak self] _ in
                self?.progressView.setProgress(0.0, animated: false)
                self?.progressView.isHidden = true
            })
            .disposed(by: disposeBag)
        
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
        let webUrl = pageUrl.value.replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: webUrl) {
            webView.load(URLRequest(url: url))
        }
        print("pageurl=====\(webUrl)")
        //        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
        //            let htmlURL = URL(fileURLWithPath: htmlPath)
        //            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL)
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if AppDelegate.shared.isLandscape == true {
            disableLandscape()
        }
    }
    
}

extension WebPageViewController: WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message:\(message.name)")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("prompt==js交互方法===\(prompt)")
        completionHandler(callByWeb(method: prompt, arg: defaultText))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("Intercepting URL: \(url)")
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ViewHud.addLoadView()
        DispatchQueue.main.asyncAfter(delay: 60) {
            ViewHud.hideLoadView()
        }
        print("开始加载======开始加载")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ViewHud.hideLoadView()
        print("结束加载======结束加载")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ViewHud.hideLoadView()
        print("加载失败======加载失败")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ViewHud.hideLoadView()
        print("网站无法打开，错误: \(error.localizedDescription)")
        DispatchQueue.main.asyncAfter(delay: 0.25) {
            self.showAlert(message: "无法打开网站，请检查网络或URL是否正确")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func callByWeb(method: String?, arg: String?) -> String? {
        if method == "set_title" {
            self.headView.titlelabel.text = arg
        }else if method == "get_token" {
            let token = GetSaveLoginInfoConfig.getSessionID()
            return token
        }else if method == "close" {
            self.navigationController?.popViewController(animated: true)
        }else if method == "enable_landscape" {
            enableLandscape()
        }else if method == "open_pdf_url" {
            if let url = URL(string: arg ?? "") {
                self.webView.load(URLRequest(url: url))
            }
        }else if method == "to_ent_info" {
            let companyDetailVc = CompanyBothViewController()
            let enityId = arg ?? ""
            companyDetailVc.enityId.accept(enityId)
            self.navigationController?.pushViewController(companyDetailVc, animated: true)
        }else if method == "to_person_info" {
            let peopleDetailVc = PeopleBothViewController()
            let personId = arg ?? ""
            peopleDetailVc.personId.accept(personId)
            self.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        return ""
    }
    
    //横屏
    func enableLandscape() {
        AppDelegate.shared.isLandscape = true
        DispatchQueue.main.asyncAfter(delay: 1.0) {
            let windowScene = UIApplication.shared.connectedScenes.first
            if #available(iOS 16.0, *) {
                self.navigationController?.tabBarController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .landscapeRight)
                (windowScene as? UIWindowScene)?.requestGeometryUpdate(preferences, errorHandler: { error in
                    print(error)
                })
            } else {
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            }
        }
    }
    
    //取消横屏
    func disableLandscape() {
        AppDelegate.shared.isLandscape = false
        let windowScene = UIApplication.shared.connectedScenes.first
        if #available(iOS 16.0, *) {
            self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            let preferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
            (windowScene as? UIWindowScene)?.requestGeometryUpdate(preferences, errorHandler: { error in
            })
        } else {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
}

// 暂时不用，先留着吧
extension WebPageViewController: UIDocumentPickerDelegate {
    
    func openFolder() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, .xml])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // 用户取消了选择
        print("User cancelled folder selection")
    }
    
}
