//
//  DrawingViewControllerViewController.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 13.11.2022.
//

import UIKit
import PencilKit

class DrawingViewController: UIViewController {
    
    lazy var canvas: PKCanvasView = {
        let v = PKCanvasView()
        v.drawingPolicy = .anyInput
        v.minimumZoomScale = 1
        v.maximumZoomScale = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(canvas)
        return toolPicker
    }()
    
    func configureNavigationItem() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action,
                            target: self,
                            action: #selector(share(sender:)))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri", image: UIImage(systemName: "chevron.backward"), target: self, action: #selector(backButton))
    }
    
    @objc private func backButton() {
        tabBarController?.selectedIndex = 0
    }
    
    @objc
    private func share(sender: UIBarButtonItem) {
        let format = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(bounds: canvas.bounds, format: format)
        let image = renderer.image { _ in
            canvas.drawHierarchy(in: canvas.bounds, afterScreenUpdates: true)
        }
        
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = sender
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        configureNavigationItem()
        
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        
        canvas.becomeFirstResponder()
    }
    
}
