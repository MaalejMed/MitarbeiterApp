//
//  MessageViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum MessageType {
    case main
    case sub
}

protocol MessageViewControllerDelegate: class {
    func didSendMessage(messageVC: MessageViewController?, message: Message)
}

protocol SubMessageViewControllerDelegate: class {
    func didSendSubMessage(messageVC: MessageViewController, subMessage: SubMessage, message: Message)
}
class MessageViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    let sendBtn = TriggerButton(frame: .zero)
    let serverResponseView = ServerResponseView(frame: .zero)
    
    var messageType: MessageType
    var mainMessage: Message?
    
    weak var messageDelegate: MessageViewControllerDelegate?
    weak var subMessageDelegate: SubMessageViewControllerDelegate?
    
    //MARK:- Init
    init(type: MessageType, mainMessage: Message?) {
        self.messageType = type
        self.mainMessage = mainMessage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupSendButton()
        setupMessageView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "New message"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        self.view.backgroundColor = UIColor.BgColor
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
    func setupNaviBarButtons() {
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
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        sendBtn.status = .loading
        guard messageView.titleTxtF.text != nil, messageView.messageTxtV.text != nil else {
            return
        }
        let _ = messageType == . main ? sendMessage(associate: associate) : sendSubMessage(message: mainMessage!)
    }
    
    //MARK:- Message
    func sendMessage(associate: Associate) {
        let message = Message(identifier: String.random(), associateID: associate.identifier, title: messageView.titleTxtF.text!, body: messageView.messageTxtV.text, subMessages: [], date: Date())
        
        let messageManager = MessageManager()
        messageManager.insert(message: message, completion: {[weak self] serverResponse in
            guard serverResponse?.code == .success else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                self?.sendBtn.status = .idle
                return
            }
            self?.serverResponseView.present(serverResponse: serverResponse!)
            self?.messageDelegate?.didSendMessage(messageVC: self, message: message)
            self?.dismissVC()
        })
    }
    
    //MARK:-
    func sendSubMessage(message: Message) {
        guard let msgID = message.identifier, let body = messageView.messageTxtV.text else {
            return
        }
        let subMessage = SubMessage.init(identifier: String.random(), body: body, messageID: msgID, date: Date(), owner: true)
        
        let messageManager = MessageManager()
        messageManager.insert(subMessage: subMessage, completion: { [weak self] serverResponse in
            guard serverResponse?.code == .success else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                self?.sendBtn.status = .idle
                return
            }
            self?.serverResponseView.present(serverResponse: serverResponse!)
            self?.subMessageDelegate?.didSendSubMessage(messageVC: self!, subMessage: subMessage, message: message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
                self?.dismissVC()
            })
        })
    }
}
