//
//  BasicTableViewCell.swift
//  OnBoarding
//
//  Created by mmaalej on 15/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class BasicTableViewCell: UITableViewCell, TableViewCellProtocols {

    //MARK:- Properties
    static var staticMetrics: CellMetrics = CellMetrics(topAnchor: 8.0, leftAnchor: 8.0, bottomAnchor: 8.0, rightAnchor: 8.0)
    var cellView: CellViewProtocol = CellContentView()
    static let height: CGFloat = CellContentView.dummy.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + staticMetrics.topAnchor + staticMetrics.bottomAnchor
    var data: (title: String?, icon: UIImage?) {
        didSet {
            (cellView as! CellContentView).data = (title: data.title, icon: data.icon)
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        cellView.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellView.view)
        cellView.view.topAnchor.constraint(equalTo:self.topAnchor, constant: metrics.topAnchor).isActive = true
        cellView.view.leftAnchor.constraint(equalTo:self.leftAnchor, constant: metrics.leftAnchor).isActive = true
        cellView.view.rightAnchor.constraint(equalTo:self.rightAnchor, constant: -metrics.rightAnchor).isActive = true
        cellView.view.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -metrics.rightAnchor).isActive = true
    }
}

class CellContentView: UIView, CellViewProtocol {
    
    //MARK:- Properties
    static var dummy: CellViewProtocol = {
        let view = CellContentView()
        view.data = (title: "title", icon: UIImage.init(named: "Logo"))
        return view
    }()
    
    var data: (title: String?, icon: UIImage?)? {
        didSet {
            titleLbl.text = data?.title
            iconImgV.image = data?.icon
        }
    }
    
    let titleLbl: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let iconImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK:- Layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    //MARK:- Inits
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["title": titleLbl, "icon": iconImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[icon(40)]-(10)-[title]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[icon(40)]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstraints += [
            titleLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
