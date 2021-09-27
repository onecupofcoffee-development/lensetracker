//
//  LenseTrackerView.swift
//  lensetracker
//
//  Created by Мак on 13.09.2021.
//

import SwiftUI

struct LenseTrackerView: View {
    var parameters = ViewSizeParameters()
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    if myViewModel.getMyLensesState() {
                        lenseImage(ison: true, limit: Double(myViewModel.myModel.validPeriod), utilization: Double(myViewModel.myModel.daysUsed))
                    }
                    else {
                        let l = Double(myViewModel.myModel.validPeriod)
                        let u = Double(myViewModel.myModel.daysUsed)
                        lenseImage(ison: false, limit: l, utilization: u)
                    }
                    
                    Spacer()
                    Divider()
                }
                    
                VStack {
                    Button(action: {
                        myViewModel.takeLensesOff()
                    }) {
                        Text("Снять линзы")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                    
                    Button(action: {
                        myViewModel.PutLensesOn()
                    }) {
                        Text("Надеть линзы")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                    
                    Button(action: {
                        self.selection = "Setup"
                    }) {
                        Text("Сменить линзы")
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
                        Text("Состояние линз")
                        .foregroundColor(.white)
                        .font(.title)
                    }
                    .frame(width: parameters.buttonWidth, height: parameters.buttonHight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(parameters.buttonRadius)
                }
                Spacer()
                Text("(с) 2021 Andrey Lesnykh")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.footnote)
                    .padding()
                NavigationLink(destination: SetupLensesView(opticalForce: "", validPeriod: "") ,tag: "Setup", selection: $selection) { EmptyView() }
                NavigationLink(destination: LensesDetails() ,tag: "Details", selection: $selection) { EmptyView() }
            }
            
        }
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
