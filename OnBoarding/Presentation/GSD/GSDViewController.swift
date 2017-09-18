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
    let gsdInfoView = BasicView(frame: .zero)
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBarButtons()
        setupGSDInfoView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.title = "Global Service Desk"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
    }
    
    //MARK- Setup
    func setupNaviBarButtons() {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Add")!, for: .normal)
        button.addTarget(self, action: #selector(createMsg), for: .touchUpInside)
        let createMsgBtn = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = createMsgBtn
    }
    
    func setupGSDInfoView() {
        gsdInfoView.data = (title: "Tel: 0049 283213 12", icon:UIImage(named:"GSD"), action: nil)
        gsdInfoView.backgroundColor = UIColor.bgColor
    }
    
    //MARK:- Selectors
    @objc func createMsg() {
        let msgVC = MessageViewController()
        let msgNC = UINavigationController.init(rootViewController: msgVC)
        self.navigationController?.present(msgNC, animated: true, completion: nil)
    }
    
    //MARK:-Layout
    func layout() {
        let views: [String: UIView] = ["contact": gsdInfoView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        self.gsdInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.gsdInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.gsdInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
       
        
    }
}
