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
                    //Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Производитель", comment: "Vendor")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("VendorLabel")
                        Text(String(myViewModel.myModel.lenseVendor))
                                .font(.title2)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("VendorValue")
                        }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Модель", comment: "Lense model")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("ModelLabel")
                        Text(String(myViewModel.myModel.lenseModel))
                                .font(.title2)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("ModelValue")
                        }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Оптическая сила линз", comment: "Lense optical force")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("OpticalForceLabel")
                        Text(String(myViewModel.myModel.opticalForce))
                                .font(.title2)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("OpticalForceValue")
                    }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Радиус кривизны", comment: "Lense curve raduis")))
                                .padding(0)
                                .font(.headline)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("CurveRaduisLabel")
                        Text(String(myViewModel.myModel.curvRadius))
                                .font(.title2)
                                .foregroundColor(.blue)
                                .accessibilityIdentifier("CurveRaduisValue")
                    }
                    Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Дней прошло (включая ночи)", comment: "Days in use (lenses detail view)")))
                            .padding(0)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .accessibilityIdentifier("DaysUsedLabel")
                        Text(String(myViewModel.myModel.daysUsed))
                            .font(.title2)
                            .foregroundColor(.blue)
                            .accessibilityIdentifier("DaysUsedValue")
                    }
                    //Divider()
                    HStack {
                        Text(String(format: NSLocalizedString("Дней осталось", comment: "Days left (lenses detail view")))
                            .padding(0)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .accessibilityIdentifier("DaysLeftLabel")
                    Text(String(myViewModel.myModel.daysLeft))
                            .font(.title2)
                            .foregroundColor(.blue)
                            .accessibilityIdentifier("DaysLeftValue")
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
