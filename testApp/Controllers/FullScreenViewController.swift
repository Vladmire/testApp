//
//  FullScreenViewController.swift
//  testApp
//
//  Created by imac44 on 31.05.2022.
//

import TinyConstraints
import WebKit

class FullScreenViewController: UIViewController, WKUIDelegate{
    
    private var webView: WKWebView!
    private var currentData: FullInfo
    
    init(currentData: FullInfo) {
        self.currentData = currentData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentData.imageName
        let html = """
        <html>
            <body>
                <h1 style="text-align:center; font-size: 100px; font-weight: bold; color: red;">\(currentData.imageName)</h1>
                <div style="text-align:center;font-size: 80px;">
                    <a href="\(currentData.url)">link to original</a>
                </div>
                <img src="\(currentData.url)" width=100% alt="">
                <h2 style="text-align:center;font-size: 80px;">lat: \(currentData.lat)</h2>
                <h2 style="text-align:center;font-size: 80px;">long: \(currentData.long)</h2
            </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}

extension FullScreenViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard case .linkActivated = navigationAction.navigationType,
                  let url = navigationAction.request.url
            else {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            UIApplication.shared.open(url)
       }
}
