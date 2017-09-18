//
//  MessageViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "New message"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        self.view.backgroundColor = .white
    }
    
    //MARK:- Layout
    func layout() {
        messageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(messageView)
        
        self.messageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.messageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        self.messageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        self.messageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    //MARK:- Selectors
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:-
    func setupNaviBarButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named:"Close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let dismissBtn = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = dismissBtn
    }
}
