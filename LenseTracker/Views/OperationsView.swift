//
//  OperationsView.swift
//  LenseTracker
//
//  Created by Мак on 30.08.2021.
//

import SwiftUI

struct OperationsViewOn: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        Group {
                    Text("Put on your lenses!")
                    Button("pop back") {
                        self.presentation.wrappedValue.dismiss()
                    }
                    .buttonStyle(standardButton())
                }
    }
    
}

struct OperationsViewOff: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        Group {
                    Text("Take off your lenses!")
                    Button("pop back") {
                        self.presentation.wrappedValue.dismiss()
                    }
                    .buttonStyle(standardButton())
                }
    }
    
}

struct OperationsViewOn_Previews: PreviewProvider {
    static var previews: some View {
        OperationsViewOn()
    }
}

struct OperationsViewOff_Previews: PreviewProvider {
    static var previews: some View {
        OperationsViewOff()
    }
}
