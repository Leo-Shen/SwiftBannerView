# SwiftBannerView
####无限循环轮播器:
* 本地图片
* 网络图片
* 混合图片(本地&&网络)

![image](https://github.com/LuKane/KNImageResource/blob/master/BannerView/BannerViewNetWork.gif?raw=true)![image](https://github.com/LuKane/KNImageResource/blob/master/BannerView/BannerViewlocate.gif?raw=true)![image](https://github.com/LuKane/KNImageResource/blob/master/BannerView/BannerViewBlend.gif?raw=true)

## 一.功能描述及要点
- [x] 1.无限图片轮播器,加载 '本地图片' && '网络图片' && '本地和网络的混合图片'
- [x] 2.Kingfisher加载网络图片
- [x] 3.通过代理方法执行图片的点击事件
- [x] 4.collectView工作原理实现无限滚动
- [x] 5.设置UIPageControl的位置:(左,中,右) 以及颜色设置
- [x] 6.设置自定义PageControl,位置:(左,中,右),自定义图片
- [x] 7.设置描述文字的位置:(左,中,右) 以及字体颜色,大小,背景颜色,背景透明度
- [x] 8.多张图片滚动时 文字的多种显示样式.单张图片时的样式
- [x] 9.通过BannerModel的属性,左右边距 && 是否有圆角

## 二.方法定义及调用
### 1.类方法创建BannerView:本地图片 || 网络图片 || 混合图片
```
// 本地图片
class func bannerViewLocationImgArr(_ locationImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView
// 网络图片
class func bannerViewNetworkImgArr(_ networkImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView
// 混合图片 (网络 || 本地图片)
class func bannerViewBlendImgArr(_ blendImgArr :NSMutableArray?, bannerFrame frame :CGRect) -> SwiftBannerView
```

### 2.设置bannerView的占位图,定时器的时间
```
let bannerModel = SwiftBannerModel() // 统一通过 设置 模型来设置 里面的参数
bannerModel.isNeedTimerRun  = true // 需要定时跑
bannerModel.timeInterval = 3 // 改变 定时器时间
bannerModel.placeHolder = UIImage.init(named: "1") // 设置占位图
```

### 3.设置bannerView的PageControl的属性
```
// 1.自定义 PageControl
let bannerModel = SwiftBannerModel() // 统一通过 设置 模型来设置 里面的参数
bannerModel.pageControlStyle = SwiftBannerPageControlStyle.right // pageControl 居右
bannerModel.pageControlImgArr = [UIImage.init(named: "pageControlSelected1")!,UIImage.init(named: "pageControlUnSelected1")!] // 自定义pageControl 的图片
bannerModel.textArr = self.textArr.copy() as? NSArray // 显示的文字
bannerModel.textChangeStyle = .follow // 文字 的显示样式

// 2.系统自带PageControl
let bannerModel = SwiftBannerModel() // 统一通过 设置 模型来设置 里面的参数
bannerModel.isNeedPageControl = true // 默认系统PageControl
bannerModel.pageControlStyle = SwiftBannerPageControlStyle.middle // pageControl 居中
```

### 5.1 让 BannerView 无限循环 (2018-1-11 日更新)
```
bannerModel.isNeedCycle = true // 让bannerView 无限循环, 默认 不循环
```
### 5.2 BannerView 新增 左右边距 和 是否有圆角 (2018-05-04更新)
```
bannerModel.leftMargin = 10
bannerModel.bannerCornerRadius = 8
```

### 6.设置bannerView 介绍文字的属性
```
let bannerModel = SwiftBannerModel() // 统一通过 设置 模型来设置 里面的参数
bannerModel.textArr = self.textArr.copy() as? NSArray // 显示的文字 // 设置文字, 注意:如果文字和图片的数量不相符,则没有文字.如果不要文字,则不传
bannerModel.textChangeStyle = .stay // 文字 的显示样式 // 设置文字展示的样式
```
### 6.图片的点击

##### 1>遵守 SwiftBannerViewDelegate

##### 2>设代理 bannerView.delegate = self

##### 3>执行方法 func bannerView(_ bannerView: SwiftBannerView, collectionView: UICollectionView, collectionViewCell: SwiftBannerCollectioniewCell, didSelectItemAtIndexPath index: Int) 
