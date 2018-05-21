//
//  RootController.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/18.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    lazy var textArr : NSMutableArray = { () -> NSMutableArray in
        var textArr :NSMutableArray = NSMutableArray()
        textArr.add("轮播图改版了")
        textArr.add("SDWebImage下载图片")
        textArr.add("通过模型统一设置属性")
        textArr.add("希望大家支持一下")
        textArr.add("谢谢大家!!!")
        return textArr
    }()
    
    var scrollView : UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        let backItem : UIBarButtonItem = UIBarButtonItem.init()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem
        
        setupScrollView()
    }
    
    @objc func setupScrollView(){
        let scrollView : UIScrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView = scrollView
        view.addSubview(scrollView)
    }
}
