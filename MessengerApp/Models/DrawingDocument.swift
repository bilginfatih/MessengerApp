//
//  DrawingDocument.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 14.11.2022.
//

import Foundation

struct DrawingDocument: Identifiable {
    let id: UUID
    var name: String
    var data: Data
}
