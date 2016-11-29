//
//  GankNavigationController.swift
//  Gank
//
//  Created by Blake on 11/24/16.
//  Copyright © 2016 Travis. All rights reserved.
//

import UIKit

class GankNavigationController: UINavigationController {
    
    private let statusBarView: UIView = {
        let barView = UIView()
        barView.backgroundColor = STATUS_BAR_COLOR
        return barView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20)
        view.addSubview(statusBarView)
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        UINavigationBar.appearance().barTintColor = NAVIGATION_BAR_COLOR

        UINavigationBar.appearance().translucent = false
        
        //get rid of the black line (the background that system draw automatically)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
