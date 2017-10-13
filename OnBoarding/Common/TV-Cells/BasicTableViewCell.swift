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
    static var staticMetrics: CellMetrics = CellMetrics(topAnchor: 8.0, leftAnchor: 10.0, bottomAnchor: 5.0, rightAnchor: 10.0)
    var cellView: CellViewProtocol = BasicCellContentView()
    static let height: CGFloat = BasicCellContentView.dummy.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + staticMetrics.topAnchor + staticMetrics.bottomAnchor
    
    var data: (title: String?,details: String?, icon: UIImage?)? {
        didSet {
            (cellView as! BasicCellContentView).data = (title: data?.title, details:data?.details, icon: data?.icon)
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styling()
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
    
    //MARK:- Style
    func styling() {
        self.backgroundColor = UIColor.BgColor
        self.cellView.view.backgroundColor = UIColor.elementBgColor
        self.selectionStyle = .none
    }
}

class BasicCellContentView: UIView, CellViewProtocol {
    
    //MARK:- Properties
    static var dummy: CellViewProtocol = {
        let view = BasicCellContentView()
        view.data = (title: "title", details: "details", icon: UIImage.init(named: "Logo"))
        return view
    }()
    
    var data: (title: String?, details: String?, icon: UIImage?)? {
        didSet {
            titleLbl.text = data?.title
            iconImgV.image = data?.icon
            detailsLbl.text = data?.details
            layout()
        }
    }
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let iconImgV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let detailsLbl: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    //MARK:- Layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
    }
    
    //MARK:- Inits
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        var views: [String: UIView] = ["title": titleLbl, "details": detailsLbl]
        var layoutConstraints: [NSLayoutConstraint] = []

        if  data?.icon != nil {
            views["icon"] = iconImgV
        }
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        if data?.icon != nil {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[icon(25)]-(10)-|", options: [], metrics: nil, views: views)
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[icon(25)]-(10)-[title]", options: [], metrics: nil, views: views)
        } else {
            layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[title]", options: [], metrics: nil, views: views)
        }
        
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[title]-(10)-[details]-(10)-|", options: [], metrics: nil, views: views)
        
         layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[title]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[details]-(10)-|", options: [], metrics: nil, views: views)
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
