//
//  LenseTrackerViewModel.swift
//  lensetracker
//
//  Created by Мак on 15.09.2021.
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
        //calculating reminder time from now to pre-set value

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let interval = reminderTime-(hour*60+minutes)*60
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Reminder was not set due to error: \(String(describing: error))")
            }
         }
    }
    
    private func setReminder(time: Int, type: Int) {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings
        { settings in
             if settings.authorizationStatus == .notDetermined {
                        print("Notification permission is not set!")
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                            {
                                success, error in
                                    if success {
                                        switch type {
                                                case 0: //daily
                                                        let title = "Вы не забыли снять линзы?"
                                                        let subtitle = "Для точного учета срока годности линзы, нажмите 'Снять линзы' в приложении LenseTracker"
                                            self.throwNotification(reminderTime: self.myModel.dailyReminderTime, title: title, subtitle: subtitle)
                                                case 1: //expiration
                                                        let title = "Не забудьте заменить линзы"
                                                        let subtitle = "Ваши линзы нужно заменить на новые - не забудьте сделать это в приложении LenseTracker!"
                                            self.throwNotification(reminderTime: self.myModel.expirationReminderTime, title: title, subtitle: subtitle)
                                                default: break
                                                }
                                    }
                                else if let error = error { print(error) }
                            }
             } else {
                 switch type {
                         case 0: //daily
                                 let title = "Вы не забыли снять линзы?"
                                 let subtitle = "Для точного учета срока годности линзы, нажмите 'Снять линзы' в приложении LenseTracker"
                     self.throwNotification(reminderTime: self.myModel.dailyReminderTime, title: title, subtitle: subtitle)
                         case 1: //expiration
                                 let title = "Не забудьте заменить линзы"
                                 let subtitle = "Ваши линзы нужно заменить на новые - не забудьте сделать это в приложении LenseTracker!"
                     self.throwNotification(reminderTime: self.myModel.expirationReminderTime, title: title, subtitle: subtitle)
                         default: break
                         }
             }
        }
    }
    
    private func calcReminderTime(dateValue: Date) -> Int {
        //calc minutes from date value to now and return int of minutes to set up reminder
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dateValue)
        let minutes = calendar.component(.minute, from: dateValue)
        let interval = hour*60+minutes
        return interval
    }
    
    func getReminderTimeInDateFormat(rTime: Int) -> Date {
            
        let date = Date()
        let startOfDay = date.startOfDay
        let convertedTime = Date(timeInterval: TimeInterval(rTime), since: startOfDay)
        
        return convertedTime
    }
    
    //MARK: Intents
    
    func setOptions(dailyReminder: Bool, expirationReminder: Bool, dailyReminderTime: Date, expirationReminderTime: Date) {
        myModel.setOptions(dailyReminder: dailyReminder, expirationReminder: expirationReminder, dReminder: calcReminderTime(dateValue: dailyReminderTime), eReminder: calcReminderTime(dateValue: expirationReminderTime))
    }
    
    func PutLensesOn() {
        myModel.putOn()
        if myModel.dailyReminders {
            setReminder(time: myModel.dailyReminderTime, type: 0)
        }
        if myModel.exceedUsageReminder && myModel.isExpired {
            setReminder(time: myModel.expirationReminderTime, type: 1)
        }
    }
    
    func takeLensesOff() {
        myModel.takeOff()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func createNewLenses(_ vendor: String, _ model: String, _ force: Double, _ valid: Int) {
        myModel.createNew(vendor: vendor, model: model, force: force, valid: valid)
        myModel.putOn()
        if myModel.dailyReminders {
            setReminder(time: myModel.dailyReminderTime, type: 0)
        }
        if myModel.exceedUsageReminder {
            setReminder(time: myModel.expirationReminderTime, type: 1)
        }
    }
    
    func getMyLensesState() -> Bool {
        return myModel.areMyLensesOn 
    }
    
}
        

