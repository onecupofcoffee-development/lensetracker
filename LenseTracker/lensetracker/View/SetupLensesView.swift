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
    @State var continuousValidPeriod: String
    @State var curvRaduis: String
    
    @State var continuousUse: Bool
    
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
                    Section(header: Text(String(format: NSLocalizedString("Радиус кривизны", comment: "Lense Curve Raduis")))) {
                        TextField(String(myViewModel.myModel.curvRadius), text: $curvRaduis)
                            .font(.footnote)
                            .accessibilityIdentifier("CurveRaduis")
                    }
                    
                    Picker(NSLocalizedString("Оптическая сила линз: ", comment: "Lense optical force")+String(myViewModel.myModel.opticalForce), selection: $opticalForce) {
                        ForEach(forceOptions, id:  \.self) {
                            Text($0)
                        }
                    }
                    .accessibilityIdentifier("OptForce")
                    
                    Toggle(String(format: NSLocalizedString("Меньший срок при непрерывном ношении", comment: "continuous use toggle (Lenses setup view)")), isOn: $continuousUse)
                        .accessibilityIdentifier("ContinuousUseToggle")
                    
                    if continuousUse {
                        Picker(NSLocalizedString("Сколько дней можно носить: ", comment: "valid, days (setup view)")+String(myViewModel.myModel.validPeriod), selection: $validPeriod) {
                            ForEach(validOptions, id:  \.self) {
                                Text($0)
                            }
                        }
                        .accessibilityIdentifier("DaysValid")
                        .font(.footnote)
                        Picker(NSLocalizedString("Сколько дней можно носить непрерывно: ", comment: "valid, continuous days (setup view)")+String(myViewModel.myModel.maxdaysContinuousUse), selection: $continuousValidPeriod) {
                            ForEach(validOptions, id:  \.self) {
                                Text($0)
                            }
                        }
                        .accessibilityIdentifier("DaysValidContinuous")
                        .font(.footnote)
                    }
                    else {
                        Picker(NSLocalizedString("Сколько дней можно носить: ", comment: "valid, days (setup view)")+String(myViewModel.myModel.validPeriod), selection: $validPeriod) {
                            ForEach(validOptions, id:  \.self) {
                                Text($0)
                            }
                        }
                        .accessibilityIdentifier("DaysValid")
                        .font(.footnote)
                    }
                
                    Section {
                        Button(action: {
                            let f = Double(opticalForce) ?? -2
                            let v = Int(validPeriod) ?? 14
                            let vendor = lenseVendor //?? "Pure Vision"
                            let model = lenseModel //?? "Oasys"
                            let continuousValid = Int(continuousValidPeriod) ?? 14
                            let curvRaduis = Double(curvRaduis) ?? 8.3
                            
                            myViewModel.createNewLenses(vendor, model, f, v, continuousValid, curvRaduis)
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
        SetupLensesView(lenseVendor: "", lenseModel: "", opticalForce: "", validPeriod: "", continuousValidPeriod: "", curvRaduis: "8.3", continuousUse: true)
            .environmentObject(LenseTrackerViewModel())
    }
}

