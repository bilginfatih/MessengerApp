//
//  OnboardingCollectionCollectionViewCell.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 4.11.2022.
//

import UIKit

class OnboardingCollectionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescriptionLabel: UILabel!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.description
    }
}
