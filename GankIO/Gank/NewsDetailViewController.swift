//
//  NewsDetailViewController.swift
//  Gank
//
//  Created by Blake on 11/26/16.
//  Copyright © 2016 Travis. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    override var title: String? {
        didSet {
            if let _title = title {
                titleLabel.text = _title
            }
        }
    }
    
    var reuqestURL: NSURL? {
        didSet {
            if let url = reuqestURL {
                 request = NSURLRequest(URL: url)
            }
        }
    }
    
    var request: NSURLRequest? {
        get { return webView.request }
        set { webView.loadRequest(newValue!) }
    }
    
    let webView: UIWebView = {
       let webView = UIWebView()
       return webView
    }()
    
    override func loadView() {
        view = webView
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont(name: ".SF NS Dispaly", size: 20)
        return titleLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.frame = CGRect(x: 0, y: 0, width: 238, height: 28)
        navigationItem.titleView = titleLabel
    }
}
