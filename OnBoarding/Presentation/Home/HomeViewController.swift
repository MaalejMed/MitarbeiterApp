//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Properties
    let profileView = InfoView(frame: .zero)
    let mainMenuView = MainMenuView(frame: .zero)
    let feedTableView = FeedTableView(frame: .zero)
    let triggerView = TriggerView(frame:.zero)
    
    var feeds: [Feed] = []
    var mainMenuViewTopAnchor: NSLayoutConstraint?
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        setupMainMenuView()
        setupFeedTableView()
        setupTriggerView()
        fetchFeeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
        self.navigationItem.setHidesBackButton(true, animated:false);
    }
    
    //MARK:- Layout
    func layout(contentView: UIView) {
        let views: [String: UIView] = ["profile": profileView, "menu": mainMenuView, "content": contentView]
        for (_, view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        contentView.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        mainMenuView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        mainMenuViewTopAnchor?.isActive = true
    }
    
    //MARK: Layout MainMenu
    func updateMenuViewLayout(newPosition: Position) {
        self.view.removeConstraint(mainMenuViewTopAnchor!)
        switch newPosition {
        case .idle:
           mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        case .middle:
            mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.centerYAnchor)
        case .top:
            mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: profileView.bottomAnchor)
        }
        mainMenuViewTopAnchor?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func moveMenuFrom(currentPosition: Position, direction: Direction) {
        switch currentPosition {
        case .idle:
            guard direction == .top else {
                return
            }
            mainMenuView.currentPostion = .middle
            updateMenuViewLayout(newPosition: .middle)
        case .middle:
            switch direction {
            case .top:
                mainMenuView.currentPostion = .top
                updateMenuViewLayout(newPosition: .top)
            case .bottom:
                mainMenuView.currentPostion = .idle
                updateMenuViewLayout(newPosition: .idle)
            }
        case .top:
            guard direction == .bottom  else {
                return
            }
            mainMenuView.currentPostion = .middle
            updateMenuViewLayout(newPosition: .middle)
        }
    }
    
    //MARK:- Views
    func setupProfileView() {
        profileView.data = (title: "Mohamed Maalej", icon: nil, action: nil)
        profileView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
    }
    
    func setupMainMenuView() {
        var menuItems: [MenuItem] = []
        for item in Item.allMenuItems {
            let menuItem = MenuItem(item: item)
            menuItems.append(menuItem)
        }
        mainMenuView.items = menuItems
        mainMenuView.delegate = self
    }
    
    func setupFeedTableView() {
        feedTableView.delgate = self
    }
    
    func setupTriggerView() {
        triggerView.data = (title:"No Feed available", icon: UIImage.init(named:"NoMails"), action: { [weak self] in
            self?.fetchFeeds()
        })
    }
    
    func presentNewsTableView() {
        if triggerView.superview != nil {
            triggerView.removeFromSuperview()
        }
        layout(contentView: feedTableView)
    }
    
    func presentTriggerView() {
        if feedTableView.superview != nil {
            feedTableView.removeFromSuperview()
        }
        triggerView.status = .loading
        layout(contentView: triggerView)
    }
    
    //MARK:- Feeds
    func fetchFeeds () {
        presentTriggerView()
        let feedManager = FeedManager()
        feedManager.fetchFeed(completion: { [weak self] failure, feed in
            guard failure == nil, let feedEntries = feed  else {
                self?.triggerView.status = .idle
                return
            }
            self?.feeds = feedEntries
            self?.feedTableView.dataSource = self?.feeds
            self?.presentNewsTableView()
        })
    }
}

extension HomeViewController: FeedTableViewDelegate {
    func didScrollFeedTableView(feedTableView: FeedTableView) {
        moveMenuFrom(currentPosition: mainMenuView.currentPostion, direction: .bottom)
    }
    
    func didSelectFeed(feedTableView: FeedTableView, feed: Feed) {
        moveMenuFrom(currentPosition: mainMenuView.currentPostion, direction: .bottom)
    }
}

extension HomeViewController: MainMenuViewDelegate {
    func didPullMainMenu(mainMenuView: MainMenuView, direction: Direction, currentPosition: Position) {
        moveMenuFrom(currentPosition: currentPosition, direction: direction)
    }
    
    func didSelect(mainMenuView: MainMenuView, menuItem: MenuItem) {
        switch menuItem.item {
        case .time:
            let timeVC = TimesheetViewController()
            self.navigationController?.pushViewController(timeVC, animated: true)
        case .travelExp:
            break
        case .benefits:
            break
        case .eLearning:
            break
        case .gsd:
            let gsdVC = GSDViewController()
            self.navigationController?.pushViewController(gsdVC, animated: true)
        case .profile:
            let profileVC = ProfileViewController()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
