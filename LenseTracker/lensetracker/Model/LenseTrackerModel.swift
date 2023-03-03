//
//  LenseTrackerModel.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 15.09.2021.
//

import Foundation
import SwiftUI

struct LenseTrackerModel: Codable {

    //Lense properties
        private(set) var opticalForce: Double = -2 //default
        private(set) var validPeriod: Int = 14 //default
        private(set) var maxdaysContinuousUse: Int = 14 //default
        private(set) var areMyLensesOn: Bool = false //default - not on
        private(set) var lastDateLensesOff: Date? //optional, nll if we never used it
        private(set) var lastDateLensesOn: Date? //optional, nll if we never used it
        private (set) var lenseVendor: String = NSLocalizedString("<Производитель>", comment: "Lense supplier (data model)")
        private (set) var lenseModel: String = NSLocalizedString("<Обычные линзы>", comment: "Lense model (data model)")
        private (set) var curvRadius: Double = 8.3
        
    //usage history
        private var usageHistory: [String] = [] //default is empty - never used; accumulated usage dates since first on till last off
        private var currentSessionUsageHistory: [String] = [] //default is empty - never used; usageHistory + dates since last on
        
    //options
        private(set) var dailyReminders: Bool = true
        private(set) var exceedUsageReminder: Bool = false
        private(set) var dailyReminderTime: Int = 22*60*60 //minutes from 00:00 to 22-00 by default
        private(set) var expirationReminderTime: Int = 18*60*60 //minutes from 00:00 18-00 by default
    
    //utilization
        private(set) var daysUsed: Int = 0 //default - not used yet; considering coefficient
        private(set) var daysUsedCurrentSession: Int = 0 //default - not used; considering coefficient
        
        var continuousUsageIsOn: Bool {
            if validPeriod/maxdaysContinuousUse > 1 {
                return true
            }
            else {
                return false
            }
        }
    
        var daysLeft: Int {
                return validPeriod - daysUsed
        }
    
        var usageCoeff: Double {
                return Double(validPeriod/maxdaysContinuousUse)
        }
    
        var isExpired: Bool {
            if validPeriod <= daysUsed {return true}
            else {return false}
        }
    
    mutating func setOptions(dailyReminder: Bool, expirationReminder: Bool, dReminder: Int, eReminder: Int) {
        self.dailyReminders = dailyReminder
        self.dailyReminderTime = dReminder
        self.exceedUsageReminder = expirationReminder
        self.expirationReminderTime = eReminder
    }
    
    mutating func createNew(vendor: String, model: String, force: Double, valid: Int, continuousValid: Int, curvRadius: Double) {
        //re-init lenses
        self.lenseVendor = vendor
        self.lenseModel = model
        self.opticalForce = force
        self.validPeriod = valid
        self.areMyLensesOn = false
        self.lastDateLensesOff = nil
        self.lastDateLensesOn = nil
        self.daysUsed = 0
        self.maxdaysContinuousUse = continuousValid
        self.usageHistory = []
        self.currentSessionUsageHistory = []
        self.curvRadius = curvRadius
    }
    
    mutating func putOn(onDate: Date) {
        if !areMyLensesOn {
            self.areMyLensesOn = true
            self.lastDateLensesOn = onDate
        }
    }
    
    //taking lenses off, updating usage history, days used and lenses off date
    mutating func takeOff(offDate: Date) {
        if areMyLensesOn {
            self.areMyLensesOn = false
            self.daysUsedCurrentSession = 0
            self.currentSessionUsageHistory = []
            
        //MARK: refactor, removing calculation logic
            
            self.updateUsageHistory(lastDateLensesOn!, offDate)
            self.daysUsed = calculateUsageDays(usageHistory)
            
            /*
            let nofdays = self.updateUsageHistory(lastDateLensesOn!, offDate)
            
            if nofdays > 1 {
                self.daysUsed += Int(nofdays*Int(self.usageCoeff.rounded(.up)))
            }
            else {
                self.daysUsed += nofdays
            }
             */
            
            self.lastDateLensesOff = offDate
        }
    }
    
    private func getDatesRangeArray(_ startDate: Date, _ endDate: Date) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var cdate = startDate
        var result: [String] = []
        
        while cdate.compare(endDate) != .orderedDescending {
            // Advance by one day:
            cdate = calendar.date(byAdding: .day, value: 1, to: cdate)!
            result.append(dateFormatter.string(from: cdate))
        }
        return result
    }
    
    //calculation logic for daysUsed/daysUsedCurrentSession
    
    private func calculateUsageDays(_ arr: [String]) -> Int {
        
        var nOfDays: Int = 0
        var a = arr.sorted()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var NSDateArray = [Date]()
        var consBuffer = [String]()
        var consCombinedBuffer = [String]()
        var resultArrayConsequent = [[String]]()
        //var resultArrayNonConsequent = [String]()
        
            for item in a {
                NSDateArray.append(dateFormatter.date(from: item)!)
            }
            
            let referenceDate = calendar.startOfDay(for: NSDateArray.first!)

            let dayDiffs = NSDateArray.map { (date) -> Int in
                calendar.dateComponents([.day], from: referenceDate, to: date).day!
            }

            for (prev, current) in zip(dayDiffs, dayDiffs.dropFirst()) {
                if current == prev + 1 {
                    // Numbers are consecutive, increase consequtive counter
                    let i = dayDiffs.firstIndex(of: prev)!
                    consBuffer.append(a[i])
                    consBuffer.append(a[i+1])
                    if dayDiffs.firstIndex(of: current)! == dayDiffs.count-1 {
                         let uniqueOrdered = Array(NSOrderedSet(array: consBuffer)) as! [String]
                        resultArrayConsequent.append(uniqueOrdered)
                        consBuffer = []
                    }
                }
                else {
                    let uniqueOrdered = Array(NSOrderedSet(array: consBuffer)) as! [String]
                    resultArrayConsequent.append(uniqueOrdered)
                    consBuffer = []
                }
            }

        for item in resultArrayConsequent {
            for subitem in item {
                consCombinedBuffer.append(subitem)
            }
            nOfDays += Int(item.count*Int(self.usageCoeff.rounded(.up)))
        }

        let nonConsequent = Array(Set(a).subtracting(consCombinedBuffer))

        nOfDays += nonConsequent.count
            
    return nOfDays
    }
    
    //updating usage history array with current data
    private mutating func updateUsageHistory(_ startDate: Date, _ endDate: Date) {// -> Int {
        
        let datesRange = self.getDatesRangeArray(startDate, endDate)
        let resultArray = Array(Set(datesRange).subtracting(Set(self.usageHistory)))
        
        for item in resultArray {
            usageHistory.append(item)
        }
        
        //MARK: refactor, removing calculation logic
        //return resultArray.count //number of days added
    }
    
    //updating current session usage history with current data
    mutating func updateCurrentSession(currentDate: Date) {
        
        if let onDate = self.lastDateLensesOn {
            if self.areMyLensesOn {
                let datesRange = self.getDatesRangeArray(onDate, currentDate)
                let currentSessionArray = Array(Set(datesRange).subtracting(Set(self.currentSessionUsageHistory)))
                let resultArray = Array(Set(self.usageHistory).union(Set(currentSessionArray)))
                
                for item in resultArray {
                    currentSessionUsageHistory.append(item)
                }
                
                //MARK: refactor, removing calculation logic
                
                self.daysUsedCurrentSession = calculateUsageDays(currentSessionUsageHistory)
                
                /*
                let nOfDays = Array(Set(currentSessionUsageHistory).subtracting(Set(self.usageHistory))).count
                
                if nOfDays > 1
                {
                    self.daysUsedCurrentSession = Int(currentSessionUsageHistory.count*Int(self.usageCoeff.rounded(.up))) //considering usage coeff, > 1 days on
                }
                else {
                    self.daysUsedCurrentSession = currentSessionUsageHistory.count
                }
                 */
            }
        }
    }
}



