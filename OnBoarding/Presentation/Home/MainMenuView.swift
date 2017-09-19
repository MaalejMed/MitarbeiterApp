//
//  HomeView.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol MainMenuViewDelegate: class {
    func didMoveMainMenu(direction: Direction, currentPosition: Position)
}

enum Position {
    case idle
    case middle
    case top
}

enum Direction {
    case top
    case bottom
}

class MainMenuView: UIView {
    
    //Properties
    let lineImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    lazy var menuCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.bgColor
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    var currentPostion: Position = .idle
    
    var items: [(String, UIImage)]? {
        didSet {
            menuCV.reloadData()
        }
    }
    
    weak var delegate: MainMenuViewDelegate?
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupGestureRecognizer()
        self.backgroundColor = UIColor.bgColor
        menuCV.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.cellIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["line": lineImgV, "menu": menuCV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[line(50)]", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[line(3)]", options: [], metrics: nil, views: views)

        layoutConstraints += [
            lineImgV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            menuCV.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            menuCV.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            menuCV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menuCV.topAnchor.constraint(equalTo: lineImgV.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

        
//        menuCV.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
//        menuCV.topAnchor.constraint(equalTo: lineImgV.bottomAnchor, constant: 10).isActive = true
//        menuCV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        menuCV.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
     }
    
    //MARK:- Selectors
    @objc func respondToGesture(gesture: UIPanGestureRecognizer){
        guard gesture.state == .began else {
            return
        }
        let velocity: CGPoint = gesture.velocity(in: self)
        
        if (velocity.y < 0) {
            delegate?.didMoveMainMenu(direction: .top, currentPosition: currentPostion)
        } else if velocity.y > 0 {
            delegate?.didMoveMainMenu(direction: .bottom, currentPosition: currentPostion)
        } else {
            return
        }
    }
    
    //MARK:- Others
    func setupGestureRecognizer() {
        let panGR = UIPanGestureRecognizer(target: self, action:#selector(respondToGesture))
        self.addGestureRecognizer(panGR)
    }
}

extension MainMenuView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.size.width - homeCollectionViewCellPadding - 40) / 3, height: HomeCollectionViewCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return homeCollectionViewCellPadding
    }
}

extension MainMenuView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = items?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.cellIdentifier, for: indexPath) as! HomeCollectionViewCell
        let item = items?[indexPath.row]
        cell.data = (title: item?.0, icon:item?.1)
        return cell
    }
}
