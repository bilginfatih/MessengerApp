//
//  PlaceholderView.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 14.11.2022.
//

import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        VStack (spacing: 20) {
            Text("Let's draw somthing")
                .font(.largeTitle)
            
            Text("Select or create new drawing from left menu")
            
            Image(systemName: "scribble")
                .font(.largeTitle)
        }.foregroundColor(.gray)
    }
}


