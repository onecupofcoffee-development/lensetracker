//
//  viewmodelTests.swift
//  lensetrackerTests
//
//  Created by Andrey Lesnykh on 14.05.2022.
//

// MARK: view model

import XCTest
@testable import lensetracker

class lensetrackerViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetMyLensesState() throws {
        let myViewModel = LenseTrackerViewModel()
        XCTAssertEqual(myViewModel.getMyLensesState(), false, "Default value lenses on should be false")
    }

    func testCreateNew() throws {
        let myViewModel = LenseTrackerViewModel()
        
        myViewModel.createNewLenses("PureVision", "DailyOnes", -5, 7)

        XCTAssertEqual(myViewModel.myModel.opticalForce, -5, "Created new lenses has optical force of -5")
        XCTAssertEqual(myViewModel.myModel.validPeriod, 7, "Created new lenses valid period is 7")
        XCTAssertEqual(myViewModel.myModel.areMyLensesOn, true, "On creation, new lenses are on from ViewModel method")
        XCTAssertEqual(myViewModel.myModel.lastDateLensesOff, nil, "Default last date off shold be nil")
        XCTAssertNotNil(myViewModel.myModel.lastDateLensesOn, "On date should not be nil")
        XCTAssertEqual(myViewModel.myModel.lenseVendor, "PureVision", "Vendor should be PureVision")
        XCTAssertEqual(myViewModel.myModel.lenseModel, "DailyOnes", "Model should be DailyOnes")
        XCTAssertEqual(myViewModel.myModel.dailyReminders, true, "Default daily reminder should be default true")
        XCTAssertEqual(myViewModel.myModel.exceedUsageReminder, false, "Default exceed usage reminder should be false")
        XCTAssertEqual(myViewModel.myModel.dailyReminderTime, 79200, "Default reminder time in secs should be 79200")
        XCTAssertEqual(myViewModel.myModel.expirationReminderTime, 64800, "Default expiration time reminder in secs should be 64800")
        XCTAssertEqual(myViewModel.myModel.daysUsed, 0, "Default days used should be 0")
        XCTAssertEqual(myViewModel.myModel.daysLeft, 7, "Default days used should be 7")
        XCTAssertEqual(myViewModel.myModel.isExpired, false, "Default is expired should be false")
    }
    
    func testTakeOff() throws {
        
        let myViewModel = LenseTrackerViewModel()
        myViewModel.PutLensesOn()
        myViewModel.takeLensesOff()
        
        XCTAssertEqual(myViewModel.myModel.areMyLensesOn, false, "Take off test failed: lenses are still on")
        XCTAssertNotNil(myViewModel.myModel.lastDateLensesOff, "Default last date off was not set properly!")
        XCTAssertTrue(myViewModel.myModel.daysUsed>0, "Days used is not changing with off event")
        XCTAssertTrue(myViewModel.myModel.daysLeft<14, "Days left is not changing with off event")
    }
    
    func testPutOn() throws {
        
        let myViewModel = LenseTrackerViewModel()
        myViewModel.PutLensesOn()
        
        XCTAssertEqual(myViewModel.myModel.areMyLensesOn, true, "Put on test failed: lenses are still off")
        XCTAssertNotNil(myViewModel.myModel.lastDateLensesOn, "Default last date on was not set properly!")
    }
    
    func testNotifications() throws {
        let myViewModel = LenseTrackerViewModel()
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        myViewModel.takeLensesOff()
        myViewModel.setOptions(dailyReminder: true, expirationReminder: true, dailyReminderTime: 60000, expirationReminderTime: 65000)
        myViewModel.PutLensesOn()
        var notificationsAmount = 0
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            notificationsAmount = requests.count
            XCTAssertEqual(notificationsAmount, 2, "There are should be 2 reminders set up!")
        })
    }
}

