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
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentData.imageName

        
//        guard let imagePath = DataAPI.shared.imagePath(fileName: currentData.imageName)?.absoluteString else {
//            return
//        }
//        var Path = imagePath
//        print(Path)
//        Path.removeFirst(4)
//        print(Path)
        
        let html = """
        <html>
            <body s>
                <h1 style="text-align:center; font-size: 100px; font-weight: bold; color: red;">\(currentData.imageName)</h1>
                <img src="\(currentData.url)" width=100% alt="\(currentData.url)">
                <h1 style="text-align:center; font-size: 80px;">lat: \(currentData.lat)</h1>
                <h1 style="text-align:center; font-size: 80px;">long: \(currentData.long)</h1>
                <div style="text-align:center; font-size: 80px;">
                    <a href="\(currentData.url)">link to original</a>
                </div>
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
