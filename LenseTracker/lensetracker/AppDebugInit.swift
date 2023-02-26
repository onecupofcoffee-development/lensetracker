//
//  AppDebugInit.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 26/2/23.
//
//MARK: Debug
/*
 
 init() {
 UserDefaults.standard.removeObject(forKey: "LenseData")
 
 var myLenses = LenseTrackerModel()
 myLenses.createNew(vendor: "myTestVendor", model: "myTestModel", force: -10, valid: 14, continuousValid: 7, curvRadius: 8.3)
 let today = Date()
 
 //myLenses.putOn(onDate: addDays(days: -5, to: today))
 //myLenses.updateCurrentSession(currentDate: addDays(days: -2, to: today))
 //myLenses.takeOff(offDate: addDays(days: -2, to: today))
 myLenses.putOn(onDate: addDays(days: -1, to: today))
 
 //myLenses.updateCurrentSession(currentDate: addDays(days: 5, to: today))
 //myLenses.takeOff(offDate: addDays(days: 6, to: today))
 
 let encoder = JSONEncoder()
 if let encodedData = try? encoder.encode(myLenses) {
 UserDefaults.standard.set(encodedData, forKey: "LenseData")
 }
 }
 
 func addDays(days: Int, to date: Date ) -> Date {
 return Date(timeInterval: Double(days)*86400, since: date)
 }
 
 func addMins(mins: Int, to date: Date ) -> Date {
 return Date(timeInterval: Double(mins)*60, since: date)
 }
 
 //MARK: end of Debug
 */
