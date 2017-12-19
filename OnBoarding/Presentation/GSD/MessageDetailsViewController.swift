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
        setupNavBarButtons()
        setupTriggerView()
        setupMessageView()
        layout()
        fetchSubMessages()
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
            subMessageView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 10).isActive = true
            subMessageView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: subMessageView.height! + 10).isActive = true
            upperView = subMessageView
        }
    }
    
    //MARK:- SetupViews
    func setupNavBarButtons() {
        let respondBtn = UIBarButtonItem.init(title: "Answer", style: .done, target: self, action: #selector(answerBtnTapped))
        self.navigationItem.rightBarButtonItem = respondBtn
    }
    func setupMessageView() {
        messageView.titleTxtF.isEnabled = false
        messageView.messageTxtV.isEditable = false
        messageView.type = .main
    }
    
    func setupTriggerView() {
        triggerView.data = (title:"No answers are available", icon: UIImage.init(named:"NoMails"), action: { [weak self] in
            self?.fetchSubMessages()
        })
    }
    
    //MARK:-
    func fetchSubMessages() {
        guard let messageID = message?.identifier else {
            return
        }
        
        triggerView.status = .loading
        MessageManager.fetchSubMessages(messageID: messageID, completion: {[weak self] subMessages  in
            self?.triggerView.status = .idle

            guard subMessages != nil else {
                return
            }
            self?.message?.subMessages = subMessages!
            self?.reloadMessageView()
        })
    }
    
    //MARK:- SubMessages
    func reloadMessageView() {
        let subMessageViews = setupSubMessageViews()
        guard subMessageViews.count > 0 else {
            return
        }
        if triggerView.superview != nil {
            triggerView.removeFromSuperview()
        }
        layout(subMessagesViews: subMessageViews)
    }
    
    func setupSubMessageViews () -> [SubMessageView] {
        var subMessageViews: [SubMessageView] = []

        guard let subMsgs = message?.subMessages else {
            return subMessageViews
        }
        for submessage in subMsgs.reversed() {
            let subMessageView = SubMessageView(frame: .zero)
            subMessageView.data = (body: submessage.body, isOwner: submessage.owner)
            subMessageViews.append(subMessageView)
        }
        return subMessageViews
    }

    //MARK:- Selector
    @objc func answerBtnTapped() {
        let msgVC = MessageViewController.init(type: .sub, mainMessage: message)
        msgVC.subMessageSentCompetion = { [weak self] subMessage in
            self?.message?.subMessages.append(subMessage)
            self?.reloadMessageView()
        }
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
}

