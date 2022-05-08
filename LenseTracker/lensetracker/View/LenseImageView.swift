//
//  LenseImageView.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 26.09.2021.
//

import SwiftUI

struct lenseImage: View {
    @State var ison: Bool
    @State var limit: Double
    @State var utilization: Double
    
    func getGaugeColor() -> Color {
            let choice = 1 - utilization/limit
            if choice < 0.25 {
                return Color.red
            }
            else {
                return Color.green
            }
    }
    
    func getFillColor() -> Color {
        
        if ison {
            if utilization >= limit {
                return Color.red
            }
            else {
                return Color.green
            }
        }
        else {
            if utilization >= limit {
                return Color.red
            }
            else {
                return Color.gray
            }
        }
    }
    
    var body: some View {
        ZStack {
            if utilization >= limit {
                ProgressView("Состояние линзы: ", value: 1, total: 1)
                    .progressViewStyle(GaugeProgressStyle(strokeColor: Color.red))
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
                .zIndex(1)}
            else {
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
            }
            Circle()
                .frame(width: 270, height: 270, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(getFillColor())
                .zIndex(4)
                .opacity(0.3)
        }//z-stack
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
