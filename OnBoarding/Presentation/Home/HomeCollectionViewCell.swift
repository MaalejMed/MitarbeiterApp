//
//  HomeCollectionViewCell.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

let homeCollectionViewCellPadding: CGFloat = 10.0

class HomeCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocols {
    
    //Properties
    static var staticMetrics = CellMetrics(topAnchor: 5.0, leftAnchor: 5.0, bottomAnchor: 5.0, rightAnchor: 8.0)
    static let height = HomeCellView.dummy.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + staticMetrics.topAnchor + staticMetrics.bottomAnchor
    var cellView: CellViewProtocol = HomeCellView()
    var data: (title: String?, icon: UIImage?, notif: Int?)? {
        didSet {
            (self.cellView as! HomeCellView).data = (title: data?.title, icon: data?.icon, notif: data?.notif)
        }
    }
    
    //Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.itemBgColor
        self.layer.cornerRadius = 5.0
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-Layout
    func layout() {
        self.contentView.addSubview(cellView.view)
        cellView.view.translatesAutoresizingMaskIntoConstraints = false
        cellView.view.topAnchor.constraint(equalTo:self.topAnchor, constant: metrics.topAnchor).isActive = true
        cellView.view.leftAnchor.constraint(equalTo:self.leftAnchor, constant: metrics.leftAnchor).isActive = true
        cellView.view.rightAnchor.constraint(equalTo:self.rightAnchor, constant: -metrics.rightAnchor).isActive = true
        cellView.view.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -metrics.rightAnchor).isActive = true
    }
}

class HomeCellView: UIView, CellViewProtocol {
    
    //MARK:- Properties
    static var dummy: CellViewProtocol = {
        let cell = HomeCellView()
        cell.data = (title: "title", icon: UIImage.init(named: "Elearning"), notif: 0)
        return cell
    }()
    
    var data: (title: String?, icon: UIImage?, notif: Int?) {
        didSet {
            titleLbl.text = data.title
            iconImgV.image = data.icon
            guard let notification = data.notif else {
                return
            }
            notifLbl.text = " \(notification) "
        }
    }
    
    let notifLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        return label
    }()
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
    }()
    
    let iconImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["title": titleLbl, "icon": iconImgV, "notif": notifLbl]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[title]-(0)-|", options: [], metrics: nil, views: views)
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[icon]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[title]-(2)-[icon]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            notifLbl.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: HomeCollectionViewCell.staticMetrics.rightAnchor),
            notifLbl.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: (homeCollectionViewCellPadding + HomeCollectionViewCell.staticMetrics.rightAnchor) - 2),
            notifLbl.centerYAnchor.constraint(equalTo: self.topAnchor, constant: -HomeCollectionViewCell.staticMetrics.topAnchor )
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}

