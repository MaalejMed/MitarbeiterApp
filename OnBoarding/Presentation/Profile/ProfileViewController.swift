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
    let serverResponseView = ServerResponseView(frame: .zero)
    
    //Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupProfileTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
        setupProfileView()
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
        profileView.data = (title: associate.name, icon: associate.image, action: {
            [unowned self] in
            self.presentMediaController()
        })
    }
    
    func setupProfileTableView() {
        profileTableView.dataSource = Settings.allValues
    }
    
    //MARK:- Actions
    func presentMediaController() {
        let mediaController = MediaViewController()
        mediaController.setupImagePickerController()
        mediaController.delegate = self
        self.present(mediaController, animated: true, completion: nil)
    }
    
    func change(profileImage: UIImage) {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        
        guard let profileImageString = profileImage.toString() else {
            return
        }
        
        //update Data Manager
        DataManager.sharedInstance.associate?.update(ProfilePhoto: profileImage)
        profileView.data = (title: associate.name, icon: profileImage, action: { [unowned self] in
            self.presentMediaController()
        })
        
        //save image in the server
        let dic: [String: Any] = [
            "associateID": associate.identifier!,
            "photo": profileImageString
        ]
        
        let associateManager = AssociateManager()
        associateManager.updatePhoto(dic: dic, completion:{[weak self] response in
            self?.serverResponseView.present(serverResponse: response!)
        })
    }
}

extension ProfileViewController: MediaViewControllerDelegate {
    func didSelectProfileImage(mediaViewController: MediaViewController, image: UIImage?) {
        guard let profileImage = image else {
            return
        }
        
        change(profileImage: profileImage)
    }
}
