//
//  LenseTrackerViewModel.swift
//  lensetracker
//
//  Created by Мак on 15.09.2021.
//

import SwiftUI
import CoreData

class LenseTrackerViewModel : ObservableObject {
    @Published var myModel: LenseTrackerModel {
        didSet {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(myModel) {
                    UserDefaults.standard.set(encodedData, forKey: "LenseData")
                }
        }
    }
    
    init() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.object(forKey: "LenseData") as? Data {
            if let savedStruct = try? decoder.decode(LenseTrackerModel.self, from: savedData) {
                self.myModel = savedStruct
                print("decoded data is \(savedStruct)")
                return
            }
        }
        self.myModel = LenseTrackerModel()
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
