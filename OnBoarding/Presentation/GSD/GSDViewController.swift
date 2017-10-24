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
    let triggerView = TriggerView(frame: .zero)
    let messageTV = MessageTableView(frame: .zero)
    var messages: [Message] = [] {
        didSet {
            presentContentView()
        }
    }

    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupGSDInfoView()
        setupTriggerView()
        setupMessageTableView()
        setupMessagesDataSource()
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
    
    func setupTriggerView() {
        triggerView.data = (title:"No Mail are available", icon: UIImage.init(named:"NoMails"), action: { [weak self] in
            self?.setupMessagesDataSource()
        })
    }

    func presentContentView() {
        let _ = messages.count > 0 ? presentMessagesTableView() : presentTriggerView()
    }
    
    func presentMessagesTableView() {
        if triggerView.superview != nil {
            triggerView.removeFromSuperview()
        }
        layout(contentView: messageTV)
    }
    
    func presentTriggerView() {
        if messageTV.superview != nil {
            messageTV.removeFromSuperview()
        }
        triggerView.status = .loading
        layout(contentView: triggerView)
        
        //TODO: To be removed when service is implemented
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
            self?.triggerView.status = .idle
        })
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
    
    //MARK:-
    func setupMessagesDataSource() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        triggerView.status = .loading
        self.presentTriggerView()
        DataManager.sharedInstance.updateMessages(associateID: associate.identifier!, completion: {[weak self] response in
            guard response != nil else {
                self?.triggerView.status = .idle
                self?.presentTriggerView()
                return
            }
            self?.messages = DataManager.sharedInstance.messages!
            self?.messageTV.dataSource = self?.messages
            self?.presentMessagesTableView()
        })
    }
}

extension GSDViewController : MessageViewControllerDelegate {
    func didSendMessage(messageVC: MessageViewController, message: Message) {
        self.messages.append(message)
        messageTV.dataSource = self.messages
    }
}
