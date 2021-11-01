//
//  lensetrackerApp.swift
//  lensetracker
//
//  Created by Andrey Lesnykh on 13.09.2021.
//

import SwiftUI

@main
struct lensetrackerApp: App {
    
    @StateObject var myViewModel = LenseTrackerViewModel()
    
    var body: some Scene {
        WindowGroup {
            LenseTrackerView()
                .environmentObject(myViewModel)
        }
    }
}
