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
                }
                Spacer()
                Text("(с) 2021 Andrey Lesnykh")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.footnote)
                    .padding()
                NavigationLink(destination: SetupLensesView(opticalForce: "", validPeriod: "") ,tag: "Setup", selection: $selection) { EmptyView() }
            }
            
        }
    }
}

struct lenseImage: View {
    @State var ison: Bool
    @State var limit: Double
    @State var utilization: Double
    
    func getGaugeColor() -> Color {
            let choice = 1 - utilization/limit
            print(limit, utilization, choice)
            if choice < 0.25 {
                return Color.red
            }
            else {
                return Color.green
            }
    }
    
    var body: some View {
        ZStack {
                ProgressView("Состояние линзы: ", value: limit-utilization, total: limit)
                .progressViewStyle(GaugeProgressStyle(strokeColor: getGaugeColor()))
                        .frame(width: 280, height: 280)
                        .contentShape(Rectangle())
                    .zIndex(3)
                Image("lense")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .zIndex(2)
                Circle()
                    .frame(width: 250, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .zIndex(1)
            if ison {
                Circle()
                    .frame(width: 270, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.green)
                    .zIndex(4)
                    .opacity(0.3)
            }
            else {
                Circle()
                    .frame(width: 270, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.gray)
                    .zIndex(4)
                    .opacity(0.3)
            }
        }
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    @State var strokeColor: Color
    var strokeWidth = 8.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(fractionCompleted))
                .stroke(strokeColor, style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round))
                .rotationEffect(.degrees(-90))
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
