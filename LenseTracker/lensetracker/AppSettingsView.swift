//
//  AppSettingsView.swift
//  lensetracker
//
//  Created by Мак on 04.10.2021.
//

import SwiftUI

struct AppSettingsView: View {
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @Environment(\.presentationMode) var presentation
    
    @State private var dailyReminder = true
    @State private var expirationReminder = true
    //@State
    private var dailyReminderTime: Binding<Date> {
        Binding(
            get: { myViewModel.getReminderTimeInDateFormat(rTime: myViewModel.myModel.dailyReminderTime) }, set: { _ in }
        )
    }
    private var expirationReminderTime: Binding<Date> {
        Binding(
            get: { myViewModel.getReminderTimeInDateFormat(rTime: myViewModel.myModel.expirationReminderTime) }, set: { _ in }
        )
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Ежедневные напоминания")) {
                    Toggle("Напоминать снять линзы каждый день", isOn: $dailyReminder)
                    DatePicker("Время напоминания", selection: dailyReminderTime, displayedComponents: .hourAndMinute)
                }
                //replace with some valid selection tool instead of text input
                Section(header: Text("Замена линз")) {
                    Toggle("Напоминать о скорой замене линз", isOn: $expirationReminder)
                    DatePicker("Время напоминания", selection: expirationReminderTime, displayedComponents: .hourAndMinute)
                }
                    
                Section {
                    Button(action: {
                        myViewModel.setOptions(dailyReminder: dailyReminder, expirationReminder: expirationReminder, dailyReminderTime: dailyReminderTime.wrappedValue, expirationReminderTime: expirationReminderTime.wrappedValue)
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
        AppSettingsView()
            .environmentObject(LenseTrackerViewModel())
    }
}
