//
//  lensetrackerApp.swift
//  lensetracker
//
//  Created by Мак on 13.09.2021.
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
