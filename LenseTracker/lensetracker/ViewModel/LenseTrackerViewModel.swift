//
//  LenseTrackerViewModel.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 15.09.2021.
//

import SwiftUI
import CoreData
import UserNotifications

class LenseTrackerViewModel : ObservableObject {
    
    @Published private(set) var myModel: LenseTrackerModel {
        didSet {
            debugPrint("Model has changed: \(myModel)")
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(myModel) {
                    UserDefaults.standard.set(encodedData, forKey: "LenseData")
                }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "LenseData") as? Data {
            if let savedStruct = try? decoder.decode(LenseTrackerModel.self, from: savedData) {
                self.myModel = savedStruct
                return
            }
        }
        self.myModel = LenseTrackerModel()
    }
    
    private func throwNotification(reminderTime: Int, title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        var interval: Int
        //calculating reminder time from now to pre-set value

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        
        let delta = (hour*60+minutes)*60
        
        if reminderTime < delta
        {
            interval = reminderTime + (24*60*60 - delta)
        }
        else {
            interval = reminderTime - delta
        }
        
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                NSLog("Reminder was not set due to error: \(String(describing: error))")
            }
         }
    }
    
    private func setReminder(time: Int, type: Int) {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings
        { settings in
             if settings.authorizationStatus == .notDetermined {
                        NSLog("Notification permission is not set!")
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                            {
                                success, error in
                                    if success {
                                        switch type {
                                                case 0: //daily
                                                        let title = NSLocalizedString("Вы не забыли отметить, что сняли линзы?", comment: "daily reminder text caption (view model)")
                                                        let subtitle = NSLocalizedString("Для точного учета срока годности линзы не забудьте 'Снять линзы' в приложении LenseTracker", comment: "daily reminder text content (view model)")
                                                        self.throwNotification(reminderTime: self.myModel.dailyReminderTime, title: title, subtitle: subtitle)
                                                case 1: //expiration
                                                        let title = NSLocalizedString("Пора заменить линзы!", comment: "expiration reminder caption (view model)")
                                                        let subtitle = NSLocalizedString("У линз истек срок годности - необходимо надеть новые. Не забудьте 'Сменить линзы' в приложении LenseTracker, когда сделаете это!", comment: "expiration reminder content (view model)")
                                                        self.throwNotification(reminderTime: self.myModel.expirationReminderTime, title: title, subtitle: subtitle)
                                                default: break
                                                }
                                    }
                                else if let error = error { print(error) }
                            }
             } else {
                 switch type {
                         case 0: //daily
                                 let title = NSLocalizedString("Вы не забыли отметить, что сняли линзы?", comment: "daily reminder text caption (view model)")
                                 let subtitle = NSLocalizedString("Для точного учета срока годности линзы не забудьте 'Снять линзы' в приложении LenseTracker", comment: "daily reminder text content (view model)")
                     self.throwNotification(reminderTime: self.myModel.dailyReminderTime, title: title, subtitle: subtitle)
                         case 1: //expiration
                                 let title = NSLocalizedString("Пора заменить линзы!", comment: "expiration reminder caption (view model)")
                                 let subtitle = NSLocalizedString("У линз истек срок годности - необходимо надеть новые. Не забудьте 'Сменить линзы' в приложении LenseTracker, когда сделаете это!", comment: "expiration reminder content (view model)")
                     self.throwNotification(reminderTime: self.myModel.expirationReminderTime, title: title, subtitle: subtitle)
                         default: break
                         }
             }
        }
    }
    
    func calcReminderTime(dateValue: Date) -> Int {
        //calc minutes from date value to now and return int of minutes to set up reminder
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateValue)
        let minutes = calendar.component(.minute, from: dateValue)
        let interval = (hour*60+minutes)*60
        return interval
    }
    
    func getReminderTimeInDateFormat(rTime: Int) -> Date {
            
        let date = Date()
        let startOfDay = date.startOfDay
        let convertedTime = Date(timeInterval: TimeInterval(rTime), since: startOfDay)
        
        return convertedTime
    }
    
    //MARK: Intents
    
    func setOptions(dailyReminder: Bool, expirationReminder: Bool, dailyReminderTime: Int, expirationReminderTime: Int) {
        myModel.setOptions(dailyReminder: dailyReminder, expirationReminder: expirationReminder, dReminder: dailyReminderTime, eReminder: expirationReminderTime)
    }
    
    func PutLensesOn() {
        myModel.putOn(onDate: Date())
        debugPrint("lenses are on, managing reminders. ExceededUsageReminder is \(myModel.exceedUsageReminder), isExpired is \(myModel.isExpired)")
        if myModel.dailyReminders {
            debugPrint("setting up daily reminder")
            setReminder(time: myModel.dailyReminderTime, type: 0)
        }
        if myModel.exceedUsageReminder && myModel.isExpired {
            debugPrint("setting up expiration reminder")
            setReminder(time: myModel.expirationReminderTime, type: 1)
        }
    }
    
    func takeLensesOff() {
        myModel.takeOff(offDate: Date())
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func createNewLenses(_ vendor: String, _ model: String, _ force: Double, _ valid: Int, _ continuousValid: Int) {
        myModel.createNew(vendor: vendor, model: model, force: force, valid: valid, continuousValid: continuousValid)
        myModel.putOn(onDate: Date())
        if myModel.dailyReminders {
            debugPrint("setting up daily reminder")
            setReminder(time: myModel.dailyReminderTime, type: 0)
        }
        if myModel.exceedUsageReminder && myModel.isExpired {
            debugPrint("setting up expiration reminder")
            setReminder(time: myModel.expirationReminderTime, type: 1)
        }
    }
    
    func getMyLensesState() -> Bool {
        return myModel.areMyLensesOn 
    }
    
}
        

