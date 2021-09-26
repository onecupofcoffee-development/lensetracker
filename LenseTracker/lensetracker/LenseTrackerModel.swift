//
//  LenseTrackerModel.swift
//  lensetracker
//
//  Created by Мак on 15.09.2021.
//

import Foundation

struct LenseTrackerModel {

        private(set) var opticalForce: Double = -2 //default
        private(set) var validPeriod: Int = 14 //default
        private(set) var areMyLensesOn: Bool = false //default - not on
        private(set) var firstDateLensesOn: Date? //optional, nll if we never used it
        private(set) var lastDateLensesOn: Date? //optional, nll if we never used it
        
        private(set) var daysUsed: Int = 0 //default - not used
        
        var daysLeft: Int {
                return validPeriod - daysUsed
        }
    
        var isExpired: Bool {
            if validPeriod < daysUsed {return true}
            else {return false}
        }
    
    private var alreadyUsedToday: Bool = false
    
    mutating func putOn() {
        if !areMyLensesOn {
            self.areMyLensesOn = true
            if let d = lastDateLensesOn?.daysTo(Date()) {
                if d == 0 {
                    alreadyUsedToday = true
                }
            }
                self.lastDateLensesOn = Date()
                print("Lenses on is \(self.areMyLensesOn), last on date is \(lastDateLensesOn), valid \(validPeriod), days used \(daysUsed), days left \(daysLeft)")
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
                        print("Lenses on is \(self.areMyLensesOn), last on date is \(lastDateLensesOn), valid \(validPeriod), days used \(daysUsed), days left \(daysLeft)")
                    }
                    //else if it is less then 1 day - adding 1 full day, if not during 1 day
                    else {
                        if !alreadyUsedToday
                        {
                            self.daysUsed = daysUsed + 1
                            print("Lenses on is \(self.areMyLensesOn), last on date is \(lastDateLensesOn), valid \(validPeriod), days used \(daysUsed), days left \(daysLeft)")
                        }
                    }
                }
            }
        }
    }
    
    mutating func createNew(force: Double, valid: Int) {
        //re-init lenses
        self.opticalForce = force
        self.validPeriod = valid
        self.areMyLensesOn = true
        self.firstDateLensesOn = nil
        self.lastDateLensesOn = Date()
        self.daysUsed = 0
        print(self)
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

