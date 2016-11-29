//
//  MainViewTextCell.swift
//  Gank
//
//  Created by Blake on 11/25/16.
//  Copyright © 2016 Travis. All rights reserved.
//  主视图只带文字的Cell

import UIKit

class MainViewTextCell: UITableViewCell {
    
    var gankNews: GankNews? {
        didSet {
            if let news = gankNews {
                titleLabel.text = news.desc ?? ""
                authorLabel.text = news.who ?? ""
                timeLabel.text = news.createdAt ?? ""

            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
