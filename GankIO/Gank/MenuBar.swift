//
//  MenuBar.swift
//  Gank
//
//  Created by Blake on 11/24/16.
//  Copyright © 2016 Travis. All rights reserved.
//  顶部TabBar

import UIKit

enum itemType: Int {
    case Android = 0
    case iOS = 1
    case WebFrontEnd = 2
}

protocol MenuBarDelegate: NSObjectProtocol {
    func menuBar(munubar: MenuBar, didSelectedItem item: itemType)
}

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let menuBarCellID: String = "MenuBarCell"
    
    let color = [UIColor.redColor(), UIColor.yellowColor(), UIColor.blueColor()]
    
    let names: [String] = ["Android", "iOS", "前端"]
    
    var menuDelegate: MenuBarDelegate?
    
    var selectedItem: itemType?
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.translatesAutoresizingMaskIntoConstraints = false
       collectionView.delegate = self
       collectionView.dataSource = self
       return collectionView
    }()
    
    func selectFirstItemFromStart() {
        let selectIndex = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.selectItemAtIndexPath(selectIndex, animated: false, scrollPosition: .None)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: ["collectionView": collectionView]))
        
        collectionView.registerClass(MenuBarItem.self, forCellWithReuseIdentifier: menuBarCellID)
        
        selectFirstItemFromStart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuBar {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(menuBarCellID, forIndexPath: indexPath) as? MenuBarItem
        cell?.name = names[indexPath.item] ?? ""
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let delegate = menuDelegate {
            selectedItem = itemType(rawValue: indexPath.item)
            delegate.menuBar(self, didSelectedItem: itemType(rawValue: indexPath.item)!)
        }
    }
}

class MenuBarItem: UICollectionViewCell {
    
    var name: String? {
        didSet {
            if let _name =  name {
                 nameLabel.text = _name
            }
        }
    }
    
    private let nameLabel: UILabel = {
       let nameLabel = UILabel()
        nameLabel.textAlignment = .Center
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let indicator: UIImageView = {
        let indicator = UIImageView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 146/255, alpha: 1.0)
        indicator.hidden = true
        return indicator
    }()
    
    override var highlighted: Bool {
        didSet{
            
        }
    }
    
    override var selected: Bool {
        didSet{
            indicator.hidden = !selected
        }
    }
    
    private func setupLabel() {
        addSubview(nameLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[nameLabel]-5-|", options: [], metrics: nil, views: ["nameLabel" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[nameLabel]-5-|", options: [], metrics: nil, views: ["nameLabel" : nameLabel]))
    }
    
    private func setupIndicator() {
        addSubview(indicator)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[indicator]|", options: [], metrics: nil, views: ["indicator" : indicator]))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .Top, relatedBy: .Equal, toItem: nameLabel, attribute: .Bottom, multiplier: 1.0, constant: 2))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        setupIndicator()
        backgroundColor = MENU_BAR_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
