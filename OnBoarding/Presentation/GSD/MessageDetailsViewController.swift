//
//  MessageDetailsViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 25/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol MessageDetailsViewControllerDelegate: class {
    func didSendSubMessage(MessageDetailsVC: MessageDetailsViewController, subMessage: SubMessage, message: Message)
}

class MessageDetailsViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    let triggerView = TriggerView(frame: .zero)
    
    var message: Message? {
        didSet {
            messageView.data = (subject: message?.title, body: message?.body)
            self.presentSubMessageViews()
        }
    }
    
    weak var delegate: MessageDetailsViewControllerDelegate?
            
    //MARK:- Init
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        let respondBtn = UIBarButtonItem.init(title: "Answer", style: .done, target: self, action: #selector(answerBtnTapped))
        self.navigationItem.rightBarButtonItem = respondBtn
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
            subMessageView.topAnchor.constraint(equalTo: upperView.bottomAnchor, constant: 10).isActive = true
            subMessageView.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: subMessageView.height! + 10).isActive = true
            upperView = subMessageView
        }
    }
    
    //MARK:- SetupViews
    func setupMessageView() {
        messageView.titleTxtF.isEnabled = false
        messageView.messageTxtV.isEditable = false
        messageView.type = .main
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
            self?.message?.subMessages = subMessages!
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
    
    //MARK:- Selector
    @objc func answerBtnTapped() {
        let msgVC = MessageViewController.init(type: .sub, mainMessage: message)
        msgVC.subMessageDelegate = self
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
}
extension MessageDetailsViewController:  SubMessageViewControllerDelegate {
    func didSendSubMessage(messageVC: MessageViewController, subMessage: SubMessage, message: Message) {
        self.message?.subMessages.append(subMessage)
        presentSubMessageViews()
        delegate?.didSendSubMessage(MessageDetailsVC: self, subMessage: subMessage, message: message)
    }
}
