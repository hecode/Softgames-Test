//
//  TestMessage.swift
//  Softgames TestTests
//
//  Created by ibrahim beltagy on 13/05/2022.
//

import Foundation
import WebKit

class TestMessage: WKScriptMessage {
    
    var bodyTest: Any
    var nameTest: String
    var webViewTest: WKWebView?
    
    init(body: Any, webView: WKWebView, name: String) {
        self.bodyTest = body
        self.webViewTest = webView
        self.nameTest = name
        
        super.init()
    }
    
}
