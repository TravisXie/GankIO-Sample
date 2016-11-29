//
//  MainViewCell.swift
//  Gank
//
//  Created by Blake on 11/25/16.
//  Copyright © 2016 Travis. All rights reserved.
//  主视图带图片的Cell

import UIKit
import SDWebImage

class MainViewImageCell: UITableViewCell, UIScrollViewDelegate {
    
    var gankNew: GankNews? {
        didSet {
            if let gankNew = gankNew {
                titleLabel.text = gankNew.desc ?? ""
                authorLabel.text = gankNew.who ?? ""
                timeLabel.text = gankNew.createdAt ?? ""
                imageURLs = gankNew.images?.map { NSURL(string: $0) }
            }
        }
    }
    
    var imageURLs: [NSURL?]? {
        didSet {
            setupImageView()
        }
    }
    
    func fetchImageWithURL(url: NSURL, withImageView imageView: UIImageView) {
        imageView.sd_setImageWithURL(url) { (image, _, _, _) in
            var newSize = CGSize.zero
            var imageRef: CGImageRef?
            
            if image != nil {
                if (image.size.width / image.size.height) < 1.0 {
                    newSize.width = image.size.width
                    newSize.height = image.size.width
                    
                    imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRect(x: 0, y: fabs(image.size.height - newSize.height) / 2, width: newSize.width, height: newSize.width))
                } else {
                    newSize.height = image.size.height
                    newSize.width = image.size.height * 1
                    
                    imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height))
                }
                
                if let imageRef = imageRef {
                    imageView.image = nil
                    imageView.image = UIImage(CGImage: imageRef)
                    imageView.contentMode = .ScaleAspectFill
                    imageView.clipsToBounds = true
                }
            }
        }
    }
    
    func setupImageView() {
        let scrollViewBounds = scrollView.bounds
        let imageCount = imageURLs?.count ?? 0
        if imageURLs != nil {
            for i in 0..<imageCount {
                let imageView = UIImageView(frame: CGRect(x: (CGFloat(i)*scrollViewBounds.width), y: 0, width: scrollViewBounds.width, height: scrollViewBounds.height))
                imageView.tag = i + 100
                let url = (imageURLs![i])!
                fetchImageWithURL(url, withImageView: imageView)
                scrollView.addSubview(imageView)
            }
        }
        
        let contentViewWidth = CGFloat(imageCount) * scrollViewBounds.width
        scrollView.contentSize = CGSize(width: contentViewWidth, height: 0)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        pageControl.numberOfPages = imageCount
        pageControl.hidden = imageCount != 1 ? false : true
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        let currentPage = page + 0.5
        pageControl.currentPage = Int(currentPage)
    }
}
