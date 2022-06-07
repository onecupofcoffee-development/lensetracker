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
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(String(format: NSLocalizedString("Ежедневные напоминания", comment: "daily reminders (app settings view)")))) {
                    Toggle(String(format: NSLocalizedString("Напоминать снять линзы каждый день", comment: "daily reminder toggle (app settings view)")), isOn: $dailyReminder)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("DailyReminderToggle")
                    DatePicker(NSLocalizedString("Время напоминания", comment: "daily reminder time picker (app settings view)"), selection: dailyReminderTime, displayedComponents: .hourAndMinute)
                }
                Section(header: Text(String(format: NSLocalizedString("Замена линз", comment: "expiration reminder (app settings view)")))) {
                    Toggle(String(format: NSLocalizedString("Напоминать о скорой замене линз", comment: "expiration reminder toggle (app settings view)")), isOn: $expirationReminder)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("ChangeReminderToggle")
                    DatePicker(NSLocalizedString("Время напоминания", comment: "expiration reminder time picker (app settings view)"), selection: expirationReminderTime, displayedComponents: .hourAndMinute)
                }
                    
                Section {
                    Button(action: {
                        myViewModel.setOptions(dailyReminder: dailyReminder, expirationReminder: expirationReminder, dailyReminderTime: intDReminderime, expirationReminderTime: intEReminderime)
                        self.presentation.wrappedValue.dismiss()
                        }
                    )
                        {
                            Text(String(format: NSLocalizedString("Сохранить и закрыть", comment: "save and close button (app settings view)")))
                        }
                        .accessibilityIdentifier("SaveAndCloseAppSettings")
                }
            }
            Spacer()

            Text(String(format: NSLocalizedString("Версия приложения: ", comment: "app version info (app settings view)"))+(appVersion ?? String(format: NSLocalizedString("Информация о версии недоступна", comment: "app version info not available (app settings view"))))
                .font(.footnote)
        }
    }
}

struct AppSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppSettingsView(dailyReminder: true, expirationReminder: true, intDReminderime: 600, intEReminderime: 1200)
            .environmentObject(LenseTrackerViewModel())
    }
}
