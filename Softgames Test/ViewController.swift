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


// MARK: - Swift to JS Actions -

extension ViewController {
    
    func mergeAndUpdateNames(_ dict: NSDictionary) {
        let fname = dict["fname"] as? String ?? ""
        let lname = dict["lname"] as? String ?? ""
        let fullName = fname + " " + lname
        webView.evaluateJavaScript("setFullName(\"\(fullName)\");", completionHandler: nil)
    }
    
    func calculateAndUpdateAge(_ dob: Date) {
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
                // Something went wrong
                print("Error : \(error.localizedDescription)")
            } else {
                print("Success")
            }
        })
    }
    
}


// MARK: - WKScriptMessageHandler -

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //        print("Message received: \(message.name) with body: \(message.body)")
        if message.name == "NamesJSInterface", let dict = message.body as? NSDictionary {
            mergeAndUpdateNames(dict)
        } else if message.name == "DobJSInterface", let dobStr = message.body as? String {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let date = dateFormatter.date(from: dobStr) {
                    self.calculateAndUpdateAge(date)
                }
            }
        } else if message.name == "LocalNotificationJSInterface" {
            triggerLocalNotification()
        }
    }
    
}
