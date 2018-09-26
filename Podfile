platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def shared_pods
    pod 'BlocksKit', '~> 2.0'
    pod 'DateTools', '~> 1.6'
    # WLNetworking依赖AFNetworking和AliyunOSSiOS
    pod 'AFNetworking', '3.2.1'
    pod 'AliyunOSSiOS', :git => 'https://github.com/aliyun/AliyunOSSiOS.git'
    pod 'Masonry'
    pod 'BaiduMapKit','4.1.1' #百度地图SDK
    pod 'BMKLocationKit','1.2.0' #百度定位SDK
    # 二维码扫描
    pod 'ZBarSDK', '~> 1.3.1'
    pod 'UITableView+FDTemplateLayoutCell'
    pod 'YYKit'
    pod 'FMDB/SQLCipher', '~> 2.5' # FMDB：Sqlite封装库
    pod 'WebViewJavascriptBridge'
    pod 'KMNavigationBarTransition'
    pod 'MJRefresh','3.1.15.3'
    # 验证码
    pod 'MMCaptchaView'
    
    # 使用： https://github.com/ChenYilong/CYLTabBarController
    pod 'CYLTabBarController', '~> 1.17.4'
    pod 'QMUIKit'
    
    # webview
#    pod 'AXWebViewController', '~> 0.6.0'
    pod 'AXNavigationBackItemInjection'
    pod 'NJKWebViewProgress'
    pod 'Aspects'
    pod 'AXPracticalHUD'
end

target 'MineSweeper' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each  do |target|
        target.build_configurations.each  do |config|
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'   # 忽略block里使用self的警告
        end

        if target.name == "FMDB"
            target.build_configurations.each do |config|
                header_search = {"HEADER_SEARCH_PATHS" => "SQLCipher"}
                config.build_settings.merge!(header_search)
            end
        end
    end
end

