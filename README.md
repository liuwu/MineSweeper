# MineSweeper
一个小的外接项目：番茄

使用前，先安装cocoapods。
使用 pod install 进行第三方库引入，安装完成打开MineSweeper.xcworkspace

pod安装完成后，把Pods-MineSweeper.debug.xcconfig和Pods-MineSweeper.release.xcconfig里面的下面内容删掉
-l"stdc++.6.0.9"

修改页面主题在：
Vendors-> Librarys -> QMUI -> Common -> Configuration -> QMUIConfigurationTemplate.m

接口请求地址修改：
Helpers -> WLNetworking -> Service -> WLServiceInfo.m中的 serviceBaseUrl；


目录结构：
MineSweeper：项目主目录
- AppDelegate :程序入口
- Configure：常用配置信息
- Classes：工程文件
    -- BaseModule：基础模块，用来定义基础类
    -- LoginModule：登录、注册模块
    -- MainModule：主模块，控制Tab栏的跳转
    -- HomeModule：群组页面模块
    -- ChatModule：聊天模块
    -- FriendModule：好友页面模块
    -- UserModule：我的模块
    
- Helpers：帮助组件
    -- WLPersistance：数据库封装，未使用
    -- WLNetworking：网络连接封装库
- Utilites：自定义扩展类
- Vendors：第三方库
    -- SDKs：第三方SDK，融云支付宝等
    -- Librarays：第三方组件
- Resources：资源文件，图片等
- Supporting Files：.plist文件





