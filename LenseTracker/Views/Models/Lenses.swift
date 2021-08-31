//
//  Lenses.swift
//  LenseTracker
//
//  Created by Мак on 31.08.2021.
//

import Foundation
import SwiftUI

struct Lense: Codable {
    let Supplier: String
    let Model: String
    let Power: Float16
    let Raduis: Float16
    let Color: String
    let ValidFor: Int
    var AmountInBox: Int
    
    init (supplier: String, model: String, power: Float16, radius: Float16, color: String, valid: Int, amnt: Int) {
        Supplier = supplier
        Model = model
        Power = power
        Raduis = radius
        Color = color
        ValidFor = valid
        AmountInBox = amnt
    }
}

struct Lenses : Codable, Identifiable {
    let id: Int
    let Left: Lense
    let Right: Lense
    let days_left: Int
    let days_right: Int
    
}
