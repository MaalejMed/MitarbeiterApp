//
//  GSDViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class GSDViewController: UIViewController {
    
    //MARK:- properties
    let contactView = InfoView(frame: .zero)
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupGSDInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "Global Service Desk"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        //IF no messages
        let alertView = AlertView(frame:.zero)
        alertView.data = (title:"No Messages", description:"You still did not exchange any message with the Global Service Desk", icon: UIImage.init(named:"NoMails"))
        layout(contentView: alertView)
    }
    
    //MARK- Setup
    func setupNaviBarButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Add")!, for: .normal)
        button.addTarget(self, action: #selector(createMsg), for: .touchUpInside)
        let createMsgBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = createMsgBtn
    }
    
    func setupGSDInfoView() {
        contactView.data = (title: "Tel: 0049 283213 12", icon:UIImage(named:"GSD"), action: nil)
        contactView.backgroundColor = UIColor.bgColor
    }
    
    //MARK:- Selectors
    @objc func createMsg() {
        let msgVC = MessageViewController()
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
    
    //MARK:-Layout
    func layout(contentView: UIView) {
        let views: [String: UIView] = ["contact": contactView, "content": contentView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        self.contactView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 10.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
