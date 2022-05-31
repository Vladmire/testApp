//
//  FullScreenViewController.swift
//  testApp
//
//  Created by imac44 on 31.05.2022.
//

import TinyConstraints
import WebKit

class FullScreenViewController: UIViewController, WKUIDelegate {
    
    private var webView: WKWebView!
    private var currentData: Data
    
    init(currentData: Data) {
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
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let myURL = URL(string: currentData.url) else {
            return
        }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    func update(data: Data) {
        currentData = data
    }
}
