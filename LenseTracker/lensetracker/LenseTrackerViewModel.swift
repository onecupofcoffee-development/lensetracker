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
    @Published var myModel: LenseTrackerModel {
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
                //print("decoded data is \(savedStruct)")
                return
            }
        }
        self.myModel = LenseTrackerModel()
    }
    
    private func throwNotification(reminderTime: Int) {
        let content = UNMutableNotificationContent()
        //calculating reminder time
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let interval = reminderTime*60*60-(hour*60+minutes)*60
        content.title = "Вы не забыли снять линзы?"
        content.subtitle = "Для точного учета срока годности линзы, нажмите 'Снять линзы' в приложении LenseTracker"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Reminder was not set due to error: \(String(describing: error))")
            }
         }
    }
    
    private func setLenseReminder(time: Int) {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings
        { settings in
             if settings.authorizationStatus == .notDetermined {
                        print("Notification permission is not set!")
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
                            {
                                success, error in
                                    if success {
                                        self.throwNotification(reminderTime: time)
                                    }
                                else if let error = error { print(error) }
                            }
             } else {
                 self.throwNotification(reminderTime: time)
             }
        }
    }
    
    //MARK: Intents
    
    func setOptions() {
        
    }
    
    func PutLensesOn() {
        myModel.putOn()
        setLenseReminder(time: 22)
    }
    
    func takeLensesOff() {
        myModel.takeOff()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func createNewLenses(_ vendor: String, _ model: String, _ force: Double, _ valid: Int) {
        myModel.createNew(vendor: vendor, model: model, force: force, valid: valid)
        myModel.putOn()
        setLenseReminder(time: 22)
    }
    
    func getMyLensesState() -> Bool {
        return myModel.areMyLensesOn 
    }
    
}
