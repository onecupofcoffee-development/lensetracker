//
//  lensetrackerTests.swift
//  lensetrackerTests
//
//  Created by Andrey Lesnykh on 08.05.2022.
//

//test set covering data model logic

import XCTest
@testable import lensetracker

class lensetrackerTests: XCTestCase {

    override func setUpWithError() throws {
        UserDefaults.resetStandardUserDefaults()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //MARK: Model
    
    func testCreateNew() throws {
        // test for new lenses creation
        let myLenses = LenseTrackerModel()

       XCTAssertEqual(myLenses.opticalForce, -2, "Default value for optical force should be -2")
       XCTAssertEqual(myLenses.validPeriod, 14, "Default valid period should be 14")
       XCTAssertEqual(myLenses.areMyLensesOn, false, "Default on state should be false")
       XCTAssertEqual(myLenses.lastDateLensesOff, nil, "Default last date off shold be nil")
       XCTAssertEqual(myLenses.lastDateLensesOn, nil, "Default last date on should be nil")
       XCTAssertNotNil(myLenses.lenseVendor, "Vendor should not be nil")
       XCTAssertNotNil(myLenses.lenseModel, "Model should not be nil")
       XCTAssertEqual(myLenses.dailyReminders, true, "Default daily reminder should be default true")
       XCTAssertEqual(myLenses.exceedUsageReminder, false, "Default exceed usage reminder should be false")
       XCTAssertEqual(myLenses.dailyReminderTime, 79200, "Default reminder time in secs should be 79200")
       XCTAssertEqual(myLenses.expirationReminderTime, 64800, "Default expiration time reminder in secs should be 64800")
       XCTAssertEqual(myLenses.daysUsed, 0, "Default days used should be 0")
       XCTAssertEqual(myLenses.daysLeft, 14, "Default days used should be 14")
       XCTAssertEqual(myLenses.isExpired, false, "Default is expired should be false")
    }
    
    func testPutOn() throws {
        var myLenses = LenseTrackerModel()
        myLenses.putOn(onDate: Date())
        XCTAssertEqual(myLenses.areMyLensesOn, true, "Put on test failed: lenses are still off")
        XCTAssertNotNil(myLenses.lastDateLensesOn, "Default last date on was not set properly!")
    }
    
    func testTakeOff() throws {
        var myLenses = LenseTrackerModel()
        let today = Date()
        
        myLenses.putOn(onDate: today)
            
            XCTAssertEqual(myLenses.areMyLensesOn, true, "Put on test failed: lenses are still off")
            XCTAssertNotNil(myLenses.lastDateLensesOn, "Default last date on was not set properly!")
        
        myLenses.takeOff(offDate: addMins(mins: 30, to: today))
        
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertTrue(myLenses.daysUsed>0, "Days used is not changing with off event")
            XCTAssertTrue(myLenses.daysLeft<14, "Days left is not changing with off event")
    }
    
    func testUsageCalculation() throws {
        var myLenses = LenseTrackerModel()
        let today = Date()
        
        //1 day on off
            myLenses.putOn(onDate: today)
            myLenses.takeOff(offDate: addMins(mins: 30, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.daysUsed, 1, "Days used should be 1 for day 1 = day 1")
            XCTAssertEqual(myLenses.daysLeft, myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")
        
        //case repeat 1 day
            myLenses.putOn(onDate: addMins(mins: 45, to: today))
            myLenses.takeOff(offDate: addMins(mins: 60, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.daysUsed, 1, "Days used should be 1 still for day 1 = day 1, repeated")
            XCTAssertEqual(myLenses.daysLeft, myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")
        
        
        //2 day on, 3 days off
            myLenses.putOn(onDate: addDays(days: 1, to: today))
            myLenses.takeOff(offDate: addDays(days: 2, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.lastDateLensesOff, addDays(days: 2, to: today), "Last date is not equal to off date!")
            XCTAssertEqual(myLenses.daysUsed, 3, "Days used should be 3 for total days 1-3")
            XCTAssertEqual(myLenses.daysLeft,  myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")
        
        //3 day on off
            myLenses.putOn(onDate: addMins(mins: 30, to: addDays(days: 2, to: today)))
            myLenses.takeOff(offDate: addMins(mins: 45, to: addDays(days: 2, to: today)))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.lastDateLensesOff, addMins(mins: 45, to: addDays(days: 2, to: today)), "Last date is not equal to off date!")
            XCTAssertEqual(myLenses.daysUsed, 3, "On day 3, used days should not change on-off")
            XCTAssertEqual(myLenses.daysLeft,  myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")

        //3 day on (again), 5 day off
            myLenses.putOn(onDate: addMins(mins: 60, to: addDays(days: 2, to: today)))
            myLenses.takeOff(offDate: addDays(days: 5, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.lastDateLensesOff, addDays(days: 5, to: today), "Last date is not equal to off date!")
            XCTAssertEqual(myLenses.daysUsed, 5, "On day 5, used days should be 5")
            XCTAssertEqual(myLenses.daysLeft,  myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")
        
        //7 day on, 10 off
            myLenses.putOn(onDate: addDays(days: 7, to: today))
            myLenses.takeOff(offDate: addDays(days: 10, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.lastDateLensesOff, addDays(days: 10, to: today), "Last date is not equal to off date!")
            XCTAssertEqual(myLenses.daysUsed, 9, "On day 10, used days should be 9 - 6 day is off lenses")
            XCTAssertEqual(myLenses.daysLeft,  myLenses.validPeriod-myLenses.daysUsed, "Days left should be max days - used days!")

        // 11 day on, 14 off
        
            myLenses.putOn(onDate: addDays(days: 11, to: today))
            myLenses.takeOff(offDate: addDays(days: 14, to: today))
            
            XCTAssertEqual(myLenses.areMyLensesOn, false, "Take off test failed: lenses are still on")
            XCTAssertNotNil(myLenses.lastDateLensesOff, "Default last date off was not set properly!")
            XCTAssertEqual(myLenses.lastDateLensesOff, addDays(days: 14, to: today), "Last date is not equal to off date!")
            XCTAssertEqual(myLenses.daysUsed, 13, "On day 14, used days should be 13 - 6 day is off lenses")
            XCTAssertEqual(myLenses.daysLeft,  myLenses.validPeriod-myLenses.daysUsed, "Days left should be 0 on day 14")
    }
    
    func addDays(days: Int, to date: Date ) -> Date {
        return Date(timeInterval: Double(days)*86400, since: date)
    }
    
    func addMins(mins: Int, to date: Date ) -> Date {
        return Date(timeInterval: Double(mins)*60, since: date)
    }
}

