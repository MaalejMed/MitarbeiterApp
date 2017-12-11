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
    let serverResponseView = ServerResponseView(frame: .zero)

    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        setupLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       loginView.reset()
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
        loginView.loginAction = {[weak self] (username: String, password: String) in
            self?.loginView.loginBtn.status = .loading
            self?.login(username: username, password: password)
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

    
    //MARK:- Network calls
    func login(username: String, password: String) {
        loginView.loginBtn.status = .loading
        let assoManager = AssociateManager()
        assoManager.selectAssociate(username: "645438", password: "12345", completion: {[weak self] serverResponse, associate in
            guard let existingAssociate = associate else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                self?.loginView.loginBtn.status = .idle
                return
            }
            DataManager.sharedInstance.setupFor(associate: existingAssociate)
            let homeVC = HomeViewController()
            self?.navigationController?.pushViewController(homeVC, animated: true)
            self?.loginView.loginBtn.status = .idle
            let _ = self?.loginView.remainConnectedSwt.isOn == true ? AssociateManager.kcSave(associate: existingAssociate) : nil
        })
    }
}
