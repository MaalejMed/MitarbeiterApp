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
    let alertView = AlertView(frame:.zero)
    let messageTV = MessageTableView(frame: .zero)
    var messages: [Message] = []

    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupGSDInfoView()
        setupNoMessagesView()
        setupMessageTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "GSD"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
        presentContentView()
        
    }
    
    //MARK- Setup views
    func setupNaviBarButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Add")!, for: .normal)
        button.addTarget(self, action: #selector(presentMessageViewController), for: .touchUpInside)
        let createMsgBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = createMsgBtn
    }
    
    func setupGSDInfoView() {
        contactView.data = (title: "Tel: 0049 283213 12", icon:UIImage(named:"Help"), action: nil)
        contactView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
    }
    
    func setupMessageTableView() {
        messageTV.dataSource = messages
    }
    
    func setupNoMessagesView() {
        alertView.data = (title:"No Messages", description:"You still did not exchange any message with the Global Service Desk", icon: UIImage.init(named:"NoMails"))
        layout(contentView: alertView)
    }
    
    func dismissNoMessagesView() {
        alertView.removeFromSuperview()
    }
    
    func presentContentView() {
        let contentView = messages.count > 0 ? messageTV : alertView
        layout(contentView: contentView)
    }
    
    //MARK:- Selectors
    @objc func presentMessageViewController() {
        let msgVC = MessageViewController()
        msgVC.delegate = self
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
        
        self.contactView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        contentView.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 10.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension GSDViewController : MessageViewControllerDelegate {
    func didSendMessage(messageVC: MessageViewController, message: Message) {
        self.messages.append(message)
        messageTV.dataSource = self.messages
    }
}
