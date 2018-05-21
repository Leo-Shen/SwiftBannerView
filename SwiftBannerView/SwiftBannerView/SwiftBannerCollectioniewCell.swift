//
//  SwiftBannerCollectioniewCell.swift
//  SwiftBannerView
//
//  Created by LuKane on 2018/5/21.
//  Copyright © 2018年 LuKane. All rights reserved.
//

import UIKit

class SwiftBannerCollectioniewCell: UICollectionViewCell {
    // 占位图
    var placeHolder : UIImage?
    
    // 网络图片 url
    var url : String? {
        didSet {
            self.imageView?.kf.setImage(with: URL.init(string: url!), placeholder: self.placeHolder, options: [.fromMemoryCacheOrRefresh], progressBlock: {  (current, total) in

            }) { [weak self] (image, error, cacheType, url) in
                if(error == nil) {
                    self?.layoutSubviews()
                }
            }
        }
    }
    
    // 本地图片
    var image : UIImage? {
        didSet {
            self.imageView?.image = image
        }
    }
    
    // 当前图片的控件
    var imageView : UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView(){
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        self.imageView = imageView
        addSubview(imageView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = self.bounds
    }
    
}
