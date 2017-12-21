//
//  MessageViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum MessageType {
    case mainMessage
    case subMessage
}

class MessageViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    let sendBtn = TriggerButton(frame: .zero)
    let serverResponseView = ServerResponseView(frame: .zero)
    
    var messageType: MessageType
    var message: Message?
    
    var messageSentCompletion:(()->())?
    var subMessageSentCompetion: ((SubMessage)->())?
    
    //MARK:- Init
    init(type: MessageType, message: Message?) {
        self.messageType = type
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSendButton()
        setupMessageView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        self.view.backgroundColor = UIColor.BgColor
        self.title = messageType == .mainMessage ? "New message" : self.message?.title
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["message": messageView, "send": sendBtn]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[message]-(0)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(70)-[send]-(70)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            messageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[message]-(10)-[send]", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    //MARK:- Setup views
    func setupNavBar() {
        //buttons
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named:"Close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let dismissBtn = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = dismissBtn
    }
    
    func setupSendButton() {
        sendBtn.status = .idle
        self.sendBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    func setupMessageView() {
        messageView.type = messageType
    }
    
    //MARK:- Selectors
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonTapped() {
        let _ = messageType == .mainMessage ? sendMessage() : sendSubMessage()
    }
    
    //MARK:- Message
    func sendMessage() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        
        guard let subject = messageView.titleTxtF.text else {
            return
        }
        
        guard let body = messageView.messageTxtV.text, body != "Message" else {
            return
        }
        
        sendBtn.status = .loading
        let message = Message(identifier: String.random(), associateID: associate.identifier!, title: subject.trimmingCharacters(in: .whitespaces), body: body.trimmingCharacters(in: .whitespaces) , subMessages: [], date: Date())
        
        MessageManager.send(message: message, completion: {[weak self] serverResponse in
            guard serverResponse?.status == .success else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                self?.sendBtn.status = .idle
                return
            }
            self?.serverResponseView.present(serverResponse: serverResponse!)
            if self?.messageSentCompletion != nil {
                self?.messageSentCompletion!()
            }
            self?.dismissVC()
        })
    }
    
    //MARK:-
    func sendSubMessage() {
        guard let msgID = self.message?.identifier else {
            return
        }
        
        guard let body = messageView.messageTxtV.text else {
            return
        }
        
        let subMessage = SubMessage.init(identifier: String.random(), body: body, messageID: msgID, date: Date(), owner: true)
        
        MessageManager.send(subMessage: subMessage, completion: { [weak self] serverResponse in
            guard serverResponse?.status == .success else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                self?.sendBtn.status = .idle
                return
            }
            self?.serverResponseView.present(serverResponse: serverResponse!)
            
            guard let completion = self?.subMessageSentCompetion else {
                return
            }
            completion(subMessage)
            self?.dismissVC()
        })
    }
}
