//
//  ViewController.swift
//  Softgames Test
//
//  Created by ibrahim beltagy on 13/05/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
}


// MARK: - Setup -

extension ViewController {
    
    func setup() {
        webView.configuration.userContentController.add(self,
                                                        name: "NativeJavascriptInterface")
        
        do {
            guard let filePath = Bundle.main.path(forResource: "myPage", ofType: "html")
            else {
                // File Error
                print ("File reading error")
                return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
    }
    
}


// MARK: - Swift to JS Actions -

extension ViewController {
    
    func mergeAndUpdateNames(_ dict: NSDictionary) {
        let fname = dict["fname"] as? String ?? ""
        let lname = dict["lname"] as? String ?? ""
        let fullName = fname + " " + lname
        print("setFullName(\"\(fullName)\");")
        webView.evaluateJavaScript("setFullName(\"\(fullName)\");", completionHandler: nil)
    }
    
}


// MARK: - WKScriptMessageHandler -

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        print("Message received: \(message.name) with body: \(message.body)")
        if message.name == "NativeJavascriptInterface", let dict = message.body as? NSDictionary {
            mergeAndUpdateNames(dict)
        }
    }
    
    
}
