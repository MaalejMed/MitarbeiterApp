//
//  MessageDetailsViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 25/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class MessageDetailsViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    let triggerView = TriggerView(frame: .zero)
    
    var message: Message? {
        didSet {
            messageView.data = (subject: message?.title, body: message?.body)
        }
    }
    
    //MARK:- Init
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setupSubMessagesDataSource()
        setupTriggerView()
        setupMessageView()
        layout()
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["messageView": messageView, "trigger":triggerView]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        messageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: messageView.height!).isActive = true
        triggerView.topAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        triggerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func layout(subMessagesViews: [SubMessageView]) {
        var upperView: UIView = messageView
        for  subMessageView in subMessagesViews {
            subMessageView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(subMessageView)
            subMessageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            subMessageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            subMessageView.topAnchor.constraint(equalTo: upperView.bottomAnchor).isActive = true
            subMessageView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: subMessageView.height!).isActive = true
            upperView = subMessageView
        }
    }
    
    //MARK:- SetupViews
    func setupMessageView() {
        messageView.titleTxtF.isEnabled = false
        messageView.messageTxtV.isEditable = false
    }
    
    func setupTriggerView() {
        triggerView.data = (title:"No answers are available", icon: UIImage.init(named:"NoMails"), action: { [weak self] in
            self?.setupSubMessagesDataSource()
        })
    }
    
    func setupSubMessageViews () -> [SubMessageView]? {
        var subMessageViews: [SubMessageView] = []
        for submessage in (message?.subMessages)! {
            let subMessageView = SubMessageView(frame: .zero)
            subMessageView.data = (body: submessage.body, isOwner: submessage.owner)
            
            subMessageViews.append(subMessageView)
        }
        return subMessageViews
    }
    
    //MARK:-
    func setupSubMessagesDataSource() {
        triggerView.status = .loading
        DataManager.sharedInstance.updateSubMessages(messageID: (message?.identifier!)!, completion: {[weak self] subMessages, serverResponse in
            guard serverResponse == nil else {
                self?.triggerView.status = .idle
                return
            }
            self?.message?.subMessages = subMessages
            self?.presentSubMessageViews()
        })
    }
    
    //MARK:- SubMessages
    func presentSubMessageViews() {
        if triggerView.superview != nil {
            triggerView.removeFromSuperview()
        }
        
        let subMessageViews = setupSubMessageViews()
        guard subMessageViews?.count != 0 else {
            return
        }
        layout(subMessagesViews: subMessageViews!)
    }
}
