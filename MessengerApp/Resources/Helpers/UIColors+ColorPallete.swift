//
//  UIColors+ColorPallete.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

// MARK: - Color Pallete

extension UIColor {
    static let light = #colorLiteral(red: 0.768627451, green: 1, blue: 0.9764705882, alpha: 1)
    static let photoPicker = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
    static let dark = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    static let text = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
    static let disabledText = UIColor.text.withAlphaComponent(0.8)
}
