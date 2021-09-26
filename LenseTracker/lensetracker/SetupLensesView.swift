//
//  SetupLensesView.swift
//  lensetracker
//
//  Created by Мак on 20.09.2021.
//

import SwiftUI

struct SetupLensesView: View {
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @Environment(\.presentationMode) var presentation
    
    @State var opticalForce: String
    @State var validPeriod: String
    
    var body: some View {
        VStack {
            Form {
                
                Section(header: Text("Параметры линз")) {
                Section(header: Text("Оптическая сила линз")) {
                    TextField("-2", text: $opticalForce)
                    
                }
                Section(header: Text("Сколько дней можно носить")) {
                    TextField("14", text: $validPeriod)
                }
                
                    Section {
                        Button(action: {
                            if let f = Double(opticalForce) {
                                if let v = Int(validPeriod) {
                                    myViewModel.createNewLenses(f, v)
                                    self.presentation.wrappedValue.dismiss()
                                    }
                                }
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
        SetupLensesView(opticalForce: "", validPeriod: "")
            .environmentObject(LenseTrackerViewModel())
    }
}

