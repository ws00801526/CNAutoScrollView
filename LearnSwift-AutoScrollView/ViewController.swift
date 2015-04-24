//
//  ViewController.swift
//  LearnSwift-AutoScrollView
//
//  Created by shscce on 15/4/23.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,CNAutoScrollViewDelegate {
    
    var autoScrollView: CNAutoScrollView!
    
    let imageArray = ["http://h.hiphotos.baidu.com/image/w%3D310/sign=48e74f4004082838680dda158898a964/0df3d7ca7bcb0a469d876f666863f6246a60afcc.jpg","http://g.hiphotos.baidu.com/image/w%3D310/sign=e48354ced63f8794d3ff4e2fe21a0ead/f636afc379310a55c5df6982b54543a9832610c8.jpg","http://e.hiphotos.baidu.com/image/w%3D310/sign=5d32f79b9e82d158bb825fb0b00a19d5/d53f8794a4c27d1e5e204ab119d5ad6eddc43844.jpg","http://f.hiphotos.baidu.com/image/w%3D310/sign=e00797554b540923aa69657fa259d1dc/b812c8fcc3cec3fd91b5ce03d488d43f87942738.jpg","http://e.hiphotos.baidu.com/image/w%3D310/sign=b117ceca41166d223877139576220945/342ac65c103853431f1ece209113b07ecb8088da.jpg","http://e.hiphotos.baidu.com/image/w%3D310/sign=628941202a381f309e198ba899004c67/d6ca7bcb0a46f21f42af2d4bf4246b600c33ae0b.jpg","http://c.hiphotos.baidu.com/image/w%3D310/sign=9bfdbdc980025aafd33278cacbecab8d/9f2f070828381f30a3ca76a0ab014c086f06f0ec.jpg"]
    let localImageView = ["0","1","2","3","4","5","6","7","8","9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoScrollView = CNAutoScrollView(frame: CGRectMake(20, 60, 280, 200))
        autoScrollView.backgroundColor = UIColor.grayColor()
        autoScrollView.delegate = self
        view.addSubview(autoScrollView)
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        autoScrollViewOC.delegate = self
//        view.addSubView(autoScrollViewOC)
        
        println("name :\(UIDevice.currentDevice().name)")
        println("model :\(UIDevice.currentDevice().model)")
        println("localizedModel :\(UIDevice.currentDevice().localizedModel)")
        println("systemName :\(UIDevice.currentDevice().systemName)")
        println("systemVersion :\(UIDevice.currentDevice().systemVersion)")
        println("uuid :\(UIDevice.currentDevice().identifierForVendor.UUIDString)")
        
    }

    @IBAction func changeAutoScroll(sender: UIButton) {
        autoScrollView.autoScroll = !autoScrollView.autoScroll
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CNAutoScrollViewDelegate<##>
    func numbersOfPages() -> Int {
        return imageArray.count
    }
    
    func imageNameOfIndex(index: Int) -> String! {
        return imageArray[index]
    }

    func didSelectedIndex(index: Int) {
        println("you click autoScrollView index:\(index)")
    }
    
    func currentIndexDidChange(index: Int) {
        println("autoScrollView currentIndex didChange :\(index)")
    }
   
    func indexDidChange(index: Int) {
        println("scrollView currentIndexDidChange :\(index)")
    }
    
}


