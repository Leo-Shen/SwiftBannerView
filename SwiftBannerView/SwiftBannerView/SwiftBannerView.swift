//
//  SwiftBannerView.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

@objc protocol SwiftBannerViewDelegate {
   @objc optional func bannerView(_ bannerView :SwiftBannerView, collectionView :UICollectionView, collectionViewCell : SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index :Int)
}

class SwiftBannerView: UIView , UICollectionViewDelegate , UICollectionViewDataSource {
    weak var delegate : SwiftBannerViewDelegate?
    
    // 滚动图片的倍数
    private var kAccount : Int = 100
    // 流水布局的 layout
    private var layout : UICollectionViewFlowLayout?
    // 设置 总的父控件
    private var collectionView : UICollectionView?
    // Cell 的 指定字符串 : 缓存池获取
    private let SwiftBannerViewCellID : String = "SwiftBannerViewCellID"
    // collectionView 的 cell
    private var collectionViewCell : SwiftBannerCollectioniewCell!
    // collectionView 的 '数据源' 数组
    private var ImageArr : NSMutableArray = NSMutableArray()
    // 默认的 banner 数据 模型
    private var defaultModel : SwiftBannerModel?
    // 定时器
    private var bannerTimer : Timer?
    // pageControl
    private var pageControl : SwiftBannerPageControl?
    
    // 公开一个 bannerModel , 用于设置 banner的各种属性
    public var bannerModel : SwiftBannerModel? {
        didSet{
            
            // 1.先移除定时器
            removeTimer()
            
            // 需要定时器
            if bannerModel?.isNeedTimerRun == true {

                if bannerModel?.timeInterval != nil {
                    if Double((bannerModel?.timeInterval)!) <= 0 {
                        bannerModel?.timeInterval = defaultModel?.timeInterval
                    }
                }else{
                    bannerModel?.timeInterval = defaultModel?.timeInterval
                }
                setupTimer()
            }
            
            // 需要循环播放
            if bannerModel?.isNeedCycle == true {
                jumpToLocation()
            }else{
                kAccount = 1
                jumpToLocation()
                self.collectionView?.reloadData()
            }
            
            // 是否有 占位图
            if bannerModel?.placeHolder == nil {
                bannerModel?.placeHolder = defaultModel?.placeHolder!
            }
            
            // pageControl
            if bannerModel?.pageControlStyle == nil {
                bannerModel?.pageControlStyle = defaultModel?.pageControlStyle!
            }
            
            if bannerModel?.currentPageIndicatorTintColor == nil {
                bannerModel?.currentPageIndicatorTintColor = defaultModel?.currentPageIndicatorTintColor!
            }
            
            if bannerModel?.pageIndicatorTintColor == nil {
                bannerModel?.pageIndicatorTintColor = defaultModel?.pageIndicatorTintColor!
            }
            
            if bannerModel?.isNeedPageControl == false {
                bannerModel?.isNeedPageControl = defaultModel?.isNeedPageControl!
            }else{
                pageControl?.isHidden = false
            }
            
            if bannerModel?.pageControlImgArr == nil { // 系统
                let bannerM = SwiftBannerModel()
                bannerM.pageControlStyle = bannerModel?.pageControlStyle!
                bannerM.pageIndicatorTintColor = bannerModel?.pageIndicatorTintColor!
                bannerM.currentPageIndicatorTintColor = bannerModel?.currentPageIndicatorTintColor!
                bannerM.currentPage = 0
                bannerM.numberOfPages = ImageArr.count
                pageControl?.bannerModel = bannerM
            }else{ // 自定义
                bannerModel?.numberOfPages = ImageArr.count
                pageControl?.bannerModel = bannerModel
            }
            
            
            defaultModel = bannerModel
            
            if bannerModel?.isNeedCycle == true {
                jumpToLocation()
            }else{
                kAccount = 1
                jumpToLocation()
                collectionView?.reloadData()
            }
            
        }
    }
    
    
    private var locationImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for image in locationImageArr {
                let isImage : Bool = image is UIImage
                assert(isImage, "\n **加载本地图片,LocationImgArr 内必须添加 图片(UIImage) ** \n")
                ImageArr.add(image)
            }
            initPageAndJumpToLocation()
        }
    }
    
    private var networkImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for url in networkImageArr {
                let isUrl : Bool = url is String
                assert(isUrl, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                
                var isHttpString : Bool = false
                if (url as! String).hasPrefix("http") {
                    isHttpString = true
                }
                assert(isHttpString, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                ImageArr.add((url as! String))
            }
            initPageAndJumpToLocation()
        }
    }
    
    private var blendImageArr : NSMutableArray = [] {
        didSet{
            ImageArr.removeAllObjects()
            collectionView?.reloadData()
            
            for item in blendImageArr {
                var isBlend : Bool = false
                if item is UIImage {
                    isBlend = true
                }
                
                if item is String {
                    if (item as! String).hasPrefix("http") {
                        isBlend = true
                    }
                }
                
                assert(isBlend, "\n **加载混合图片,blendImgArr 内必须添加 图片URL的绝对路径 或者 图片(UIImage) ** \n");
                ImageArr.add(item)
            }
            initPageAndJumpToLocation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化 collectionView
        initCollectionView()
        // 初始化 基本数据
        initDefaultData()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func bannerViewLocationImgArr(_ locationImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView {
        
        let bannerView = SwiftBannerView(frame: frame)
        if locationImgArr?.count == 0 {
            return bannerView
        }
        bannerView.locationImageArr = locationImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
        
    }
    
    class func bannerViewNetworkImgArr(_ networkImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView{
        
        let bannerView = SwiftBannerView(frame: frame)
        if networkImgArr?.count == 0 {
            return bannerView
        }
        bannerView.networkImageArr = networkImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
        
    }
    
    class func bannerViewBlendImgArr(_ blendImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView {
        
        let bannerView = SwiftBannerView(frame: frame)
        if blendImgArr?.count == 0 {
            return bannerView
        }
        bannerView.blendImageArr = blendImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
        
    }
    
    private func initCollectionView(){
        
        // 流水布局的 滚动基本属性
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = self.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.layout = layout
        
        // collectionView
        let collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SwiftBannerCollectioniewCell.self, forCellWithReuseIdentifier: SwiftBannerViewCellID)
        
        self.collectionView = collectionView
        addSubview(collectionView)
    }
    
    private func initDefaultData(){
        defaultModel = SwiftBannerModel()
        
        defaultModel?.isNeedCycle = false
        defaultModel?.isNeedTimerRun = false
        defaultModel?.timeInterval = 1.5
        defaultModel?.placeHolder = UIImage.init(named: "SwiftBannerViewSource.bundle/placeHolder.png")!
        
        // pageControl
        defaultModel?.isNeedPageControl = false
        defaultModel?.currentPageIndicatorTintColor = UIColor.green
        defaultModel?.pageIndicatorTintColor = UIColor.white
        defaultModel?.pageControlStyle = .right
        defaultModel?.currentPage = 0
        
    }
    
    private func initPageAndJumpToLocation(){
        initPageControl()
        jumpToLocation()
    }
    
    private func initPageControl(){
        if self.pageControl != nil {
            return
        }
        
        if ImageArr.count == 1 {
            return
        }
        
        let pageControl = SwiftBannerPageControl.init(frame: CGRect(x: 0, y: self.height - 30, width: self.width, height: 30))
        pageControl.isHidden = true
        self.pageControl = pageControl
        addSubview(pageControl)
    }
    
    private func jumpToLocation(){
        guard ImageArr.count > 1 else {
            return
        }
        
        var index : Int = ImageArr.count * kAccount / 2
        if self.bannerModel?.isNeedCycle == nil {
            index = 0
        }
        
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(ImageArr.count == 1) {
            return 1
        }else {
            return ImageArr.count * kAccount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftBannerViewCellID, for: indexPath)
        
        collectionViewCell = cell as! SwiftBannerCollectioniewCell
        
        let row : Int = indexPath.row % ImageArr.count
        
        if ImageArr[row] is String { // 如果是 字符串
            if (ImageArr[row] as! String).hasPrefix("http") { // 如果是 url
                collectionViewCell.placeHolder = bannerModel?.placeHolder
                collectionViewCell.url = ImageArr[row] as? String
            }
        }else { // 如果不是字符串 : 是图片
            if ImageArr[row] is UIImage { // 是图片
                collectionViewCell.image = ImageArr[row] as? UIImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row : Int = indexPath.row % ImageArr.count
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let delegate = self.delegate {
            delegate.bannerView?(self, collectionView: collectionView, collectionViewCell: cell as! SwiftBannerCollectioniewCell, didSelectItemAtIndexPath: row)
        }
    }
    
    private func setupTimer(){
        if ImageArr.count == 1 {
            return
        }
        
        if self.bannerModel?.isNeedTimerRun == false {
            return
        }
        
        if self.bannerTimer != nil {
            removeTimer()
        }
        
        let timer = Timer(timeInterval: (self.bannerModel?.timeInterval)!, repeats: true) { [weak self] (timer) in
            self?.timeRun()
        }
        self.bannerTimer = timer
        
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    private func removeTimer(){
        self.bannerTimer?.invalidate()
        self.bannerTimer = nil
    }
    
    @objc private func timeRun(){
        
        if ImageArr.count == 0 {
            return
        }
        
        var index = Int(((self.collectionView?.contentOffset.x)! / (self.layout?.itemSize.width)!)) + 1;
        
        if index == ImageArr.count * kAccount || index == 0 {
            
            guard kAccount != 1 else {
                return
            }
            
            index = ImageArr.count * kAccount / 2
            
            self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false);
        }
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX : CGFloat = (scrollView.contentOffset.x + scrollView.width) / scrollView.width
        autoreleasepool {
            let arr : NSArray = "\(contentOffsetX)".components(separatedBy: ".") as NSArray
            if arr.count == 2 {
                let lastStr : String = arr.lastObject as! String
                if lastStr == "0" {
                    let index : Int = (Int(contentOffsetX) - 1) % ImageArr.count
                    pageControl?.currentPage = index
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    deinit {
        print("SwiftBannerView -> deinit")
    }
}
