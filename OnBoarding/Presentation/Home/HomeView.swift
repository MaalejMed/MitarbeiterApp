//
//  HomeView.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    //Properties
    let welcomeLbl: UILabel = {
        let label = UILabel()
        label.text = "These operations help you completing you day to day operations"
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var menuCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:HomeCollectionViewCell.height, height: HomeCollectionViewCell.height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        menuCV.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.cellIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["info": welcomeLbl, "menu": menuCV]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[info]-(20)-|", options:[] , metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[menu]-(20)-|", options:[] , metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[info]-(20)-[menu]-(0)-|", options:[] , metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

extension HomeView: UICollectionViewDelegate {
    
}

extension HomeView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionItem.allValues.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.cellIdentifier, for: indexPath) as! HomeCollectionViewCell
        let item = CollectionItem.allValues[indexPath.row]
        let icon = item.icon()
        cell.data = (title: item.rawValue, icon:icon)
        return cell
    }
}
