//
//  lensetrackerUITests.swift
//  lensetrackerUITests
//
//  Created by Andrey Lesnykh on 11.05.2022.
//


import XCTest

class lensetrackerUITests: XCTestCase {
    
    //MARK: override standard functions

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.resetStandardUserDefaults()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLensesOnOffFlow() throws {
        // UI tests must launch the application that they test.
        //MARK: Running the app
        let app = XCUIApplication()
        app.launch()
        
        //MARK: set up variables for lense on and off view state, progress bar
        
        let lenseImgOn = app.images["LenseImageOn"]
        let lenseImgOff = app.images["LenseImageOff"]
        let progressIndicator = app.progressIndicators.firstMatch //we know for sure we have only 1
        
        XCTAssertTrue(progressIndicator.exists, "Progress indicator does not exist!")
        
        let currentValue = progressIndicator.value as? String
        
        //MARK: test on and off operation
        if lenseImgOn.exists {
            //case lenses are on
            app.images["lense"].tap()
            let newValue = progressIndicator.value as? String
            XCTAssertTrue(lenseImgOff.exists, "Lenses are not off!")
            XCTAssertFalse(lenseImgOn.exists, "Lenses are on, should be off!")
            XCTAssertFalse(currentValue! == newValue!, "Progress did not change on lenses off action!")
        } else
        {
            //case lenses are off
            app.images["lense"].tap()
            XCTAssertTrue(lenseImgOn.exists, "Lenses are not on!")
            XCTAssertFalse(lenseImgOff.exists, "Lenses are off, should be on!")
            app.images["lense"].tap()
            let newValue = progressIndicator.value as? String
            XCTAssertTrue(currentValue! == newValue!, "Progress did not change on lenses off action!")
        }
    }
    
    func testChangeLensesFlow() throws {
        //MARK: running the app
        let app = XCUIApplication()
        app.launch()
        
        //MARK: moving to change lenses form
        
        let changeLensesButton = app.buttons["ChangeLensesButton"]
        XCTAssertTrue(changeLensesButton.exists, "No change lenses button found")
        changeLensesButton.tap()
        
        //MARK: creating variables, adjusting and saving data for new lenses
        
        //OpticalForceInput, ValidDaysInput
        let vendorName = app.textFields["VendorInput"]
        let modelName = app.textFields["ModelInput"]
        let opticalForce = app.buttons["OptForce"]
        let daysValid = app.buttons["DaysValid"]
        let daysValidContinuous = app.buttons["DaysValidContinuous"]
        let daysValidToggle = app.switches["ContinuousUseToggle"]
        
        XCTAssertTrue(vendorName.exists, "Vendor name input does not exist!")
        XCTAssertTrue(modelName.exists, "Model name input does not exist!")
        XCTAssertTrue(opticalForce.exists, "Optical force picker does not exist!")
        XCTAssertTrue(daysValidToggle.exists, "Valid days continuous toggle does not exist!")
        
        XCTAssertTrue(daysValid.exists, "Valid days picker does not exist!")
        
        if !daysValidContinuous.exists {
            daysValidToggle.tap()
            XCTAssertTrue(daysValidContinuous.exists, "Valid days continuous does not appear with toggle on!")
        }
        
        vendorName.doubleTap()
        vendorName.typeText("TestVendor")
        modelName.doubleTap()
        modelName.typeText("TestModel")
        
        
        //MARK: going back to main screen and testing new lenses
        
        let saveLensesButton = app.buttons["SaveAndPutOn"]
        XCTAssertTrue(saveLensesButton.exists, "No change lenses button found")
        app.buttons["SaveAndPutOn"].tap()
        
        let progressIndicator = app.progressIndicators.firstMatch //we know for sure we have only 1
        let currentValue = progressIndicator.value as? String
        XCTAssertTrue(currentValue == "100 %", "Utilization indicator is not 100% - new lenses test failed")
    }
    
    func testLensesConditionFlow() throws {
        //MARK: running the app
        let app = XCUIApplication()
        app.launch()
        
        //MARK: moving to lenses condition form
        
        let detailsButton = app.buttons["DetailsButton"]
        XCTAssertTrue(detailsButton.exists, "No lense details button found")
        detailsButton.tap()
        
        //MARK: checking if vendor, model, optforce, daysused and daysleft exist
        XCTAssertTrue(app.staticTexts["VendorValue"].exists, "No lenses condition vendor value exist")
        XCTAssertTrue(app.staticTexts["ModelValue"].exists, "No lenses condition model value exist")
        XCTAssertTrue(app.staticTexts["OpticalForceValue"].exists, "No lenses condition opt force value exist")
        XCTAssertTrue(app.staticTexts["DaysUsedValue"].exists, "No lenses condition days used value exist")
        XCTAssertTrue(app.staticTexts["DaysLeftValue"].exists, "No lenses condition days used value exist")
        
        XCTAssertTrue(app.staticTexts["VendorLabel"].exists, "No lenses condition vendor label exist")
        XCTAssertTrue(app.staticTexts["ModelLabel"].exists, "No lenses condition model label exist")
        XCTAssertTrue(app.staticTexts["OpticalForceLabel"].exists, "No lenses condition opt force label exist")
        XCTAssertTrue(app.staticTexts["DaysUsedLabel"].exists, "No lenses condition days used label exist")
        XCTAssertTrue(app.staticTexts["DaysLeftLabel"].exists, "No lenses condition days used label exist")
    }
    
    func testAppSettingsFlow() throws {
        //MARK: running the app
        let app = XCUIApplication()
        app.launch()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        //MARK: moving to app settings form
    
        let settingsButton = app.buttons["SettingsButton"]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        
        //MARK: setting reminders time up
        let saveAndClose = app.buttons["SaveAndCloseAppSettings"]
        XCTAssertTrue(saveAndClose.exists)
        
        let dailyReminderToggle = app.switches["DailyReminderToggle"]
        let changeReminderToggle = app.switches["ChangeReminderToggle"]
        
        print(app.debugDescription)
        
        XCTAssertTrue(dailyReminderToggle.exists, "NO daily reminder toggle found!")
        XCTAssertTrue(changeReminderToggle.exists, "NO change reminder toggle found!")
        
        if dailyReminderToggle.isEnabled {
            dailyReminderToggle.tap()
        }
        if changeReminderToggle.isEnabled {
            changeReminderToggle.tap()
        }
        
        saveAndClose.tap()
        
        //MARK: putting lenses on and testing if reminders are NOT set up
        if app.images["LenseImageOn"].exists {
            app.images["lense"].tap()
        } else
        {
            app.images["lense"].tap()
            app.images["lense"].tap()
        }
        
        center.getPendingNotificationRequests(completionHandler: { request in
            XCTAssertTrue(request.isEmpty, "Extra notification set up!")
        })

        //MARK: putting lenses on and testing if reminders are set up
        
        settingsButton.tap()
        
        if !dailyReminderToggle.isEnabled {
            dailyReminderToggle.tap()
        }
        if !changeReminderToggle.isEnabled {
            changeReminderToggle.tap()
        }
        
        saveAndClose.tap()
        
        if app.images["LenseImageOn"].exists {
            app.images["lense"].tap()
        } else
        {
            app.images["lense"].tap()
            app.images["lense"].tap()
        }
        
        center.getPendingNotificationRequests(completionHandler: { request in
            XCTAssertTrue(request.isEmpty, "No notification set up!")
        })
        
    }

    /*
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }*/
}
