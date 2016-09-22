//
//  Channel.swift
//  Journalism
//
//  Created by Mister on 16/5/18.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class Channel: Object {
    /// 频道ID
    dynamic open var id = 0
    /// 频道名称
    dynamic open var cname = ""
    /// 频道状态 0 未上线 1 已上线
    dynamic open var state = 0
    /// 频道排序
    dynamic open var orderindex = 100
    
    dynamic open var isdelete = 0

    override open static func primaryKey() -> String? {
        return "id"
    }
}


public extension Channel {
    
    /**
     获取正常的频道列表数据
     
     - returns: 正常的频道列表数据
     */
    public class func NormalChannelArray() -> Results<Channel> {
        
        return self.ChannelArray(NSPredicate(format: "isdelete = 0"))
    }
    
    /**
     获取正常的频道列表数据
     
     - returns: 正常的频道列表数据
     */
    public class func DeletedChannelArray() -> Results<Channel> {
        
        return self.ChannelArray(NSPredicate(format: "isdelete = 1"))
    }
    
    /**
     修改 频道的 排序 属性
     
     - parameter orderindex: 要改变成为的 排序 顺序
     */
    public func ChangeOrderIndex(_ orderindex:Int){
        let realm = try! Realm()
        try! realm.write { self.orderindex = orderindex }
    }
    
    /**
     根据提供的筛选条件进行数据的获取
     
     - parameter filters: 筛选条件
     
     - returns: 返回 数据
     */
    fileprivate class func ChannelArray(_ filters:NSPredicate...) -> Results<Channel>{
        let realm = try! Realm()
        var results = realm.objects(Channel).sorted(byProperty: "orderindex")
        for filter in filters { results =  results.filter(filter) }
        return results
    }
}
