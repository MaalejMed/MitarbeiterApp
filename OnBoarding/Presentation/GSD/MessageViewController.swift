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
    let contextView = ContextView(context: .send)
    
    weak var delegate: MessageViewControllerDelegate?
        
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupTimerView()
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
        let views: [String: UIView] = ["message": messageView, "context": contextView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[message]-(10)-|", options: [], metrics: nil, views: views)
          layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[context]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            messageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ]
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[message]-(10)-[context]", options: [], metrics: nil, views: views)
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
    
    func setupTimerView() {
        contextView.contextBtnAction = { [weak self] in
            guard self?.messageView.titleTxtF.text != nil, self?.messageView.messageTxtV.text != nil else {
                return
            }
            self?.contextView.contextBtn.context = .idle
            let message = Message(identifier: "01", associateID: "645438", title: self?.messageView.titleTxtF.text, body: self?.messageView.messageTxtV.text, response: nil, date: Date())
            self?.delegate?.didSendMessage(messageVC: (self)!, message: message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self?.dismissVC()
            })
        }
    }
    
    //MARK:- Selectors
    @objc func dismissVC() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
