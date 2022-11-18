//
//  ContentView.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 14.11.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = DrawingManager()
    @State private var addNewShown = false
    
    var body: some View {
        
            List {
                ForEach(manager.docs) { doc in
                    NavigationLink(destination: DrawingWrapper(manager: manager, id: doc.id),
                        label: { Text(doc.name) })
                }.onDelete(perform: manager.delete)
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", action: {
                            self.addNewShown.toggle()
                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("action2", action: {
                            
                        })
                    }
                }
                .sheet(isPresented: $addNewShown, content: {
                    AddNewDocument(manager: manager, addShown: $addNewShown)
                })
            PlaceholderView()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*class ContentViewVHC: UIHostingController<ContentView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ContentView())
    }
 
 .navigationBarItems(trailing: Button("Add"){
     self.addNewShown.toggle()
 })
 .sheet(isPresented: $addNewShown, content: {
     AddNewDocument(manager: manager, addShown: $addNewShown)
 })
} */
