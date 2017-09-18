//
//  CollectionView.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class HomeCollectionView: UIView {
    
    //Properties
    let cellPadding: CGFloat = 30.0

    var items: [(String, UIImage)] {
        didSet {
            menuCV.reloadData()
        }
    }
    
    lazy var menuCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    //Init
    init(items: [(String, UIImage)], bgColor: UIColor) {
        self.items = items
        super.init(frame: .zero)
        self.menuCV.backgroundColor = bgColor
        layout()
        menuCV.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        menuCV.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(menuCV)
        menuCV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        menuCV.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        menuCV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        menuCV.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}

extension HomeCollectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.frame.size.width - cellPadding) / 2, height: HomeCollectionViewCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }
}

extension HomeCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.cellIdentifier, for: indexPath) as! HomeCollectionViewCell
        let item = items[indexPath.row]
        cell.data = (title: item.0, icon:item.1)
        return cell
    }
}

