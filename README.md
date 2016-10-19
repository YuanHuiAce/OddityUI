# OddityUI

奇点资讯IOS SDK

 ![Version Status](https://img.shields.io/badge/OddityUI-1.0.1-brightgreen.svg)
 ![license MIT](https://img.shields.io/cocoapods/l/JSQMessagesViewController.svg)
 ![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)

------------------------

现阶段使用的第三方框架很多，可以精简。

具体的修改方式，会根据我们公司业务需求发生变化。

主要依赖的第三方框架为

````
Installing FLAnimatedImage (1.0.12)
Installing MJRefresh (3.1.12)
Installing PINCache (2.3)
Installing PINRemoteImage (2.1.4)
Installing Realm (2.0.0)
Installing RealmSwift (2.0.0)
Installing SnapKit (3.0.1)
Installing XLPagerTabStrip (6.0.0)
````

我们公司内部的框架为
````
Installing JMGTemplateEngine (0.0.2) // 该框架是一个大神的，但是大神没有疯装 Cocoapods 为了方便即成，自己封装了下
Installing OddityUI (0.1.3)
````

------------------------

## 安装

````ruby
# For latest release in cocoapods
pod 'OddityUI'
````

## 使用

iOS9引入了新特性App Transport Security (ATS)。

新特性要求App内访问的网络必须使用HTTPS协议。
但是现在公司的项目使用的是HTTP协议，使用私有加密方式保证数据安全。现在也不能马上改成HTTPS协议传输。

请在Info.plist中添加NSAppTransportSecurity类型Dictionary。
在NSAppTransportSecurity下添加NSAllowsArbitraryLoads类型Boolean,值设为YES

Swift :
````swift

import OddityUI

let viewController = OddityViewControllerManager.shareManager.getsChannelsManagerViewController() // 首先获取UIViewController ，之后怎么跳转或者展示就很简单了

````

Objective-C :
````objective-c

#import <OddityUI/OddityUI-Swift.h>

ChannelsManagerViewController *viewController = [[OddityViewControllerManager shareManager]getsChannelsManagerViewController];
````

## PS

因为频道数据越早获取越好。所以 如果可以情 使用 `OddityModal` 提早请求 频道信息。

不调用也可以。我在 OddityViewControllerManager ViewDidLoad的时候已经调用了。只是可能会慢。以后会优化


Swift :
````swift

import OddityModal


ChannelAPI.nsChsGet()

````

Objective-C :
````objective-c

... 不知道 怎么了。调用不到放啊。在研究～
````

## 项目结构

```
├── OddityUI  
│   ├── ChannelsManagerViewController             频道列表分页滑动展示视图
│   ├── ChannelViewController                     频道管理视图 删除 移动
│   ├── NewFeedListViewController                 新闻列表 根据 不同的频道展示不同的信息
│   └── DetailAndCommitViewController             新闻详情 分也滑动 视图
│   │    ├── CommitViewController                 新闻的评论信息展示视图
│   │    └── DetailViewController                 新闻详情信息 展示视图
│   │
│   └──── Util
│       │   ├── Extension
│       │   │   ├── UIColor
│       │   │   ├── UIFont
│       │   │   ├── UIImage
│       │   │   ├── Regex
│       │   │   ├── NSAttributedStringLoader
│       │   │   └── Curly
│       │   └── Custom
│       │       ├── BorderView
│       │       ├── TablviewCell 以及 CollectionViewCell
│       │       └── Object
│       ├── Resources  # 资源文件，如图片、音频等
│       ├── Tool
│       │   ├── Service
│       │   └── Vendor
│       └── View
└── OddityModal  数据 －－－ 太难搞了。先这样
```

## 版本修复问题记录

V 0.1.0

* 初步上线
* 完善Swift版本

V 0.1.3

* 修复删除不同频道，不同频道的处理问题
* 修复获取新闻，新闻的归属问题
* 修复频道排序页面

V 0.1.4

* 修复刷新数据时，列表崩溃现象

V 0.1.5

* 修复ChannelViewControllerCached 缓存器的缓存条件。实现可以显示多个 ChannelsManagerViewController
* 添加一个 `malloc_error_break` 的 BreakPoint 可以优化崩溃现象，继续跟进ing

V 0.1.8

* 新增 `OdditySetting` 来实现提供给使用者 设置 当前SDK的一些设置项
* 新增 `OddityUIDelegate` 来实现提供给使用者 检测 用户的一些动作
* 修复ChannelViewControllerCached 缓存器的缓存条件。之前的筛选条件选择失败，导致视图会不是唯一的

V 0.1.9

* 修改 `ChannelsManagerViewController` 为手码
* 一些优化

## 未来

未来还长，，，不着急
