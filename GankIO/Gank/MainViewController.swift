//
//  ViewController.swift
//  Gank
//
//  Created by Blake on 11/24/16.
//  Copyright © 2016 Travis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MenuBarDelegate {
    
    private var isFirstTimeLoad: Bool = true
    
    struct Constant {
        static let imageCellReuseidentifier = "ImageCell"
        static let textCellReuseidentifier = "TextCell"
    }
    
    private var androidNews: [GankNews] = [] {
        didSet {
            reloadTableView()
        }
    }
    
    private var iOSNews: [GankNews] = [] {
        didSet {
            reloadTableView()
        }
    }
    
    private var webFrontEndNews: [GankNews] = [] {
        didSet {
            reloadTableView()
        }
    }
    
    private var androidPage: Int = 1
    private var iOSPage: Int = 1
    private var frontEndPage:Int = 1
    
    lazy private var menuBar: MenuBar = {
        let bar = MenuBar()
        bar.menuDelegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = UIColor.greenColor()
        return bar
    }()
    
    lazy private var tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
       return table
    }()
    
    private var header: MJRefreshNormalHeader = {
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.hidden = true
        header.setTitle("Pull down", forState: .Idle)
        header.setTitle("Release", forState: .Pulling)
        return header
    }()
    
    private var footer: MJRefreshAutoFooter = {
        let footer = MJRefreshAutoFooter()
        return footer
    }()
    
    //MARK: - Build UI
    func setupNavigation() {
        //Title Label
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 20, height: view.frame.height))
        titleLabel.text = "Gank.io"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(20)
        navigationItem.titleView = titleLabel
        
        let searchImage = UIImage(named: "ic_search_white")?.imageWithRenderingMode(.AlwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .Plain, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = searchBarButtonItem
    }
    
    func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[menuBar]-0-|", options: [], metrics: nil, views: ["menuBar": menuBar]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[menuBar(44)]", options: [], metrics: nil, views: ["menuBar": menuBar]))
    }
    
    func setupTable() {
        view.addSubview(tableView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView(width)]|", options: [], metrics: ["width": screenWidth], views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-44-[tableView(height)]|", options: [], metrics: ["height": screenHeight - 44 - 64], views: ["tableView": tableView]))
        tableView.separatorStyle = .None
    }
    
    func setupTableViewRefreshHeaderAndFooter() {
        tableView.mj_header = header
        header.setRefreshingTarget(self, refreshingAction: #selector(loadFreshData))
        tableView.mj_footer = footer
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadOldData))
    }
    
    func registeCell() {
        let textCellNib = UINib(nibName: "MainViewTextCell", bundle: nil)
        tableView.registerNib(textCellNib, forCellReuseIdentifier: "TextCell")
        
        let imageCellNib = UINib(nibName: "MainViewImageCell", bundle: nil)
        tableView.registerNib(imageCellNib, forCellReuseIdentifier: "ImageCell")
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupNavigation()
        setupMenuBar()
        setupTable()
        setupTableViewRefreshHeaderAndFooter()
        registeCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        getNewData()
        firstTimeLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Actions
    func firstTimeLoad() {
        if isFirstTimeLoad {
            menuBar.selectedItem = itemType(rawValue: 0)
        }
        isFirstTimeLoad = false
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func search() {
        print("perform search")
    }
    
    func getNewData() {
        getNewAndroidData()
        getNewIOSData()
        getNewWebFrontEndData()
    }
    
    func loadFreshData() {
        if let currentItem = menuBar.selectedItem {
            switch currentItem {
            case .Android:
                getNewAndroidData()
            case .iOS:
                getOldIOSData()
            case .WebFrontEnd:
                getNewWebFrontEndData()
            }
        }
    }
    
    func loadOldData() {
        if let currentItem = menuBar.selectedItem {
            switch currentItem {
            case .Android:
                getOldAndroidData()
            case .iOS:
                getOldIOSData()
            case .WebFrontEnd:
                getOldWebFrontEndData()
            }
        }
    }
    
    func getNewAndroidData() {
        let oldid = androidNews.first?._id
        
        NetworkManager.shareManager.fetchGankNewsWithNewType(.Android) { news in
            if news != nil {
                if oldid != news?.first?._id {
                    self.androidNews.insertContentsOf(news!, at: 0)
                    self.header.endRefreshing()
                }
            }
            self.header.endRefreshing()
        }
    }
    
    func getOldAndroidData() {
        androidPage += 1
        NetworkManager.shareManager.fetchGankNewsWithNewType(.Android, page: androidPage, news: { news in
            if news != nil {
               self.androidNews.appendContentsOf(news!)
               self.footer.endRefreshing()
            }
            self.footer.endRefreshing()
        })
    }
    
    func getNewIOSData() {
        let oldid = iOSNews.first?._id
        
        NetworkManager.shareManager.fetchGankNewsWithNewType(.iOS) { news in
            if news != nil {
                if oldid != news?.first?._id {
                    self.iOSNews.insertContentsOf(news!, at: 0)
                    self.header.endRefreshing()
                }
            }
            self.header.endRefreshing()
        }
    }
    
    func getOldIOSData() {
        iOSPage += 1
        NetworkManager.shareManager.fetchGankNewsWithNewType(.iOS, page: iOSPage, news: { news in
            if news != nil {
                self.iOSNews.appendContentsOf(news!)
                self.footer.endRefreshing()
            }
            self.footer.endRefreshing()
        })
    }
    
    func getNewWebFrontEndData() {
        let oldId = webFrontEndNews.first?._id
        NetworkManager.shareManager.fetchGankNewsWithNewType(.webFrontEnd, news: { news in
            if news != nil {
                if oldId != news?.first?._id {
                    self.webFrontEndNews.insertContentsOf(news!, at: 0)
                    self.header.endRefreshing()
                }
            }
            self.header.endRefreshing()
        })
    }
    
    func getOldWebFrontEndData() {
        NetworkManager.shareManager.fetchGankNewsWithNewType(.webFrontEnd, page: frontEndPage, news: { news in
            if news != nil {
                self.webFrontEndNews.appendContentsOf(news!)
                self.footer.endRefreshing()
            }
            self.footer.endRefreshing()
        })
    }
}

extension MainViewController {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = menuBar.selectedItem {
            switch type {
            case .Android:
                return androidNews.count ?? 0
            case .iOS:
                return iOSNews.count ?? 0
            case .WebFrontEnd:
                return webFrontEndNews.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var news = [GankNews]()
        if let type = menuBar.selectedItem {
            switch type {
            case .Android:
                news = androidNews
            case .iOS:
                news = iOSNews
            case .WebFrontEnd:
                news = webFrontEndNews
            }
        }
        
        let singleNews = news[indexPath.row]
        let images = singleNews.images
        
        let cell = images != nil ? tableView.dequeueReusableCellWithIdentifier(Constant.imageCellReuseidentifier): tableView.dequeueReusableCellWithIdentifier(Constant.textCellReuseidentifier)
        
        if let imageCell  = cell as? MainViewImageCell {
            imageCell.gankNew = singleNews
        } else if let textcell = cell as? MainViewTextCell {
            textcell.gankNews = singleNews
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var news = [GankNews]()
        if let type = menuBar.selectedItem {
            switch type {
            case .Android:
                news = androidNews
            case .iOS:
                news = iOSNews
            case .WebFrontEnd:
                news = webFrontEndNews
            }
        }
        
        let selectedNew = news[indexPath.row]
        let urlStr = selectedNew.url
        let detailVC = NewsDetailViewController()
        if let _urlStr = urlStr {
            let selectedURL = NSURL(string: _urlStr)
            detailVC.reuqestURL = selectedURL
        }
        detailVC.title = selectedNew.desc
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController {
    func menuBar(munubar: MenuBar, didSelectedItem item: itemType) {
        tableView.reloadData()
        header.endRefreshing()
    }
}

