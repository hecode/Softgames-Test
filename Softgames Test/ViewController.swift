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
                                                        name: "NamesJSInterface")
        webView.configuration.userContentController.add(self,
                                                        name: "DobJSInterface")
        webView.configuration.userContentController.add(self,
                                                        name: "LocalNotificationJSInterface")
        
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


// MARK: - JS Triggered Actions -

extension ViewController {
    
    func mergeAndUpdateNames(_ dict: NSDictionary) {
        let fname = dict["fname"] as? String ?? ""
        let lname = dict["lname"] as? String ?? ""
        let fullName = fname + " " + lname
        webView.evaluateJavaScript("setFullName(\"\(fullName)\");", completionHandler: nil)
    }
    
    func calculateAndUpdateAge(_ dob: Date?) {
        guard let dob = dob else {
            webView.evaluateJavaScript("setAge(\"error\");", completionHandler: nil)
            return
        }
        
        if let age = yearsBetweenDates(startDate: dob, endDate: Date()) {
            if age >= 0 {
                webView.evaluateJavaScript("setAge(\"\(age)\");", completionHandler: nil)
            } else {
                webView.evaluateJavaScript("setAge(\"TimeTraveler?\");", completionHandler: nil)
            }
        }
    }
    
    func triggerLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Solitaire smash"
        content.body = "Play again to smash your top score"
        content.sound = UNNotificationSound.default
        
        let identifier = "ibrahim.b.beltagy.Softgames-Test.notificationIdentifier"
        
        var triggerDate = DateComponents()
        triggerDate.second = 7
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }
        })
    }
    
}


// MARK: - WKScriptMessageHandler -

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "NamesJSInterface", let dict = message.body as? NSDictionary {
            mergeAndUpdateNames(dict)
        } else if message.name == "DobJSInterface", let dobStr = message.body as? String {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.calculateAndUpdateAge(getDateFromString(dateStr: dobStr))
            }
        } else if message.name == "LocalNotificationJSInterface" {
            triggerLocalNotification()
        }
    }
    
}
