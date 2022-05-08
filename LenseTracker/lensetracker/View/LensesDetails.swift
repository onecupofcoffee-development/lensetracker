//
//  LensesDetails.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 27.09.2021.
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
                        Text(String(format: NSLocalizedString("Производитель", comment: "Vendor")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                        Text(String(myViewModel.myModel.lenseVendor))
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Модель", comment: "Lense model")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                        Text(String(myViewModel.myModel.lenseModel))
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Оптическая сила линз", comment: "Lense optical force")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                        Text(String(myViewModel.myModel.opticalForce))
                                .font(.title2)
                                .foregroundColor(.blue)
                    }
                        
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Сколько дней я уже ношу линзы", comment: "Days in use (lenses detail view)")))
                            .padding(0)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(String(myViewModel.myModel.daysUsed))
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Сколько дней осталось", comment: "Days left (lenses detail view")))
                            .padding(0)
                            .font(.headline)
                            .foregroundColor(.blue)
                    Text(String(myViewModel.myModel.daysLeft))
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
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
