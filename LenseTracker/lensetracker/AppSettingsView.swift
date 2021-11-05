//
//  AppSettingsView.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 04.10.2021.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @Environment(\.presentationMode) var presentation
    
    @State var dailyReminder: Bool
    @State var expirationReminder: Bool
    
   @State var intDReminderime: Int
   @State var intEReminderime: Int
    
    private var dailyReminderTime: Binding<Date> {
        Binding(
            get: { myViewModel.getReminderTimeInDateFormat(rTime: myViewModel.myModel.dailyReminderTime) },
            set: { dailyReminderTime in
                intDReminderime = myViewModel.calcReminderTime(dateValue: dailyReminderTime)
            }
        )
    }
    private var expirationReminderTime: Binding<Date> {
        Binding(
            get: { myViewModel.getReminderTimeInDateFormat(rTime: myViewModel.myModel.expirationReminderTime) },
            set: { expirationReminderTime in
                intEReminderime = myViewModel.calcReminderTime(dateValue: expirationReminderTime)
            }
        )
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Ежедневные напоминания")) {
                    Toggle("Напоминать снять линзы каждый день", isOn: $dailyReminder)
                    DatePicker("Время напоминания", selection: dailyReminderTime, displayedComponents: .hourAndMinute)
                }
                Section(header: Text("Замена линз")) {
                    Toggle("Напоминать о скорой замене линз", isOn: $expirationReminder)
                    DatePicker("Время напоминания", selection: expirationReminderTime, displayedComponents: .hourAndMinute)
                }
                    
                Section {
                    Button(action: {
                        myViewModel.setOptions(dailyReminder: dailyReminder, expirationReminder: expirationReminder, dailyReminderTime: intDReminderime, expirationReminderTime: intEReminderime)
                        self.presentation.wrappedValue.dismiss()
                        }
                    )
                        {
                            Text("Сохранить и закрыть")
                        }
                }
            }
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(dailyReminder: true, expirationReminder: true, intDReminderime: 600, intEReminderime: 1200)
            .environmentObject(LenseTrackerViewModel())
    }
}
