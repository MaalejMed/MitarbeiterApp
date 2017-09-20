//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

let menuItems: [(String, UIImage)] = [
    ("Time recording", UIImage.init(named: "Time")!),
    ("Travel Expenses", UIImage.init(named: "Expenses")!),
    ("Benefits", UIImage.init(named: "Benefits")!),
    ("E-Learning", UIImage.init(named: "Elearning")!),
    ("GSD", UIImage.init(named: "Help")!),
    ("Profile", UIImage.init(named: "Profile")!),
]

class HomeViewController: UIViewController {
    
    //Properties
    let profileView = InfoView(frame: .zero)
    let mainMenuView = MainMenuView(frame: .zero)
    let newsTableView = NewsTableView(frame: .zero)
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
        self.navigationController?.navigationBar.topItem?.title = "Welcome on Board"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
        self.navigationItem.setHidesBackButton(true, animated:false);
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
    
    //MARK: Layout MainMenu animation
    func updateMainMenuViewPosition(newPosition: Position) {
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
    
    func didMoveMainMenu(direction: Direction, currentPosition: Position) {
        switch currentPosition {
        case .idle:
            guard direction == .top else {
                return
            }
            mainMenuView.currentPostion = .middle
            updateMainMenuViewPosition(newPosition: .middle)
        case .middle:
            switch direction {
            case .top:
                mainMenuView.currentPostion = .top
                updateMainMenuViewPosition(newPosition: .top)
            case .bottom:
                mainMenuView.currentPostion = .idle
                updateMainMenuViewPosition(newPosition: .idle)
            }
        case .top:
            guard direction == .bottom  else {
                return
            }
            mainMenuView.currentPostion = .middle
            updateMainMenuViewPosition(newPosition: .middle)
        }
    }
    
    //MARK:- Views
    func setupProfileView() {
        profileView.data = (title: "Mohamed Maalej (645438)", icon: UIImage.init(named: "Logo")!, action: nil)
        profileView.backgroundColor = UIColor.bgColor
    }
    func setupMainMenuView() {
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

extension HomeViewController: NewsTableViewDelegate {
    func didScrollNewsTableView() {
        didMoveMainMenu(direction: .bottom, currentPosition: mainMenuView.currentPostion)
    }
}

extension HomeViewController: MainMenuViewDelegate {
    func didMoveMainMenu(mainMenuView: MainMenuView, direction: Direction, currentPosition: Position) {
        didMoveMainMenu(direction: direction, currentPosition: currentPosition)
    }
}
