//
//  LoginViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 08/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- Properties
    let loginView = LoginView(frame: .zero)
    let alertView = AlertView(frame: .zero)

    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupLoginView()
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Setup views
    func setupLoginView() {
        loginView.createPasswordAction = { [weak self] in
            self?.setupCreatePasswordView()
        }
        loginView.requestIDAction = { [weak self] in
            self?.setupRequestIDView()
        }
        loginView.loginAction = { (username: String, password: String) in
            self.login(username: username, password: password)
        }
        
        layout(forView: loginView)
    }
    
    func setupCreatePasswordView() {
        let createPasswordView = CreatePasswordView(frame: .zero)
        createPasswordView.closeButtonAction = { [weak self] in
            self?.setupLoginView()
        }
        layout(forView: createPasswordView)
    }
    
    func setupRequestIDView() {
        let requestIDView = RequestIDView(frame: .zero)
        requestIDView.closeButtonAction = { [weak self] in
            self?.setupLoginView()
        }
        layout(forView: requestIDView)
    }
    
    func presentAlertView(failure: Failure) {
        let window = UIApplication.shared.keyWindow!
        alertView.data = (title:failure.description,  description: "", icon: UIImage.init(named: "Failure")!)
        window.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
        alertView.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor).isActive = true
        alertView.bottomAnchor.constraint(equalTo: window.topAnchor, constant: 60.0).isActive = true
        alertView.backgroundColor = UIColor.BgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.alertView.removeFromSuperview()
        })
    }
    
    //MARK:- Network calls
    func login(username: String, password: String) {
        loginView.loginBtn.status = .loading
        let accountManager = AccountManager()
        accountManager.login(username: username, password: password, completion: {[weak self] failure in
            self?.loginView.loginBtn.status = .idle
            guard failure == nil else {
                self?.presentAlertView(failure: failure!)
                return
            }
            let homeVC = HomeViewController()
            self?.navigationController?.pushViewController(homeVC, animated: true)
        })
    }
}
