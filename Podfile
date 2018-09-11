platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

def shared_pods
    pod 'BlocksKit', '~> 2.0'
    pod 'DateTools', '~> 1.6'
    pod 'SDWebImage', '~> 3.7'
    pod 'AFNetworking', '3.2.1'
    pod 'Masonry'
    pod 'UITableView+FDTemplateLayoutCell'
    pod 'YYKit'
    pod 'FMDB/SQLCipher', '~> 2.5' # FMDB：Sqlite封装库
    pod 'WebViewJavascriptBridge'
    pod 'KMNavigationBarTransition'
    pod 'MJRefresh','3.1.15.3'
    pod 'CHIPageControl/Jaloro', '= 0.1.5'
end

target 'MineSweeper' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each  do |target|
        target.build_configurations.each  do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'   # 忽略block里使用self的警告
        end
    end
end

