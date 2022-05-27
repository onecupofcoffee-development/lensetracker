//
//  SetupLensesView.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 20.09.2021.
//

import SwiftUI

struct SetupLensesView: View {
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @Environment(\.presentationMode) var presentation
    
    @State var lenseVendor: String
    @State var lenseModel: String
    @State var opticalForce: String
    @State var validPeriod: String
    
    let forceOptions = [
        "-10",
        "-9.5",
        "-9",
        "-8.5",
        "-8",
        "-7.5",
        "-7",
        "-6.5",
        "-6",
        "-5.5",
        "-5",
        "-4.5",
        "-4",
        "-3.5",
        "-3",
        "-2.5",
        "-2",
        "-1.5",
        "-1",
        "-0.5"
    ]
    
    let validOptions = [
        "0",
        "1",
        "7",
        "14",
        "21",
        "30",
        "90",
        "180"
    ]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(String(format: NSLocalizedString("Параметры линз", comment: "Lense parameters (setup view)")))) {
                    
                    Section(header: Text(String(format: NSLocalizedString("Производитель", comment: "Vendor")))) {
                        TextField(myViewModel.myModel.lenseVendor, text: $lenseVendor)
                            .font(.footnote)
                            .accessibilityIdentifier("VendorInput")
                    }
                    Section(header: Text(String(format: NSLocalizedString("Модель", comment: "Lense model")))) {
                        TextField(myViewModel.myModel.lenseModel, text: $lenseModel)
                            .font(.footnote)
                            .accessibilityIdentifier("ModelInput")
                    }
                    
                    Picker(NSLocalizedString("Оптическая сила линз: ", comment: "Lense optical force")+String(myViewModel.myModel.opticalForce), selection: $opticalForce) {
                        ForEach(forceOptions, id:  \.self) {
                            Text($0)
                        }
                    }
                    .accessibilityIdentifier("OptForce")
                    
                    
                    Picker(NSLocalizedString("Сколько дней можно носить: ", comment: "valid, days (setup view)")+String(myViewModel.myModel.validPeriod), selection: $validPeriod) {
                        ForEach(validOptions, id:  \.self) {
                            Text($0)
                        }
                    }
                    .accessibilityIdentifier("DaysValid")
                    
                
                    Section {
                        Button(action: {
                            let f = Double(opticalForce) ?? -2
                            let v = Int(validPeriod) ?? 14
                            let vendor = lenseVendor //?? "Pure Vision"
                            let model = lenseModel //?? "Oasys"
                            
                            myViewModel.createNewLenses(vendor, model, f, v)
                            self.presentation.wrappedValue.dismiss()
                            }
                        )
                            {
                                Text(String(format: NSLocalizedString("Сохранить и надеть", comment: "save and put on (setup view)")))
                                    .accessibilityIdentifier("SaveAndPutOn")
                            }
                    }
                }
            }
        }
    }
}

struct SetupLensesView_Previews: PreviewProvider {
    static var previews: some View {
        SetupLensesView(lenseVendor: "", lenseModel: "", opticalForce: "", validPeriod: "")
            .environmentObject(LenseTrackerViewModel())
    }
}

