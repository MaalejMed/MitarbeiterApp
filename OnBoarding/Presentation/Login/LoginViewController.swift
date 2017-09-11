//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loadLoginView()
    }
    
    func layout(forView view: UIView) {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    //MARK:- Login view
    func loadLoginView() {
        let loginView = LoginView(frame: .zero)
        loginView.createPasswordAction = {
            self.loadCreatePasswordView()
        }
        loginView.generateIDAction = {
            print("generate ID")
        }
        layout(forView: loginView)
    }
    
    func loadCreatePasswordView() {
        let createPasswordView = CreatePasswordView(frame: .zero)
        layout(forView: createPasswordView)
    }
}
