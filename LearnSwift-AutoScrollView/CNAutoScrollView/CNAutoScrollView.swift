//
//  CNAutoScrollView.swift
//  LearnSwift-AutoScrollView
//
//  Created by shscce on 15/4/23.
//  Copyright (c) 2015年 shscce. All rights reserved.
//

import UIKit


@objc protocol CNAutoScrollViewDelegate: NSObjectProtocol{
    func numbersOfPages()->Int
    func imageNameOfIndex(index: Int) -> String!
    optional func didSelectedIndex(index: Int)
    optional func currentIndexDidChange(index: Int)
}

@objc class CNAutoScrollView: UIView,UIScrollViewDelegate {
    
    //MARK:- private 属性<##>
    private var viewWidth: CGFloat{
        return self.bounds.width
    }
    private var viewHeight: CGFloat{
        return self.bounds.height
    }
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var timer: NSTimer?
    private var centerImageView: UIImageView!
    private var leftImageView: UIImageView!
    private var rightImageView: UIImageView!
    private var isAutoScrolling: Bool = false
    
    //MARK:- 公共属性<##>
    var currentIndex = 0{
        didSet{
            
            if currentIndex < 0{//判断currentIndex应该为最后一张
                currentIndex = delegate!.numbersOfPages() - 1
            }else if currentIndex > delegate!.numbersOfPages() - 1{//判断currentIndex是否应该是第一张
                currentIndex = 0
            }
            reloadImage()
            
        }
    }
    
    //监听deleagte didSet方法
    var delegate: CNAutoScrollViewDelegate?{
        didSet{
            if delegate!.numbersOfPages() == 1{
                scrollView.scrollEnabled = false
            }
            pageControl.numberOfPages = delegate!.numbersOfPages()
            reloadImage()
        }
    }
    
    //是否开启自动滚动
    var autoScroll: Bool = false{
        didSet{
            if autoScroll && isAutoScrolling == false{
                addTimer()
            }else {
                removeTimer()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initScrollView()
        self.initPageControl()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 初始化界面
    
    //初始化pageControl
    func initPageControl(){
        pageControl = UIPageControl(frame: CGRectMake(0, viewHeight - 40, viewWidth, 20))
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        pageControl.pageIndicatorTintColor = UIColor.greenColor()
        pageControl.hidesForSinglePage = true
        addSubview(pageControl)
    }
    
    //初始化UIScrollView
    func initScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0, 0, viewWidth, viewHeight))
        scrollView.delegate = self;
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for index in 0...2{
            switch index{
                case 0:
                    leftImageView = createImageView(index)
                case 1:
                    centerImageView = createImageView(index)
                case 2:
                    rightImageView = createImageView(index)
                default:
                    break
            }
        }
        
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(centerImageView)
        scrollView.addSubview(rightImageView)
        
        scrollView.contentSize = CGSizeMake(3*viewWidth, viewHeight)
        addSubview(scrollView)
    }
    
    //创建imageView 并添加点击手势
    func createImageView(index: Int) -> UIImageView{
        var imageView = UIImageView(frame: CGRectMake(CGFloat(index)*viewWidth, 0, viewWidth, viewHeight))
        imageView.autoresizingMask = .None
        imageView.layer.masksToBounds = true
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        return imageView
    }
    
    //处理图片点击事件
    func handleTap(tap: UITapGestureRecognizer){
        if let deledate = self.delegate{
            if delegate!.respondsToSelector("didSelectedIndex:"){
                delegate!.didSelectedIndex!(currentIndex)
            }
        }
    }
    
    //MARK:- 相关操作
    
    //根据index设置相关图片
    func setImage(leftImageIndex:Int = 9,centerImageIndex:Int = 0,rightImageIndex:Int = 1){
        
        //从代理中获取每个图片的图片名称
        let leftImageName = self.delegate!.imageNameOfIndex(leftImageIndex)
        let centerImageName = self.delegate!.imageNameOfIndex(centerImageIndex)
        let rightImageName = self.delegate!.imageNameOfIndex(rightImageIndex)
        
        
        //此处使用的是本地图片 也可以使用网络图片
//        if let leftImage = UIImage(named: leftImageName){
//            leftImageView.image = leftImage
//        }
//        if let centerImage = UIImage(named: centerImageName){
//            centerImageView.image = centerImage
//        }
//        if let rightImage = UIImage(named: rightImageName){
//            rightImageView.image = rightImage
//        }
        
        //使用网络图片
        leftImageView.setImageWithUrl(leftImageName)
        centerImageView.setImageWithUrl(centerImageName)
        rightImageView.setImageWithUrl(rightImageName)

    }
    
    func reloadImage(){
        var leftImageIndex = 0,rightImageIndex = 0
        
        if currentIndex == 0{
            leftImageIndex = self.delegate!.numbersOfPages() - 1
            rightImageIndex = 1
        }else if currentIndex == self.delegate!.numbersOfPages() - 1{
            leftImageIndex = self.delegate!.numbersOfPages() - 2
            rightImageIndex = 0
        }else{
            leftImageIndex = currentIndex - 1
            rightImageIndex = currentIndex + 1
        }
        
        setImage(leftImageIndex: leftImageIndex, centerImageIndex: currentIndex, rightImageIndex: rightImageIndex)
        scrollView.setContentOffset(CGPointMake(viewWidth, 0), animated: false)
        pageControl.currentPage = currentIndex
    }
    
    
    func addTimer(){
        
        timer = NSTimer(timeInterval: 2.0, target: self, selector: "nextPage", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        self.isAutoScrolling = true
        
    }
    
    func removeTimer(){
        
        timer?.invalidate()
        timer = nil
        self.isAutoScrolling = false
        
    }
    
    func nextPage(){
        
        UIView.animateWithDuration(0.3, animations: { [unowned self] () -> Void in
            self.scrollView.setContentOffset(CGPointMake(2*self.viewWidth, 0), animated: false)
            }) { [unowned self] (isFinish) -> Void in
                self.currentIndex++
        }
        
    }
    
    //MARK:- UIScrollView Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
            removeTimer()

    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //判断 是否允许自动滚动,允许则重新添加定时器,继续滚动
        if autoScroll{
            addTimer()
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX: CGFloat = scrollView.contentOffset.x
        var tempIndex = currentIndex
        if offsetX < viewWidth*0.7{ //判断是否向左滑
            tempIndex--
        }else if offsetX > viewWidth*1.3{ //判断是否是向右滑动
            tempIndex++
        }
        if currentIndex == tempIndex {
            return
        }
        currentIndex = tempIndex
        //重新配置imageView的image
        //执行代理currentIndexDidChange
        if let deledate = self.delegate{
            if delegate!.respondsToSelector("currentIndexDidChange:"){
                delegate!.currentIndexDidChange!(currentIndex)
            }
        }
    }
}


extension UIImageView{
    
    //此方法也可以使用SDWebImage类库替代 这里只是个暂时使用的测试方法
    func setImageWithUrl(urlString: String){
        let backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(backgroundQueue) { () -> Void in
            let imageData = self.getImageData(urlString)
            dispatch_async(dispatch_get_main_queue(), {[unowned self] () -> Void in
                if let realImageData = imageData{
                    let image = UIImage(data: realImageData)
                    if let realImage = image{
                        self.image = realImage
                    }
                }
            })
        }
    }
    
    func getImageData(urlString: String) -> NSData?{
        let documentPathArray = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath:String = documentPathArray[0] as! String
        let imagePath: String! = documentPath  + "/\(urlString.md5String())"
        NSFileManager.defaultManager().fileExistsAtPath(imagePath)
        if NSFileManager.defaultManager().fileExistsAtPath(imagePath){
            return NSData(contentsOfFile: imagePath)
        }else{
            let imageData = NSData(contentsOfURL: NSURL(string: urlString)!)
            if let realImageData = imageData{
                realImageData.writeToFile(imagePath, options: NSDataWritingOptions.allZeros, error: nil)
            }
            return imageData
        }
    }
    
}

extension String{
    
    //字符串MD5加密
    func md5String() -> String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        var hash =  NSMutableString()
        for i in 0..<digestLen{
            hash.appendFormat("%02x", result[i])
        }
        
        return String(hash)
    }
}