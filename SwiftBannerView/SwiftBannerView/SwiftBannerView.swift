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
        }
    }
    
    
    private var locationImageArr : NSMutableArray = [] {
        didSet{
            for image in locationImageArr {
                let isImage : Bool = image is UIImage
                assert(isImage, "\n **加载本地图片,LocationImgArr 内必须添加 图片(UIImage) ** \n")
                self.ImageArr.add(image)
            }
            
            // goto
            
        }
    }
    
    private var networkImageArr : NSMutableArray = [] {
        didSet{
            for url in networkImageArr {
                let isUrl : Bool = url is String
                assert(isUrl, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                
                var isHttpString : Bool = false
                if (url as! String).hasPrefix("http") {
                    isHttpString = true
                }
                assert(isHttpString, "\n **加载网络图片,NetWorkImgArr 内必须添加 图片URL的绝对路径** \n")
                self.ImageArr.add((url as! String))
            }
        }
    }
    
    private var blendImageArr : NSMutableArray = [] {
        didSet{
            
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
    
    class func bannerViewLocationImgArr(_ locationImgArr :NSMutableArray?,
                                        bannerFrame frame :CGRect) -> SwiftBannerView {
        let bannerView = SwiftBannerView(frame: frame)
        if locationImgArr?.count == 0 {
            return bannerView
        }
        bannerView.locationImageArr = locationImgArr?.mutableCopy() as! NSMutableArray
        return bannerView
    }
    
    class func bannerViewNetworkImgArr(_ networkImgArr :NSMutableArray?,bannerFrame frame :CGRect) -> SwiftBannerView{
        let bannerView = SwiftBannerView(frame: frame)
        if networkImgArr?.count == 0 {
            return bannerView
        }
        bannerView.networkImageArr = networkImgArr?.mutableCopy() as! NSMutableArray
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
        self.defaultModel    = SwiftBannerModel()
        
        self.defaultModel?.isNeedCycle = false
        self.defaultModel?.isNeedTimerRun = false
        self.defaultModel?.timeInterval = 1.5
        self.defaultModel?.placeHolder = UIImage.init(named: "SwiftBannerViewSource.bundle/placeHolder.png")!
    }
    
    private func jumpToLocation(){
        guard self.ImageArr.count > 1 else {
            return
        }
        
        var index : Int = self.ImageArr.count * kAccount / 2
        if self.bannerModel?.isNeedCycle == nil {
            index = 0
        }
        
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.ImageArr.count == 1) {
            return 1
        }else {
            return self.ImageArr.count * kAccount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftBannerViewCellID, for: indexPath)
        
        self.collectionViewCell = cell as! SwiftBannerCollectioniewCell
        
        let row : Int = indexPath.row % self.ImageArr.count
        
        if self.ImageArr[row] is String { // 如果是 字符串
            if (self.ImageArr[row] as! String).hasPrefix("http") { // 如果是 url
                self.collectionViewCell.url = self.ImageArr[row] as? String
            }
        }else { // 如果不是字符串 : 是图片
            if self.ImageArr[row] is UIImage { // 是图片
                self.collectionViewCell.image = self.ImageArr[row] as? UIImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row : Int = indexPath.row % self.ImageArr.count
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let delegate = self.delegate {
            delegate.bannerView?(self, collectionView: collectionView, collectionViewCell: cell as! SwiftBannerCollectioniewCell, didSelectItemAtIndexPath: row)
        }
    }
    
    private func setupTimer(){
        if self.ImageArr.count == 1 {
            return
        }
        
        if self.bannerModel?.isNeedTimerRun == false {
            return
        }
        
        if self.bannerTimer != nil {
            removeTimer()
        }
        
        let timer = Timer.init(timeInterval:(self.bannerModel?.timeInterval)!, target:self, selector: #selector(timeRun), userInfo: nil, repeats: true)
        self.bannerTimer = timer
        
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    private func removeTimer(){
        self.bannerTimer?.invalidate()
        self.bannerTimer = nil
    }
    
    @objc private func timeRun(){
        
        if self.ImageArr.count == 0 {
            return
        }
        
        var index = Int(((self.collectionView?.contentOffset.x)! / (self.layout?.itemSize.width)!)) + 1;
        
        if index == self.ImageArr.count * kAccount || index == 0 {
            
            guard kAccount != 1 else {
                return
            }
            
            index = self.ImageArr.count * kAccount / 2
            
            self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false);
        }
        self.collectionView?.scrollToItem(at: IndexPath.init(item: index, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: true);
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
}
