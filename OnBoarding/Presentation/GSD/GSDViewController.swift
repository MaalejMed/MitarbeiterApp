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
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        setupGSDInfoView()
        setupTriggerView()
        setupMessageTableView()
        fetchMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "GSD"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
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
    
    //MARK- Setup views
    func setupNavBarButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Add")!, for: .normal)
        button.addTarget(self, action: #selector(addMessageButtonTapped), for: .touchUpInside)
        let createMsgBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = createMsgBtn
    }
    
    func setupGSDInfoView() {
        contactView.data = (title: "Tel: 0049 283213 12", icon:UIImage(named:"Help"), action: nil)
        contactView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
    }
    
    func setupMessageTableView() {
        messageTV.delegate = self
    }
    
    func setupTriggerView() {
        triggerView.data = (title:"No Mails are available", icon: UIImage.init(named:"NoMails"), action: { [weak self] in
            self?.fetchMessages()
        })
    }

    //MARK:- present views
    func reloadTableView() {
        if triggerView.superview != nil {
           triggerView.removeFromSuperview()
        }
        layout(contentView: messageTV)
        messageTV.dataSource = DataManager.sharedInstance.messages
    }
    
    func presentTriggerView() {
        if messageTV.superview != nil {
            messageTV.removeFromSuperview()
        }
        layout(contentView: triggerView)
    }
    
    //MARK:- Selectors
    @objc func addMessageButtonTapped() {
        let msgVC = MessageViewController.init(type: .mainMessage, message: nil)
        msgVC.messageSentCompletion = { [unowned self] in self.reloadTableView() }
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
    
    //MARK:-
    func fetchMessages() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        
        triggerView.status = .loading
        self.presentTriggerView()
        
        MessageManager.fetchMessages(associateID: associate.identifier!, completion: { [weak self] messages in
            guard messages != nil else {
                self?.triggerView.status = .idle
                return
            }
            self?.reloadTableView()
        })
    }
}

extension GSDViewController: MessageTableViewDelegate {
    func didSelectMessage(messageTableView: MessageTableView, message: Message) {
        let messageDetailsVC = MessageDetailsViewController()
        messageDetailsVC.message = message
        self.navigationController?.pushViewController(messageDetailsVC, animated: true)
    }
}
