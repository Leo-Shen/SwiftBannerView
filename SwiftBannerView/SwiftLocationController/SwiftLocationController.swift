//
//  SwiftLocationController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftLocationController: RootController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationImArr = NSMutableArray()
        
        locationImArr.add(UIImage.init(named: "1")!)
        locationImArr.add(UIImage.init(named: "2")!)
        locationImArr.add(UIImage.init(named: "3")!)
        locationImArr.add(UIImage.init(named: "4")!)
        locationImArr.add(UIImage.init(named: "5")!)
        
        let bannerModel = SwiftBannerModel()
        
        bannerModel.placeHolder = UIImage.init(named: "1")
        bannerModel.isNeedTimerRun  = true
        bannerModel.timeInterval = 1
        bannerModel.isNeedPageControl = true
        bannerModel.isNeedCycle = true
        
        bannerModel.pageControlStyle = SwiftBannerPageControlStyle.middle
        bannerModel.pageControlImgArr = [UIImage.init(named: "pageControlSelected1")!,UIImage.init(named: "pageControlUnSelected1")!]
        
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y: 0, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel
        
        view.addSubview(bannerView)
    }
    
    func bannerView(_ bannerView: SwiftBannerView, collectionView: UICollectionView, collectionViewCell: SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index: Int) {
        print("\(index)")
    }
    
}
