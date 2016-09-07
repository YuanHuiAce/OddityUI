//
//  New.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift


public class StringObject: Object {
    dynamic public var value = ""
}

public class IntegetObject: Object {
    dynamic public var channel = 0
}

///  频道的数据模型
public class New: Object {
    
    dynamic public var nid = 1 /// 新闻ID
    dynamic public var url = ""  /// 新闻Url
    dynamic public var docid = "" /// 用于获取评论的 docid
    dynamic public var title = "" /// 新闻标题
    dynamic public var searchTitle = "" /// 新闻标题
    dynamic public var ptime = ""  /// 新闻事件
    dynamic public var ptimes = NSDate()
    dynamic public var pname = ""  /// 新闻来源
    dynamic public var purl = "" /// 来源地址
    dynamic public var channel = 0 /// 频道ID
    dynamic public var collect = 0 /// 收藏数
    dynamic public var concern = 0 /// 关心数
    dynamic public var comment = 0 /// 评论数
    dynamic public var style = 0 /// 列表图格式，0、1、2、3
    
    public let channelList = List<IntegetObject>() /// 图片具体数据
    
    public let imgsList = List<StringObject>() /// 图片具体数据
    
    
    dynamic public var province = "" // 省
    dynamic public var city = "" // 城市
    dynamic public var district = "" // 区
    
    dynamic public var isdelete = 0 // 区
    
    /**
     标识 新闻是不是被阅读 0 未阅读 1 已经阅读
     如果该新闻已经被阅读，那么在展示他的时候，就应该对其标题的色值进行浅色处理
     */
    dynamic public var isread = 0 // 是否阅读
    
    /**
     标识 新闻是不是热点新闻， 0 为非热点新闻 1是热点新闻 默认为非热点新闻
     如果该新闻是一个假的新闻，那么在这个新闻应该被展示的UItablVIewCell 就应该显示为对应的 点击刷新新闻 Cell
     */
    dynamic public var ishotnew = 0 /// 是不是热点新闻
    
    /**
     标识 该新闻是不是 加的数据，0 不是。 1 是。 默认为 不是假新闻 即 0
     如果该新闻是一个假的新闻，那么在这个新闻应该被展示的UItablVIewCell 就应该显示为对应的 点击刷新新闻 Cell
     
     在用户进行数据刷新的时候，首先会删除所有的假新闻。之后判断用户是否需要生成假新闻，如果需要那么在判断所加载的新闻的个数
     如果个数符合要求，那么就会加入一个假新闻。假新闻要在数据加载前的那一条数据之前添加，所以要判断好时间。
     默认的区分假新闻的id为频道id 但是如果频道为  奇点 那么他的ID 为…………  忘却了。。。大概是－1
     这样在展示的时候就可以做到有假新闻的展示了
     */
    dynamic public var isidentification = 0
    
    /**
     标识 新闻的收藏状态。 0 未收藏 1 已收藏 默认为 未收藏
     新闻的是否收藏状态，如果是0 的话，说明该新闻没有被收藏。如果已经被收藏，这也没什么影响
     */
    dynamic public var iscollected = 0
    
    /**
     标识 新闻的关心状态。 0 未关心 1 已关心 默认为 未关心
     新闻的是否收藏状态，如果是0 的话，说明该新闻没有被收藏。如果已经被收藏，这也没什么影响
     */
    dynamic public var isconcerned = 0
    
    /**
     标识 是不是搜索出来的。 0 不是 1 是 默认为 不是
     首先我们要做的就是在搜索之前，将所有搜索状态未 1 的，设置为 0.
     但是如果用户在上拉刷新的时候是不需要进行这个设置的。
     */
    dynamic public var issearch = 0
    
    /**
     标示是不是关注的新闻，这里会有一个判断
     如果获取的新闻没有存在在数据库那么直接更改起 channle 为一个 不可能存在的值。之后表示该值为1
     如果获取的新闻已经存在在数据库里了，那么只修改 isfoucus 就可以了。
     */
    dynamic public var isfocus = 0
    
    /**
     标示是不是关注的新闻，这里会有一个判断
     如果获取的新闻没有存在在数据库那么直接更改起 channle 为一个 不可能存在的值。之后表示该值为1
     如果获取的新闻已经存在在数据库里了，那么只修改 isfoucus 就可以了。
     */
    dynamic public var isFocusArray = 0 
    
    dynamic public var orderIndex = 10
    
    
    dynamic public var rtype = 0
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
}

public extension New{
    
    /**
     删除标注
     
     - parameter cid: 频道ID
     */
    public class func deleteIdentification(cid:Int){
        
        let realm = try! Realm()
        // 删除标记当前频道的标记对象
        try! realm.write({
            if cid == 1 {
                
                realm.delete(realm.objects(New).filter("isidentification = 1 AND ishotnew = 1"))
            }else{
                
                realm.delete(realm.objects(New).filter("isidentification = 1 AND channel = %@",cid))
            }
        })
    }
    
    
    /**
     讲新闻设置为已读
     */
    public func isRead(){
        
        let realm = try! Realm()
        
        try! realm.write {
            
            self.isread = 1
        }
    }
    /**
     获取关注新闻
     
     - returns: <#return value description#>
     */
    public class func allArray() -> Results<New>{
        
        let realm = try! Realm()
        
        return realm.objects(New.self).sorted("ptimes", ascending: false)
    }
    
    /// 自杀
    public func suicide(){
        
        let realm = try! Realm()
        
        try! realm.write({
            
            realm.create(New.self, value: ["nid":self.nid,"isdelete":1], update: true)
        })
    }
    
    /**
     获取当前新闻的详情对象
     
     - returns: 新闻详情
     */
    public func getNewContentObject() -> NewContent?{
        
        let realm = try! Realm()
        
        return realm.objects(NewContent.self).filter("nid = \(self.nid)").first
    }
}