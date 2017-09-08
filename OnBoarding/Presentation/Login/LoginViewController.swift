//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.layout()
    }
    
    func layout() {
        self.loginView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginView)
        loginView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loginView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }


}
