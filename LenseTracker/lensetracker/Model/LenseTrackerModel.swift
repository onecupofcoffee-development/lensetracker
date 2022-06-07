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
        private var usageHistory: [String] = [] //default is empty - never used
        private var currentSessionUsageHistory: [String] = [] //default is empty - never used
        
    //options
        private(set) var dailyReminders: Bool = true
        private(set) var exceedUsageReminder: Bool = false
        private(set) var dailyReminderTime: Int = 22*60*60 //minutes from 00:00 to 22-00 by default
        private(set) var expirationReminderTime: Int = 18*60*60 //minutes from 00:00 18-00 by default
    
    //utilization
        private(set) var daysUsed: Int = 0 //default - not used yet
        private(set) var daysUsedCurrentSession: Int = 0 //default - not used
        
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
    
    mutating func putOn(onDate: Date) {
        if !areMyLensesOn {
            self.areMyLensesOn = true
            self.lastDateLensesOn = onDate
        }
    }
    
    mutating func takeOff(offDate: Date) {
        if areMyLensesOn {
            self.areMyLensesOn = false
            self.daysUsedCurrentSession = 0
            let nofdays = self.updateUsageHistory(lastDateLensesOn!, offDate)
            
            if nofdays > 1 {
                self.daysUsed += Int(nofdays*Int(self.usageCoeff.rounded(.up)))
            }
            else {
                self.daysUsed += nofdays
            }
            
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
    
    private mutating func updateUsageHistory(_ startDate: Date, _ endDate: Date) -> Int {
        
        let datesRange = self.getDatesRangeArray(startDate, endDate)
        let resultArray = Array(Set(datesRange).subtracting(Set(self.usageHistory)))
        
        for item in resultArray {
            usageHistory.append(item)
        }
        
        return resultArray.count //number of days added
    }
    
    mutating func updateCurrentSession(currentDate: Date) {
        
        if let onDate = self.lastDateLensesOn {
            let datesRange = self.getDatesRangeArray(onDate, currentDate)
            let resultArray = Array(Set(datesRange).subtracting(Set(self.currentSessionUsageHistory)))
            
            for item in resultArray {
                currentSessionUsageHistory.append(item)
            }
            
            self.daysUsedCurrentSession = Int(currentSessionUsageHistory.count*Int(self.usageCoeff.rounded(.up)))
        }
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
    
}

extension Date {
    func daysTo(_ date: Date) -> Int? {
        let calendar = Calendar.current

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day  // This will return the number of day(s) between dates
    }
}

extension Date {
    
            var startOfDay : Date {
                let calendar = Calendar.current
                let unitFlags = Set<Calendar.Component>([.year, .month, .day])
                let components = calendar.dateComponents(unitFlags, from: self)
                return calendar.date(from: components)!
            }
    
            var endOfDay : Date {
                var components = DateComponents()
                components.day = 1
                let date = Calendar.current.date(byAdding: components, to: self.startOfDay)
                return (date?.addingTimeInterval(-1))!
            }
}

