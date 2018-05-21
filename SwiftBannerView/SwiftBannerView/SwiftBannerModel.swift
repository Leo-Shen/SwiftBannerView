//
//  SwiftBannerModel.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/21.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftBannerModel: NSObject {
    // 是否需要 无限循环
    var isNeedCycle : Bool? // 默认 false
    
    // 是否需要 定时器跑
    var isNeedTimerRun : Bool? // 默认 false
    
    // 网络图片的 占位图
    var placeHolder : UIImage?
    
    // 定时器的 时间
    var timeInterval : Double? // 默认为 1.5s
}
