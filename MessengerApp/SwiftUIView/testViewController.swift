//
//  testViewController.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 14.11.2022.
//

import UIKit
import SwiftUI

class testViewController: UIViewController {
    
    let contentViewInHC = UIHostingController(rootView: ContentView())
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHC()
        setup()
        
    }
    
    func setup() {
        contentViewInHC.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewInHC.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewInHC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewInHC.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewInHC.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupHC() {
        addChild(contentViewInHC)
        view.addSubview(contentViewInHC.view)
        contentViewInHC.didMove(toParent: self)
    }

}
