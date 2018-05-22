//
//  SwiftBannerModel.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/21.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

// pageControl 的显示 方式
public enum SwiftBannerPageControlStyle : Int {
    case right
    case left
    case middle
}

class SwiftBannerModel: NSObject {
    // 是否需要 无限循环
    var isNeedCycle : Bool? // 默认 false
    // 是否需要 定时器跑
    var isNeedTimerRun : Bool? // 默认 false
    // 网络图片的 占位图
    var placeHolder : UIImage?
    // 定时器的 时间
    var timeInterval : Double? // 默认为 1.5s
    
    // 是否需要 pageControl
    var isNeedPageControl : Bool? // 默认为 NO
    
    // 自定义 pageControl 的图片数组 , 如果设置,则是自定义 pageControl
    var pageControlImgArr : NSArray?
    // pageControl 的 当前下标
    var currentPage : Int?
    // pageControl 的总数
    var numberOfPages : Int?
    // 系统pageControl 的 当前选中颜色, 默认绿色
    var currentPageIndicatorTintColor : UIColor?
    // 系统pageControl 的 当前未选中颜色, 默认白色
    var pageIndicatorTintColor : UIColor?
    // pageControl 的显示样式, 默认居右
    var pageControlStyle : SwiftBannerPageControlStyle?
    
}
