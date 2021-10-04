//
//  LensesDetails.swift
//  lensetracker
//
//  Created by Мак on 27.09.2021.
//

import SwiftUI

struct LensesDetails: View {
    @EnvironmentObject var myViewModel: LenseTrackerViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Image("lense")
                .resizable()
                .scaledToFill()
                .zIndex(1)
                VStack {
                Divider()
                HStack {
                Text("Оптическая сила линз")
                        .padding(20)
                        .font(.headline)
                        .foregroundColor(.blue)
                Text(String(myViewModel.myModel.opticalForce))
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Divider()
                HStack {
                    Text("Сколько дней я уже ношу линзы")
                        .padding(20)
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(String(myViewModel.myModel.daysUsed))
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Divider()
                HStack {
                    Text("Сколько дней осталось")
                        .padding(20)
                        .font(.headline)
                        .foregroundColor(.blue)
                Text(String(myViewModel.myModel.daysLeft))
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                    Divider()
                }
                .zIndex(2)
            }
        }
    }
}

struct LensesDetails_Previews: PreviewProvider {
    static var previews: some View {
        LensesDetails()
            .environmentObject(LenseTrackerViewModel())
    }
}
