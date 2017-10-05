//
//  MessageViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 18/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol MessageViewControllerDelegate: class {
    func didSendMessage(messageVC: MessageViewController, message: Message)
}
class MessageViewController: UIViewController {
    
    //MARK:- Properties
    let messageView = MessageView(frame: .zero)
    let sendBtn = TriggerButton(frame: .zero)
    
    weak var delegate: MessageViewControllerDelegate?
        
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupSendButton()
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
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[message]-(10)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(70)-[send]-(70)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            messageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
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
    
    //MARK:- Selectors
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonTapped() {
        sendBtn.status = .loading
        guard messageView.titleTxtF.text != nil, messageView.messageTxtV.text != nil else {
            return
        }
        let message = Message(identifier: "01", associateID: "645438", title: messageView.titleTxtF.text, body: messageView.messageTxtV.text, response: nil, date: Date())
        delegate?.didSendMessage(messageVC: self, message: message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
            self?.dismissVC()
        })
    }
}
