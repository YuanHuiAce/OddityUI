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
Using AFDateHelper (3.4.2)
Using Alamofire (3.4.2)
Using FLAnimatedImage (1.0.12)
Using MJRefresh (3.1.12)
Using PINCache (2.3)
Using PINRemoteImage (2.1.4)
Using Realm (1.0.2)
Using RealmSwift (1.0.2)
Using SnapKit (0.22.0)
Using XLPagerTabStrip (5.0.0)
````

我们公司内部的框架为
````
Using JMGTemplateEngine (0.0.2) // 该框架是一个大神的，但是大神没有疯装 Cocoapods 为了方便即成，自己封装了下
Using OddityModal (1.0.2)
Using OddityUI (1.0.1)
````

------------------------

## 安装

````ruby
# For latest release in cocoapods
pod 'OddityUI'
````

## 使用

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

## 未来

未来还长，，，不着急
