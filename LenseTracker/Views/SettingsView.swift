//
//  SettingsView.swift
//  LenseTracker
//
//  Created by Мак on 30.08.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentation
    //@Binding var toggleOn: Bool = true
    
    var body: some View {
        Group {
            VStack {
                Text("Настройки")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                    Toggle(isOn: .constant(true), label: {
                        Text("Включить напоминания")
                            .padding()
                        
                    })
                    Toggle(isOn: .constant(true), label: {
                    Text("Напоминать каждый день")
                        .padding()
                    
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Напоминать о покупке")
                            .padding()
                
                    })
                    Toggle(isOn: .constant(true), label: {
                        Text("Отслеживать каждый глаз отдельно")
                            .padding()
            
                })
                
                HStack {
                    Button("Сохранить") {
                        print("bla bla saving")
                    }
                    .buttonStyle(standardButton())
                    
                    Button("Назад") {
                        self.presentation.wrappedValue.dismiss()
                    }
                    .buttonStyle(standardButton())
                }
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

