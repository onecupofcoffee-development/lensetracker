//
//  LenseTrackerModel.swift
//  lensetracker
//
//  Created by Мак on 15.09.2021.
//

import Foundation

struct LenseTrackerModel: Codable {

    //Lense properties
        private(set) var opticalForce: Double = -2 //default
        private(set) var validPeriod: Int = 14 //default
        private(set) var areMyLensesOn: Bool = false //default - not on
        private(set) var firstDateLensesOn: Date? //optional, nll if we never used it
        private(set) var lastDateLensesOn: Date? //optional, nll if we never used it
        private var alreadyUsedToday: Bool = false
        private (set) var lenseVendor: String = ""
        private (set) var lenseModel: String = ""
        
    //options
        private(set) var dailyReminders: Bool = true
        private(set) var exceedUsageReminder: Bool = false
        private(set) var dailyReminderTime: Int = 22*60*60 //minutes from 00:00 to 22-00 by default
        private(set) var expirationReminderTime: Int = 18*60*60 //minutes from 00:00 18-00 by default
    
        private(set) var daysUsed: Int = 0 //default - not used
        
        var daysLeft: Int {
                return validPeriod - daysUsed
        }
    
        var isExpired: Bool {
            if validPeriod < daysUsed {return true}
            else {return false}
        }
    

    mutating func setOptions(dailyReminder: Bool, expirationReminder: Bool, dReminder: Int, eReminder: Int) {
        self.dailyReminders = dailyReminder
        self.exceedUsageReminder = expirationReminder
        
    }
    
    mutating func putOn() {
        if !areMyLensesOn {
            self.areMyLensesOn = true
            if let d = lastDateLensesOn?.daysTo(Date()) {
                if d == 0 {
                    alreadyUsedToday = true
                }
            }
        self.lastDateLensesOn = Date()
        }
    }
    
    mutating func takeOff() {
        if areMyLensesOn {
            self.areMyLensesOn = false
            //if we ever used lenses, e.g. last use date is not nil
            if let u = lastDateLensesOn {
                //full days passed btw now and the date/time I put it on
                if let d = u.daysTo(Date())
                {
                    //if it is > 1 day passed - adding # of days passed to daysUsed
                    if d > 0 {
                        self.daysUsed = daysUsed + d
                    }
                    //else if it is less then 1 day - adding 1 full day
                    else {
                        if !alreadyUsedToday
                        {
                            self.daysUsed = daysUsed + 1
                        }
                    }
                }
            }
        }
    }
    
    mutating func createNew(vendor: String, model: String, force: Double, valid: Int) {
        //re-init lenses
        self.lenseVendor = vendor
        self.lenseModel = model
        self.opticalForce = force
        self.validPeriod = valid
        self.areMyLensesOn = false
        self.firstDateLensesOn = Date()
        self.lastDateLensesOn = Date()
        self.daysUsed = 1
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

