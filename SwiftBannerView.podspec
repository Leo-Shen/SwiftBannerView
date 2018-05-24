Pod::Spec.new do |s|

s.name         = "SwiftBannerView"
s.version      = "1.0.0"
s.summary      = "A lightweight cycle bannerView by Swift 4.0,dependency 'Kingfiser 4.8.0' "

s.description  = <<-DESC
                 A lightweight cycle bannerView by Swift 4.0,dependency 'Kingfiser 4.8.0'.It provides three types include location , network and blend  "

                DESC

s.homepage     = "https://github.com/LuKane/SwiftBannerView"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


#s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" }

s.author             = { "LuKane" => "1169604556@qq.com" }
# s.social_media_url   = "https://www.jianshu.com/u/335eb27959ed"

s.swift_version = "4.0"
s.platform     = :ios, "10.0"

s.source       = { :git => "https://github.com/LuKane/SwiftBannerView.git", :tag => s.version }

s.source_files  = "SwiftBannerView/SwiftBannerView/*.swift"


# s.exclude_files = "Classes/Exclude"

# s.public_header_files = "Classes/**/*.h"


s.requires_arc = true
s.dependency 'Kingfisher'

end


