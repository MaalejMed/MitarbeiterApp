//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Item: String {
    case time = "Time recording"
    case travelExp = "Travel expenses"
    case benefits = "benefits"
    case eLearning = "E-Learning"
    case gsd = "GSD"
    case profile = "Profile"
    
    static let allMenuItems = [time, travelExp, benefits, eLearning, gsd, profile]
    
    func icon() -> UIImage {
        switch self {
        case .time:
            return UIImage.init(named: "Time")!
        case .travelExp:
            return UIImage.init(named: "Expenses")!
        case .benefits:
            return UIImage.init(named: "Benefits")!
        case .eLearning:
            return UIImage.init(named: "Elearning")!
        case .gsd:
            return UIImage.init(named: "Help")!
        case .profile:
            return UIImage.init(named: "Profile")!
        }
    }
}

class HomeViewController: UIViewController {
    
    //Properties
    let profileView = InfoView(frame: .zero)
    let mainMenuView = MainMenuView(frame: .zero)
    let newsTableView = FeedTableView(frame: .zero)
    var feeds: [Feed] = [] {
        didSet {
            newsTableView.dataSource = feeds
        }
    }
    
    var mainMenuViewTopAnchor: NSLayoutConstraint?
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFeeds()
        setupProfileView()
        setupNewsTableView()
        setupMainMenuView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Home"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        self.navigationItem.setHidesBackButton(true, animated:false);
        if mainMenuView.currentPostion != .idle {
            updateMenuViewLayout(newPosition: .idle)
            mainMenuView.currentPostion = .idle
        }
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["profile": profileView, "menu": mainMenuView, "news": newsTableView]
        for (_, view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        newsTableView.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        newsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        let associate = Associate(identifier: "645438", name: "Mohamed Maalej", image: nil)
        profileView.data = (title: associate.name, icon: associate.profileImage(), action: nil)
        profileView.backgroundColor = UIColor.bgColor
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
    
    func setupNewsTableView() {
        newsTableView.delgate = self
    }
    
    //MARK:- Feeds
    func fetchFeeds () {
        guard let newFeeds = FeedService.updateFeeds() else {
            return
        }
        feeds = newFeeds
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
            let timeVC = TimeRecordingViewController()
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
