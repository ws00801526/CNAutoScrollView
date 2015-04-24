//
//  OCAutoScrollController.swift
//  LearnSwift-AutoScrollView
//
//  Created by shscce on 15/4/24.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

import UIKit

class OCAutoScrollController: UIViewController,CNScrollViewDelegate {

    
    var autoScrollViewOC: CNScrollView!
    let localImages = ["0","1","2","3","4","5","6","7","8","9"]

    
    override func viewDidLoad() {
        autoScrollViewOC = CNScrollView(frame: CGRectMake(20, 60, 280, 200))
        autoScrollViewOC.delegate = self
        autoScrollViewOC.backgroundColor = UIColor.redColor()
        view.addSubview(autoScrollViewOC)
    }
    
    @IBAction func changeAutoScroll() {
        autoScrollViewOC.autoScroll = !autoScrollViewOC.autoScroll
    }
    
    //MARK:- CNAutoScrollViewDelegate<##>
    func numberOfPages() -> Int {
        return localImages.count
    }
    
    func imageNameOfIndex(index: Int) -> String! {
        return localImages[index]
    }
    
    func didSelectedIndex(index: Int) {
        println("you click autoScrollView index:\(index)")
    }
    
    func indexDidChange(index: Int) {
        println("scrollView currentIndexDidChange :\(index)")
    }
}
