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
            guard messages.count > 0 else {
                triggerView.status = .idle
                presentTriggerView()
                return
            }
            self.messageTV.dataSource = self.messages
            presentMessagesTableView()
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
        //presentContentView()
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
    func setupNaviBarButtons() {
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
            self?.setupMessagesDataSource()
        })
    }

    //MARK:-
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
        layout(contentView: triggerView)
    }
    
    //MARK:- Selectors
    @objc func addMessageButtonTapped() {
        let msgVC = MessageViewController.init(type: .main, mainMessage: nil)
        msgVC.messageDelegate = self
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
    
    //MARK:-
    func setupMessagesDataSource() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        
        triggerView.status = .loading
        self.presentTriggerView()
        
        DataManager.sharedInstance.updateMessages(associateID: associate.identifier, completion: {[weak self] serverResponse in
            guard serverResponse == nil else {
                self?.triggerView.status = .idle
                self?.presentTriggerView()
                return
            }
            self?.messages = DataManager.sharedInstance.messages
        })
    }
}

extension GSDViewController : MessageViewControllerDelegate {
    func didSendMessage(messageVC: MessageViewController?, message: Message) {
        messages = DataManager.sharedInstance.messages
    }
}

extension GSDViewController: MessageDetailsViewControllerDelegate {
    func didSendSubMessage(MessageDetailsVC: MessageDetailsViewController, subMessage: SubMessage, message: Message) {
        guard let index = self.messages.index(of: message) else {
            return
        }
        self.messages[index].subMessages.append(subMessage)
    }
}

extension GSDViewController: MessageTableViewDelegate {
    func didSelectMessage(messageTableView: MessageTableView, message: Message) {
        let messageDetailsVC = MessageDetailsViewController()
        messageDetailsVC.delegate = self
        messageDetailsVC.message = message
        self.navigationController?.pushViewController(messageDetailsVC, animated: true)
    }
}
