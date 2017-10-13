//
//  ProfileViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Settings: String {
    case changePass = "Change password"
    case logout = "Logout"
    static let allValues = [changePass, logout]
    
    func icon() -> UIImage {
        switch self {
        case .changePass:
            return UIImage.init(named: "Password")!
        case .logout:
            return UIImage.init(named:"Logout")!
        }
    }
}

class ProfileViewController: UIViewController {
    
    //Properties
    let profileView = InfoView(frame: .zero)
    let profileTableView = ProfileTableView(frame: .zero)
    
    //Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupProfileView()
        setupProfileTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["profile": profileView, "profileTV": profileTableView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[profile]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[profileTV]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[profile]-(10)-[profileTV]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 5.0)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Setup views
    func setupProfileView() {
        profileView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        // unowned because the profileView lives as long as the VC lives
        // If profileView lives shorter than VC, it could be set as weak
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        profileView.data = (title: associate.name, icon: nil, action: {
            [unowned self] in
            self.changeProfileImage()
        })
    }
    
    func setupProfileTableView() {
        profileTableView.dataSource = Settings.allValues
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
    func didSelectProfileImage(mediaViewController: MediaViewController, image: UIImage?) {
        profileView.data = (title: "Mohamed Maalej (645438)", icon: image!, action: { [unowned self] in
            self.changeProfileImage()
        })
    }
}
