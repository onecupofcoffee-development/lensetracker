//
//  LenseTrackerView.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 13.09.2021.
//

import SwiftUI

struct LenseTrackerView: View {
    var parameters = ViewSizeParameters()
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                    if myViewModel.getMyLensesState() {
                            lenseImage(ison: true, limit: Double(myViewModel.myModel.validPeriod), utilization: Double(myViewModel.myModel.daysUsed))
                            .onTapGesture {
                                myViewModel.takeLensesOff()
                            }
                    }
                    else {
                        lenseImage(ison: false, limit: Double(myViewModel.myModel.validPeriod), utilization: Double(myViewModel.myModel.daysUsed))
                            .onTapGesture {
                                myViewModel.PutLensesOn()
                            }
                    }
                    Spacer()
                    Divider()

                VStack {
                    
                    Button(action: {
                        myViewModel.takeLensesOff()
                        self.selection = "Setup"
                    }) {
                        Text(String(format: NSLocalizedString("Сменить линзы", comment: "Change lenses (main view)")))
                        .foregroundColor(.white)
                        .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                    
                    Button(action: {
                        self.selection = "Details"
                    }) {
                        Text(String(format: NSLocalizedString("Состояние линз", comment: "Lenses condition (main view)")))
                        .foregroundColor(.white)
                        .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                    
                    Button(action: {
                        self.selection = "Settings"
                    }) {
                        Text(String(format: NSLocalizedString("Настройки", comment: "Settings (main view)")))
                        .foregroundColor(.white)
                        .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                }
                Text("(с) 2021 Andrey Lesnykh")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.footnote)
                    .padding(50)
                Spacer()
                
                NavigationLink(destination: SetupLensesView(lenseVendor: myViewModel.myModel.lenseVendor, lenseModel: myViewModel.myModel.lenseModel, opticalForce: String(myViewModel.myModel.opticalForce), validPeriod: String( myViewModel.myModel.validPeriod)) ,tag: "Setup", selection: $selection)
                    { EmptyView() }
                NavigationLink(destination: LensesDetails() ,tag: "Details", selection: $selection) { EmptyView() }
                NavigationLink(destination: AppSettingsView(dailyReminder: myViewModel.myModel.dailyReminders, expirationReminder: myViewModel.myModel.exceedUsageReminder, intDReminderime: myViewModel.myModel.dailyReminderTime, intEReminderime: myViewModel.myModel.expirationReminderTime) ,tag: "Settings", selection: $selection) { EmptyView() }
            }
            
        }
        .navigationViewStyle(.stack)
        .padding()
    }
}

struct ViewSizeParameters {
    let buttonWidth: CGFloat = 250
    let buttonHight : CGFloat = 40
    let buttonRadius : CGFloat = 40
    //todo: add image & progress bar values here
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        LenseTrackerView()
            .environmentObject(LenseTrackerViewModel())
    }
}
