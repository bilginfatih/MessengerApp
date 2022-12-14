//
//  Extentions.swift
//  Zey
//
//  Created by Fatih Bilgin on 9.11.2022.
//

import Foundation
import UIKit

extension UIButton{
    
    func pressedColour(colour: UIColor){
        
        let origImage = self.imageView?.image
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .highlighted)
        //self.imageView?.contentMode = .scaleAspectFill
        self.tintColor = colour
    }
    func pressedColour(colour: UIColor, uiImage: UIImage?,  alphaMultiplier: CGFloat){
        let origImage = uiImage
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .highlighted)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        colour.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.tintColor = UIColor(red: red, green: green, blue: blue, alpha: alpha * alphaMultiplier)
    }
}
