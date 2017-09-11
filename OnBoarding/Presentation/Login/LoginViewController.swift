//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var containerView: UIView = UIView()
    var loginView: LoginView?

    override func loadView() {
        super.loadView()
        loadLoginView()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.layout()
    }
    
    func layout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    //MARK:- Login view
    func loadLoginView() {
        loginView = LoginView(frame: .zero)
        loginView?.createPasswordAction = {
            print("create password")
        }
        loginView?.generateIDAction = {
            print("generate ID")
        }
        containerView = loginView!
    }


}
