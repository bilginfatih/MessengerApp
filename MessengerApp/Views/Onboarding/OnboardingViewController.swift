//
//  OnboardingViewController.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 4.11.2022.
//

import UIKit
import FirebaseAuth

class OnboardingViewController: UIViewController {
    
    static var authIsValid = false
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Başla", for: .normal)
            } else {
                nextButton.setTitle("İleri", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        print("onboarding")
        super.viewDidLoad()
        slides = [OnboardingSlide(title: "Birinci Sayfa", description: "Birinci Sayfa", image: #imageLiteral(resourceName: "cirtter")),
                  OnboardingSlide(title: "İkinci Sayfa", description: "İkinci Sayfa", image: #imageLiteral(resourceName: "cirtter")),
                  OnboardingSlide(title: "Üçüncü Sayfa", description: "Üçüncü Sayfa", image: #imageLiteral(resourceName: "cirtter"))
        ]
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            OnboardingViewController.authIsValid = false
        } else {
            OnboardingViewController.authIsValid = true
        }
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if (currentPage == slides.count - 1) && OnboardingViewController.authIsValid == true {
            print("kullanıcı var")
            let controller = storyboard?.instantiateViewController(withIdentifier: "DashboardTB") as! UITabBarController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true)
            /* let vc = LoginViewController()
             let nav = UINavigationController(rootViewController: vc)
             nav.modalPresentationStyle = .fullScreen
             nav.modalTransitionStyle = .flipHorizontal
             present(nav, animated: true) */
        } else if OnboardingViewController.authIsValid == false && (currentPage == slides.count - 1) {
            print("KULLANICI YOK")
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .flipHorizontal
            present(nav, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath,
                                        at: .centeredHorizontally,
                                        animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
