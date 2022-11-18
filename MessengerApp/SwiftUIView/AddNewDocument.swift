//
//  AddNewDocument.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 14.11.2022.
//

import SwiftUI

struct AddNewDocument: View {
    @ObservedObject var manager: DrawingManager
    @State private var documentName: String = ""
    @Binding var addShown: Bool
    
    var body: some View {
        VStack {
            Text("Enter document name:")
            
            TextField("Enter doc name here...", text: $documentName, onCommit: {
                save(fileName: documentName)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Create") {
                save(fileName: documentName)
            }
        }.padding()
    }
    private func save(fileName: String) {
        manager.addData(doc: DrawingDocument(id: UUID(), name: fileName, data: Data()))
        addShown.toggle()
    }
}
