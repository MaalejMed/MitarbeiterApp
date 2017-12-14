//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, Observer {
    
    //Properties
    var identifier = 01

    let profileView = InfoView(frame: .zero)
    let mainMenuView = MainMenuView(frame: .zero)
    let feedTableView = FeedTableView(frame: .zero)
    let triggerView = TriggerView(frame:.zero)
    
    var menuItems: [MenuItem] = []
    
    var mainMenuViewTopAnchor: NSLayoutConstraint?
    var layoutConstraints: [NSLayoutConstraint] = []
    
    var feedSubject: FeedManager?
    var timeSubject: TimeManager?
    
    //MARK:- Inits
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        FeedManager.register(observer: self)
        TimeManager.register(observer: self)
        AssociateManager.register(observer: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainMenuView()
        setupFeedTableView()
        setupTriggerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
        self.navigationItem.setHidesBackButton(true, animated:false)
        setupProfileView()
    }
    
    //MARK:- Layout
    func layout(contentView: UIView) {
        resetLayout()
        
        let views: [String: UIView] = ["profile": profileView, "menu": mainMenuView, "content": contentView]
        for (_, view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            layoutConstraints += [
                view.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                view.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ]
        }
        
        layoutConstraints += [
            profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            contentView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            mainMenuView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        
        layoutConstraints.append(mainMenuViewTopAnchor!)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func resetLayout() {
        self.view.removeConstraints(layoutConstraints)
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        layoutConstraints.removeAll()
    }
    
    func updateMenuViewLayout(newPosition: Position) {
        self.view.removeConstraint(mainMenuViewTopAnchor!)
        switch newPosition {
        case .idle:
            mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        case .middle:
            mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(self.view.frame.height / 2) )
        case .top:
            mainMenuViewTopAnchor = mainMenuView.topAnchor.constraint(equalTo: profileView.bottomAnchor)
        }
        mainMenuViewTopAnchor?.isActive = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- MainMenu animation
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
    
    //MARK:- Setup views
    func setupProfileView() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        profileView.data = (title: associate.name , icon: associate.image, action: nil)
        profileView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
    }
    
    func setupMainMenuView() {
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
        triggerView.data = (title:"No Feed available", icon: UIImage.init(named:"NoMails"), action: {
            self.triggerView.status = .loading
            FeedManager.fetch()
        })
        self.triggerView.status = .loading
        self.presentTriggerView()
    }
    
    //MARK:- Update view appearance
    func reloadMainMenu() {
        mainMenuView.menuCV.reloadData()
    }
    
    func presentContentView() {
        guard DataManager.sharedInstance.feeds.count > 0 else {
            self.triggerView.status = .idle
            self.presentTriggerView()
            return
        }
        self.feedTableView.dataSource = DataManager.sharedInstance.feeds
        self.presentNewsTableView()
    }
    
    func presentNewsTableView() {
        layout(contentView: feedTableView)
    }
    
    func presentTriggerView() {
        layout(contentView: triggerView)
    }
    
    func reloadProfileView() {
        guard let associate = DataManager.sharedInstance.associate else {
            return
        }
        profileView.backgroundColor = UIColor(patternImage: UIImage(named: "Background.png")!)
        profileView.data = (title: associate.name , icon: associate.image, action: nil)

    }
    
    //MARK:- Observer
    func update<T>(subject: T.Type) {
        switch subject {
        case is FeedManager.Type:
            presentContentView()
        case is TimeManager.Type:
            reloadMainMenu()
        case is AssociateManager.Type:
            reloadProfileView()
        default:
            return
        }
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
        mainMenuView.currentPostion = .idle
        updateMenuViewLayout(newPosition: .idle)
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
