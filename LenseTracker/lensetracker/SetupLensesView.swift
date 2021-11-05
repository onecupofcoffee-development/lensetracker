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
        "-9",
        "-8",
        "-7",
        "-6",
        "-5",
        "-4",
        "-3",
        "-2",
        "-1",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10"
    ]
    
    let validOptions = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14"
    ]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Параметры линз")) {
                    
                    Section(header: Text("Производитель")) {
                        TextField(myViewModel.myModel.lenseVendor, text: $lenseVendor)
                            .font(.footnote)
                    }
                    Section(header: Text("Модель")) {
                        TextField(myViewModel.myModel.lenseModel, text: $lenseModel)
                            .font(.footnote)
                    }
                    Picker("Оптическая сила линз: "+String(myViewModel.myModel.opticalForce), selection: $opticalForce) {
                        ForEach(forceOptions, id:  \.self) {
                            Text($0)
                        }
                    }
                    Picker("Сколько дней можно носить: "+String(myViewModel.myModel.validPeriod), selection: $validPeriod) {
                        ForEach(validOptions, id:  \.self) {
                            Text($0)
                        }
                    }
                
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
                                Text("Сохранить и надеть")
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

