//
//  PhotoViewerViewController.swift
//  MessengerApp
//
//  Created by Fatih Bilgin on 31.10.2022.
//

import UIKit
import SDWebImage

class PhotoViewerViewController: UIViewController {
    
    private let url: URL
    
    init(with url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fotoğraf"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.sd_setImage(with: self.url)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Geri", image: UIImage(systemName: "chevron.backward"), target: self, action: #selector(backButton))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    
    @objc func backButton() {
        tabBarController?.tabBar.isHidden = false
        let vc = ConversationsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
