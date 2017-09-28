//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        loadLoginView()
    }
    
    //MARK:- Layout
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
        loginView.createPasswordAction = { [weak self] in
            self?.loadCreatePasswordView()
        }
        loginView.requestIDAction = { [weak self] in
            self?.loadRequestIDView()
        }
        loginView.loginAction = { (username: String, password: String) in
            self.login(username: username, password: password)
        }
        
        layout(forView: loginView)
    }
    
    func loadCreatePasswordView() {
        let createPasswordView = CreatePasswordView(frame: .zero)
        createPasswordView.closeButtonAction = { [weak self] in
            self?.loadLoginView()
        }
        layout(forView: createPasswordView)
    }
    
    func loadRequestIDView() {
        let requestIDView = RequestIDView(frame: .zero)
        requestIDView.closeButtonAction = { [weak self] in
            self?.loadLoginView()
        }
        layout(forView: requestIDView)
    }
    
    //MARK:- Network calls
    func login(username: String, password: String) {
        LoginService.login(username: username, password: password, completion: { (response: Bool) in
            guard response == true else {
                return
            }
            let homeVC = HomeViewController()
            self.navigationController?.pushViewController(homeVC, animated: true)
        })
    }
}
