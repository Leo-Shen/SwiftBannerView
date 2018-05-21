//
//  SwiftLocationController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftLocationController: RootController ,SwiftBannerViewDelegate{
    
    
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
        print("\(String(describing: bannerModel.placeHolder))")
        
        
        let bannerView = SwiftBannerView.bannerViewLocationImgArr(locationImArr, bannerFrame: CGRect(x: 0, y: 0, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel
        
        bannerView.delegate = self
        view.addSubview(bannerView)
    }
    
    func bannerView(_ bannerView: SwiftBannerView, collectionView: UICollectionView, collectionViewCell: SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index: Int) {
        print("\(index)")
    }
    
}
