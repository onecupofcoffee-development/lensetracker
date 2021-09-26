//
//  LenseTrackerViewModel.swift
//  lensetracker
//
//  Created by Мак on 15.09.2021.
//

import SwiftUI

class LenseTrackerViewModel : ObservableObject {
    @Published var myModel: LenseTrackerModel
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
    
        myModel = LenseTrackerModel()
    }
    
    //MARK: Intents
    
    func PutLensesOn() {
        myModel.putOn()
    }
    
    func takeLensesOff() {
        myModel.takeOff()
    }

    func createNewLenses(_ force: Double, _ valid: Int) {
        myModel.createNew(force: force, valid: valid)
    }
    
    func getMyLensesState() -> Bool {
        return myModel.areMyLensesOn 
    }
    
}
