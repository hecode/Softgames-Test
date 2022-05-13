//
//  Softgames_TestTests.swift
//  Softgames TestTests
//
//  Created by ibrahim beltagy on 13/05/2022.
//

import XCTest
import WebKit
@testable import Softgames_Test

class Softgames_TestTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}


// MARK: - Date Helpers tests -

extension Softgames_TestTests {
    
    func testGetDateFromStringNotDate() throws {
        let date = "test"
        XCTAssertNil(getDateFromString(dateStr: date))
    }
    
    func testGetDateFromStringWrongDateFormat() throws {
        let date = "01-11-2000"
        XCTAssertNil(getDateFromString(dateStr: date))
    }
    
    func testGetDateFromStringCorrect() throws {
        let date = "2000-11-01"
        XCTAssertNotNil(getDateFromString(dateStr: date))
    }
    
    func testYearsBetweenDatesEqual() throws {
        let date1 = getDateFromString(dateStr: "2000-11-01")!
        let date2 = getDateFromString(dateStr: "2000-11-01")!
        
        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), 0)
    }
    
    func testYearsBetweenDates20Years() throws {
        let date1 = getDateFromString(dateStr: "2000-11-01")!
        let date2 = getDateFromString(dateStr: "2020-11-01")!
        
        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), 20)
    }
    
    func testYearsBetweenDates10YearsInTheFuture() throws {
        let date1 = getDateFromString(dateStr: "2030-11-01")!
        let date2 = getDateFromString(dateStr: "2020-11-01")!
        
        XCTAssertEqual(yearsBetweenDates(startDate: date1, endDate: date2), -10)
    }
    
}


// MARK: - VC tests -

extension Softgames_TestTests {
    
    func testFullNameAndAgeEmptyAtStart() throws {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
                
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "")
            } else {
                XCTFail()
            }
        }
        
        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "")
            } else {
                XCTFail()
            }
        }
    }
    
    func testMergeAndUpdateNamesSuccess() throws {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        let names = ["fname": "test", "lname": "tester"]
        vc.mergeAndUpdateNames(names as NSDictionary)
        
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "test tester")
            } else {
                XCTFail()
            }
        }
    }
    
    func testMergeAndUpdateNamesMissingKey() throws {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        let names = ["fname": "test"]
        vc.mergeAndUpdateNames(names as NSDictionary)
        
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "test ")
            } else {
                XCTFail()
            }
        }
    }
    
    func testMergeAndUpdateNamesMissingAndWrongKeys() throws {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        let names = ["flname": "test"]
        vc.mergeAndUpdateNames(names as NSDictionary)
        
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == " ")
            } else {
                XCTFail()
            }
        }
    }
    
    func testCalculateAndUpdateAgeSuccess0() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.calculateAndUpdateAge(Date())
        
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 6.0)
        
        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "0")
            } else {
                XCTFail()
            }
        }
    }
    
    func testCalculateAndUpdateAgeSuccess10() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.calculateAndUpdateAge( getDateFromString(dateStr: "2012-11-01")!)
        
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 6.0)

        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "10")
            } else {
                XCTFail()
            }
        }
    }
    
    func testCalculateAndUpdateAgeTimeTraveler() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.calculateAndUpdateAge( getDateFromString(dateStr: "2032-11-01")!)
     
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 6.0)

        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "TimeTraveler?")
            } else {
                XCTFail()
            }
        }
    }
    
    func testCalculateAndUpdateAgeError() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.calculateAndUpdateAge(getDateFromString(dateStr: "03-12-0124"))
        
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 6.0)
        
        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "error")
            } else {
                XCTFail()
            }
        }
    }
    
    func testCreateNotification() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        UNUserNotificationCenter.current().getPendingNotificationRequests { pendingRequests in
            XCTAssertTrue(pendingRequests.count == 0)
        }
        vc.triggerLocalNotification()
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendingRequests in
            XCTAssertTrue(pendingRequests.count > 0)
        }
    }
    
    func testUserContentControllerNames() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "")
            } else {
                XCTFail()
            }
        }

        vc.userContentController(vc.webView.configuration.userContentController, didReceive: TestMessage(body: ["fname": "test", "lname": "tester"], webView: vc.webView, name: "NamesJSInterface"))
        
        vc.webView.evaluateJavaScript("document.getElementById('fullName').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "test tester")
            } else {
                XCTFail()
            }
        }
    }
    
    func testUserContentControllerAge() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "")
            } else {
                XCTFail()
            }
        }

        vc.userContentController(vc.webView.configuration.userContentController, didReceive: TestMessage(body: "2000-01-01", webView: vc.webView, name: "DobJSInterface"))
        
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 6.0)

        vc.webView.evaluateJavaScript("document.getElementById('age').innerText;") {(result, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            
            if let resultStr = result as? String {
                XCTAssert(resultStr == "22")
            } else {
                XCTFail()
            }
        }
    }
    
    func testUserContentControllerLocalNotification() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.loadView()
        vc.setup()
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendingRequests in
            XCTAssertTrue(pendingRequests.count == 0)
        }
        
        vc.userContentController(vc.webView.configuration.userContentController, didReceive: TestMessage(body: "", webView: vc.webView, name: "LocalNotificationJSInterface"))
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { pendingRequests in
            XCTAssertTrue(pendingRequests.count > 0)
        }
    }
    
}
