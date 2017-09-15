//
//  ProfileViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Properties
    let profileView = ProfileView(frame: .zero)
    
    //Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.bgColor
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["profile": profileView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[profile]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Setup views
    func setupProfileView() {
        profileView.data = (name: "Mohamed Maalej (645438)", profileImage: UIImage.init(named: "Logo")!, changeProfileImageAction: {
            self.changeProfileImage()
        })
        profileView.backgroundColor = UIColor.bgColor
    }
    
    //MARK:- Others
    func changeProfileImage() {
        let mediaController = MediaViewController()
        mediaController.setupImagePickerController()
        mediaController.delegate = self
        self.present(mediaController, animated: true, completion: nil)
    }
}

extension ProfileViewController: MediaViewControllerDelegate {
    func didSelectProfileImage(image: UIImage?) {
        profileView.data = (name: "Mohamed Maalej (645438)", profileImage: image!, changeProfileImageAction: {
            self.changeProfileImage()
        })
    }
}


