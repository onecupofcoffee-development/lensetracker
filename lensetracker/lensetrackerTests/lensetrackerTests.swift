//
//  lensetrackerTests.swift
//  lensetrackerTests
//
//  Created by Andrey Lesnykh on 08.05.2022.
//

import XCTest
@testable import lensetracker

class lensetrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateNew() throws {
        // test for new lenses creation
        let myLenses = LenseTrackerModel()

       XCTAssertEqual(myLenses.opticalForce, -2, "Default value for optical force should be -2")
       XCTAssertEqual(myLenses.validPeriod, 14, "Default valid period should be 14")
       XCTAssertEqual(myLenses.areMyLensesOn, false, "Default on state should be false")
       XCTAssertEqual(myLenses.lastDateLensesOff, nil, "Default last date off shold be nil")
       XCTAssertEqual(myLenses.lastDateLensesOn, nil, "Default last date on should be nil")
       XCTAssertEqual(myLenses.lenseVendor, "<Производитель>", "Default vendor should be <Производитель>")
       XCTAssertEqual(myLenses.lenseModel, "<Обычные линзы>",  "Default vendor should be <Обычные линзы>")
       XCTAssertEqual(myLenses.dailyReminders, true, "Default daily reminder should be default true")
       XCTAssertEqual(myLenses.exceedUsageReminder, false, "Default exceed usage reminder should be false")
       XCTAssertEqual(myLenses.dailyReminderTime, 79200, "Default reminder time is mins should be 79200")
       XCTAssertEqual(myLenses.expirationReminderTime, 64800, "Default expiration time reminder should be 64800")
       XCTAssertEqual(myLenses.daysUsed, 0, "Default days used should be 0")
       XCTAssertEqual(myLenses.daysLeft, 14, "Default days used should be 14")
       XCTAssertEqual(myLenses.isExpired, false, "Default is expired should be false")
    }
    
    func testPutOnOff() throws {
        var myLenses = LenseTrackerModel()
        myLenses.putOn()
        XCTAssertEqual(myLenses.areMyLensesOn, true, "Put on test failed: lenses are still off")
        XCTAssertNotNil(myLenses.lastDateLensesOn, "Default last date on was not set properly!")
        myLenses.takeOff()
        XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
        XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
    }
}

