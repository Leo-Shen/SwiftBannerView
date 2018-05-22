//
//  SwiftNetworkController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftNetworkController: RootController ,SwiftBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationImArr = NSMutableArray()
        
        locationImArr.add("http://ww1.sinaimg.cn/mw690/9bbc284bgw1f9rk86nq06j20fa0a4whs.jpg")
        locationImArr.add("http://ww3.sinaimg.cn/mw690/9bbc284bgw1f9qg0bazmnj21hc0u0dop.jpg")
        locationImArr.add("http://ww2.sinaimg.cn/mw690/9bbc284bgw1f9qg0nw7zbj20rs0jntk7.jpg")
        locationImArr.add("http://ww2.sinaimg.cn/mw690/9bbc284bgw1f9qg0utssrj20sg0hyx0o.jpg")
        locationImArr.add("http://ww2.sinaimg.cn/mw690/9bbc284bgw1f9qg10w0w1j20s40jsah1.jpg")
        
        let bannerModel = SwiftBannerModel()
        
        bannerModel.placeHolder = UIImage.init(named: "1")
        bannerModel.isNeedTimerRun  = true
        bannerModel.isNeedCycle = true
        bannerModel.timeInterval = 1
        print("\(String(describing: bannerModel.placeHolder))")
        
        let bannerView = SwiftBannerView.bannerViewNetworkImgArr(locationImArr, bannerFrame: CGRect(x: 0, y: 0, width: view.width, height: 180))
        bannerView.bannerModel = bannerModel
        
        bannerView.delegate = self
        view.addSubview(bannerView)
    }
}
